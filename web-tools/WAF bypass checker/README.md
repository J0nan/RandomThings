## Install Dependencies

```bash
pip install -r requirements.txt
```

## Run the script

```bash
python waf-bypass-checker.py input.csv /path/to/output_directory
```

The script will create (if not already present) subfolders:
- `screen-subdominio` (for the normal screenshots)
- `screen-subdominio-IP` (for the screenshots using the forced IP)
- `headers-subdominio` and `headers-subdominio-IP` for saving the response headers.

After processing, check the generated report.html in your output directory. It contains a table with:
- The web request info (URL, DNS-resolved IP, forced IP).
- The screenshot from the normal request.
- The screenshot from the IP-resolved request.
