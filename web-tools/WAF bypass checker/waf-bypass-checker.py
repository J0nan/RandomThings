#!/usr/bin/env python3
import os
import csv
import argparse
import requests
import socket
import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

def get_chrome_driver(headless=True, host_resolver_rule=None):
    """Return a configured headless Chrome webdriver.
    
    If host_resolver_rule is provided, it is added as a Chrome option.
    """
    options = Options()
    if headless:
        # Using the new headless mode (if you prefer, you can use "--headless" instead)
        options.add_argument("--headless=new")
    if host_resolver_rule:
        options.add_argument(f"--host-resolver-rules={host_resolver_rule}")
    options.add_argument("--disable-gpu")
    # Ignore certificate errors (useful when connecting to an IP for HTTPS)
    options.add_argument("--ignore-certificate-errors")
    driver = webdriver.Chrome(ChromeDriverManager().install(), options=options)
    return driver

def save_headers(headers, filepath):
    """Save headers dictionary to a text file."""
    with open(filepath, "w", encoding="utf-8") as f:
        for key, value in headers.items():
            f.write(f"{key}: {value}\n")

def generate_html_report(rows, output_dir):
    """Generate an HTML report from a list of row dictionaries."""
    report_file = os.path.join(output_dir, "report.html")
    with open(report_file, "w", encoding="utf-8") as f:
        f.write("<html><head><meta charset='utf-8'><title>Web Request Report</title></head><body>")
        f.write("<h1>Web Request Report</h1>")
        f.write("<table border='1' cellspacing='0' cellpadding='5'>")
        f.write("<tr><th>Web Request Info</th><th>Screenshot (Normal)</th><th>Screenshot (Resolved IP)</th></tr>")
        for row in rows:
            f.write("<tr>")
            f.write(f"<td>{row['info']}</td>")
            f.write(f"<td><img src='{row['normal_img']}' width='300'></td>")
            f.write(f"<td><img src='{row['resolved_img']}' width='300'></td>")
            f.write("</tr>")
        f.write("</table></body></html>")
    print(f"HTML report generated: {report_file}")

def main():
    parser = argparse.ArgumentParser(description="Process CSV, take screenshots, and generate an HTML report.")
    parser.add_argument("csv_file", help="Path to input CSV file")
    parser.add_argument("output_dir", help="Path to output directory")
    args = parser.parse_args()

    # Create output directories if they do not exist
    os.makedirs(args.output_dir, exist_ok=True)
    normal_screens_dir = os.path.join(args.output_dir, "screen-subdominio")
    resolved_screens_dir = os.path.join(args.output_dir, "screen-subdominio-IP")
    headers_normal_dir = os.path.join(args.output_dir, "headers-subdominio")
    headers_resolved_dir = os.path.join(args.output_dir, "headers-subdominio-IP")
    os.makedirs(normal_screens_dir, exist_ok=True)
    os.makedirs(resolved_screens_dir, exist_ok=True)
    os.makedirs(headers_normal_dir, exist_ok=True)
    os.makedirs(headers_resolved_dir, exist_ok=True)

    report_rows = []

    # Read CSV
    with open(args.csv_file, "r", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        rows = list(reader)
    
    total_rows = len(rows)
    print(f"Total rows to process: {total_rows}")
    
    for idx, row in enumerate(rows):
        print(f"\nProcessing row {idx+1}/{total_rows}")
        ip_parseada = row["IP Parseada"].strip()
        puerto = row["Puerto"].strip()
        subdomain = row["Subdominio"].strip()

        # Decide protocol based on port
        if puerto == "80":
            scheme = "http"
        elif puerto == "443":
            scheme = "https"
        else:
            print(f"Unknown port {puerto} for {subdomain}, defaulting to http")
            scheme = "http"
        
        normal_url = f"{scheme}://{subdomain}"
        resolved_url = f"{scheme}://{ip_parseada}"
        
        # Get the DNS resolution for the subdomain (normal DNS lookup)
        try:
            dns_ip = socket.gethostbyname(subdomain)
        except Exception as e:
            dns_ip = f"Error resolving DNS: {e}"
        
        # === NORMAL REQUEST & SCREENSHOT ===
        # Perform normal request (DNS-resolved) and save headers
        try:
            response_normal = requests.get(normal_url, timeout=10)
            headers_normal = response_normal.headers
        except Exception as e:
            headers_normal = {"Error": str(e)}
        headers_normal_path = os.path.join(headers_normal_dir, f"{subdomain.replace('.', '_')}_normal.txt")
        save_headers(headers_normal, headers_normal_path)
        print(f"Saved normal headers for {subdomain} to {headers_normal_path}")

        # Take screenshot with Selenium (normal)
        normal_screenshot_path = os.path.join(normal_screens_dir, f"{subdomain.replace('.', '_')}_normal.png")
        try:
            driver = get_chrome_driver()
            driver.get(normal_url)
            time.sleep(3)  # wait for page to load
            driver.save_screenshot(normal_screenshot_path)
            driver.quit()
            print(f"Saved normal screenshot for {subdomain} to {normal_screenshot_path}")
        except Exception as e:
            print(f"Error taking normal screenshot for {subdomain}: {e}")

        # === RESOLVED (IP override) REQUEST & SCREENSHOT ===
        # For the resolved request, use the IP in the URL with a custom Host header.
        try:
            response_resolved = requests.get(
                resolved_url, headers={"Host": subdomain}, verify=False, timeout=10
            )
            headers_resolved = response_resolved.headers
        except Exception as e:
            headers_resolved = {"Error": str(e)}
        headers_resolved_path = os.path.join(headers_resolved_dir, f"{subdomain.replace('.', '_')}_resolved.txt")
        save_headers(headers_resolved, headers_resolved_path)
        print(f"Saved resolved headers for {subdomain} to {headers_resolved_path}")

        # For the screenshot using the forced IP, we use Chrome’s host resolver rule.
        resolved_screenshot_path = os.path.join(resolved_screens_dir, f"{subdomain.replace('.', '_')}_resolved.png")
        host_rule = f"MAP {subdomain} {ip_parseada}"
        try:
            driver_resolved = get_chrome_driver(host_resolver_rule=host_rule)
            # We still load the URL using the subdomain; Chrome will use the IP we forced.
            driver_resolved.get(normal_url)
            time.sleep(3)  # wait for page to load
            driver_resolved.save_screenshot(resolved_screenshot_path)
            driver_resolved.quit()
            print(f"Saved resolved screenshot for {subdomain} to {resolved_screenshot_path}")
        except Exception as e:
            print(f"Error taking resolved screenshot for {subdomain}: {e}")

        # Prepare the info for the HTML report.
        info_html = (
            f"URL: {normal_url}<br>"
            f"DNS Resolved IP: {dns_ip}<br>"
            f"Forced IP (CSV): {ip_parseada}"
        )
        # Get relative paths for the images (relative to the report file location).
        normal_img_rel = os.path.relpath(normal_screenshot_path, args.output_dir)
        resolved_img_rel = os.path.relpath(resolved_screenshot_path, args.output_dir)
        
        report_rows.append({
            "info": info_html,
            "normal_img": normal_img_rel,
            "resolved_img": resolved_img_rel
        })

    # Generate final HTML report
    generate_html_report(report_rows, args.output_dir)
    print("\nProcessing completed.")

if __name__ == "__main__":
    main()
