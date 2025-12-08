import os
import csv
import time
import uuid
import shutil
import socket
import argparse
import ipaddress
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests
import urllib3
from tqdm import tqdm
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

# Disable insecure request warnings (if you use verify=False)
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Global flag to control printing
VERBOSE = False

def get_chrome_driver(headless=True, host_resolver_rule=None):
    """Return a configured headless Chrome webdriver with window size 1366x768."""
    options = Options()
    if headless:
        options.add_argument("--headless=new")
    if host_resolver_rule:
        options.add_argument(f"--host-resolver-rules={host_resolver_rule}")
    options.add_argument("--disable-gpu")
    options.add_argument("--ignore-certificate-errors")
    options.add_argument("--log-level=3")         # Suppress most logs
    options.add_experimental_option("excludeSwitches", ["enable-logging"])
    
    # Redirect service logs to null to suppress DevTools messages
    service = Service(ChromeDriverManager().install(), log_path=os.devnull)
    driver = webdriver.Chrome(service=service, options=options)
    webdriver
    driver.set_window_size(1366, 768)  # Set screenshot resolution
    return driver

def save_headers(headers, filepath):
    """Save headers dictionary to a text file."""
    with open(filepath, "w", encoding="utf-8") as f:
        for key, value in headers.items():
            f.write(f"{key}: {value}\n")

def process_row(row, output_dirs, columns_name, lang):
    """
    Process a single CSV row: take headers, screenshots, and return info for the report.
    Returns a dict with the HTML info and relative screenshot paths.
    """
    normal_screens_dir, resolved_screens_dir, headers_normal_dir, headers_resolved_dir, output_dir = output_dirs
    ip_column, port_column, subdomain_column = columns_name

    ip = row[ip_column].strip()
    puerto = row[port_column].strip()
    subdomain = row[subdomain_column].strip()

    # Decide protocol based on port
    scheme = "http" if puerto == "80" else "https" if puerto == "443" else "http"
    if puerto not in ["80", "443"]:
        print(f"Unknown port {puerto} for {subdomain}, defaulting to http")
    
    normal_url = f"{scheme}://{subdomain}"
    resolved_url = f"{scheme}://{ip}"

    # DNS resolution for display in report
    try:
        dns_ip = socket.gethostbyname(subdomain)
    except Exception as e:
        dns_ip = f"Error resolving DNS: {e}"
    
    # === NORMAL REQUEST & SCREENSHOT ===
    try:
        response_normal = requests.get(normal_url, timeout=10)
        headers_normal = response_normal.headers
    except Exception as e:
        headers_normal = {"Error": str(e)}
    headers_normal_path = os.path.join(headers_normal_dir, f"{subdomain.replace('.', '_')}_normal.txt")
    save_headers(headers_normal, headers_normal_path)
    if VERBOSE:
        print(f"Saved normal headers for {subdomain}")

    # Add a random suffix to the filename
    random_suffix_normal = uuid.uuid4().hex[:8]
    normal_screenshot_path = os.path.join(normal_screens_dir, f"{subdomain.replace('.', '_')}_(normal-{random_suffix_normal}).png")
    try:
        driver = get_chrome_driver()
        driver.get(normal_url)
        time.sleep(3)  # wait for page to load
        driver.save_screenshot(normal_screenshot_path)
        driver.quit()
        if VERBOSE:
            print(f"Saved normal screenshot for {subdomain}")
    except Exception as e:
        print(f"Error taking normal screenshot for {subdomain}: {e}")

    # === RESOLVED (IP override) REQUEST & SCREENSHOT ===
    try:
        response_resolved = requests.get(
            resolved_url, headers={"Host": subdomain}, verify=False, timeout=10
        )
        headers_resolved = response_resolved.headers
    except Exception as e:
        headers_resolved = {"Error": str(e)}
    headers_resolved_path = os.path.join(headers_resolved_dir, f"{subdomain.replace('.', '_')}_resolved.txt")
    save_headers(headers_resolved, headers_resolved_path)
    if VERBOSE:
        print(f"Saved resolved headers for {subdomain}")

    # Add a random suffix to the filename for resolved screenshot
    random_suffix_resolved = uuid.uuid4().hex[:8]
    resolved_screenshot_path = os.path.join(resolved_screens_dir, f"{subdomain.replace('.', '_')}_(resolved-{random_suffix_resolved}).png")
    host_rule = f"MAP {subdomain} {ip}"
    try:
        driver_resolved = get_chrome_driver(host_resolver_rule=host_rule)
        driver_resolved.get(normal_url)
        time.sleep(3)  # wait for page to load
        driver_resolved.save_screenshot(resolved_screenshot_path)
        driver_resolved.quit()
        if VERBOSE:
            print(f"Saved resolved screenshot for {subdomain}")
    except Exception as e:
        print(f"Error taking resolved screenshot for {subdomain}: {e}")
    
    if lang == "es":
        info_html = (
            f"<b>URL</b>: {normal_url}<br>"
            f"<b>DNS del subdominio</b>: {dns_ip}<br>"
            f"<b>IP forzada</b>: {ip}"
        )
    else:
        info_html = (
            f"<b>URL</b>: {normal_url}<br>"
            f"<b>Subdomain DNS</b>: {dns_ip}<br>"
            f"<b>Forced IP</b>: {ip}"
        )
    normal_img_rel = os.path.relpath(normal_screenshot_path, output_dir)
    resolved_img_rel = os.path.relpath(resolved_screenshot_path, output_dir)

    return {
        "IP": ip,
        "info": info_html,
        "normal_img": normal_img_rel,
        "resolved_img": resolved_img_rel
    }

def generate_html_report(rows, output_dir, options):
    lang, logo, title = options
    """Generate a prettified HTML report from a list of row dictionaries."""
    print(f"Generating HTML report...")
    report_file = os.path.join(output_dir, "report.html")
    with open(report_file, "w", encoding="utf-8") as f:
        f.write("<html><head><meta charset='utf-8'><title>WAF Bypass checker</title>")
        # Inline CSS for prettier styling
        f.write("""
            <style>
                body { font-family: Helvetica; background-color: #f4f4f4; }
                h1 { text-align: center; }
                table { margin: auto; border-collapse: collapse; width: 95%; }
                th, td { padding: 10px; text-align: center; border: 1px solid #ddd; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                tr:hover { background-color: #f1f1f1; }
                img { border: 1px solid #000000; }
            </style>
        """)
        f.write("</head><body>")
        if logo:
            f.write(f"<img src='{logo}' style='display: block; margin-left: auto; margin-right: auto; width: 15%; border: none;'>")
        if title:
            f.write(f"<h1>{title}</h1>")
        else:
            f.write(f"<h1>WAF Bypass Checker Report</h1>")
        f.write("<table>")
        if lang == "es":
            f.write("<tr><th>Información de la petición</th><th>Captura de pantalla (normal)</th><th>Captura de pantalla (forzando la resolución DNS)</th></tr>")
        else:
            f.write("<tr><th>Information of the request</th><th>Screenshot (normal)</th><th>Screenshot (forcing DNS resolution)</th></tr>")
        sorted_rows = sorted(rows, key=lambda row: ipaddress.ip_address(row['IP']))
        for row in sorted_rows:
            f.write("<tr>")
            f.write(f"<td>{row['info']}</td>")
            f.write(f"<td><img src='{row['normal_img']}' width='350'></td>")
            f.write(f"<td><img src='{row['resolved_img']}' width='350'></td>")
            f.write("</tr>")
        f.write("</table>")
        f.write("</body></html>")
    print(f"HTML report generated: {report_file}")

def main():
    global VERBOSE
    parser = argparse.ArgumentParser(description="Tries to evade WAF by forcing the resolution DNS of the domain passed to the IP passed. It takes screenshots, and generates an HTML report.")

    input_options = parser.add_argument_group("Input options")
    input_options.add_argument("--csv-file", required=True, help="Path to input CSV file.")
    input_options.add_argument("--ip-column", required=True, help="Name of the column containing the IP.")
    input_options.add_argument("--port-column", required=True, help="Name of the column containing the Port.")
    input_options.add_argument("--subdomain-column", required=True, help="Name of the column containing the Subdomain.")

    report = parser.add_argument_group("Report options")
    report.add_argument("--lang", choices=["en", "es"], default="en", help="Language selection for the report: 'en' for English or 'es' for Spanish (default: en).")
    report.add_argument("--output", "-o", required=True, help="Path to output directory.")
    report.add_argument("--logo", help="Path to a logo, to include on the report (default: no logo).")
    report.add_argument("--title", help="Title to use on the report (default: WAF Bypass Checker Report).")


    runtime = parser.add_argument_group("Runtime options")
    runtime.add_argument("--threads", type=int, default=4, help="Number of concurrent threads (default: 4).")
    runtime.add_argument("-v", "--verbose", action="store_true", help="Enable verbose printing.")

    args = parser.parse_args()

    # Set the global verbose flag
    VERBOSE = args.verbose

    # Check if the path exists and asks the user what to do
    if os.path.exists(args.output) and os.path.isdir(args.output):
        user_input = input(f"WARNING: The directory '{args.output}' already exists. Do you want to overwrite it? (yes/NO): ").strip().lower()
        if user_input in ["yes", "y"]:
            shutil.rmtree(args.output)
        else:
            print("Operation aborted by user.\nExiting program...")
            exit(1)

    # Create output directories if they do not exist
    os.makedirs(args.output, exist_ok=True)
    normal_screens_dir = os.path.join(args.output, "screen-subdomain")
    resolved_screens_dir = os.path.join(args.output, "screen-subdomain-IP")
    headers_normal_dir = os.path.join(args.output, "headers-subdomain")
    headers_resolved_dir = os.path.join(args.output, "headers-subdomain-IP")
    os.makedirs(normal_screens_dir, exist_ok=True)
    os.makedirs(resolved_screens_dir, exist_ok=True)
    os.makedirs(headers_normal_dir, exist_ok=True)
    os.makedirs(headers_resolved_dir, exist_ok=True)

    # Copy logo if passed
    if args.logo and os.path.isfile(args.logo):
        logo_filename = f"LOGO-{os.path.basename(args.logo)}"
        logo_path = os.path.join(args.output, logo_filename)  # Destination path
        shutil.copy(args.logo, logo_path)  # Copy the file
        if VERBOSE:
            print(f"Logo copied to: {logo_path}")

    # Package options
    output_dirs = (normal_screens_dir, resolved_screens_dir, headers_normal_dir, headers_resolved_dir, args.output)
    columns_name = (args.ip_column, args.port_column, args.subdomain_column)
    output_options = (args.lang, logo_filename, args.title)

    # Read CSV and check columns
    with open(args.csv_file, "r", encoding="utf-8") as csvFile:
        reader = csv.DictReader(csvFile)
        required_columns = set(columns_name)
        if not required_columns.issubset(set(reader.fieldnames)):
            print(f"ERROR: One or more column name not found.\nCheck the columns names passed: {required_columns}.")
            exit(1)
        rows = list(reader)

    total_rows = len(rows)
    print(f"Total rows to process: {total_rows}")

    report_rows = []
    with ThreadPoolExecutor(max_workers=args.threads) as executor:
        # Submit all tasks
        futures = [executor.submit(process_row, row, output_dirs, columns_name, args.lang) for row in rows]
        for future in tqdm(as_completed(futures), total=len(futures), desc="Processing"):
            try:
                result = future.result()
                report_rows.append(result)
            except Exception as e:
                print(f"Error processing a row: {e}")

    generate_html_report(report_rows, args.output, output_options)
    print("\nProcessing completed.\n\nExiting program...")

if __name__ == "__main__":
    main()
