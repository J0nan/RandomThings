#!/bin/bash

# Authors: J0nan
# Version: 1.0.0
# Description: Automatically audits SSH configurations on multiple hosts using ssh-audit

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Check if ssh-audit is installed
if ! command -v ssh-audit &> /dev/null; then
  echo -e "${RED}Error:${NC} 'ssh-audit' is not installed or not in your PATH."
  echo -e "${YELLOW}Get it from:${NC} https://github.com/jtesta/ssh-audit"
  echo -e "${BLUE}Install using:${NC}
           sudo git clone https://github.com/jtesta/ssh-audit /opt/ssh-audit
           sudo ln -s /opt/ssh-audit/ssh-audit.py /usr/bin/ssh-audit"
  exit 1
fi

# Check if input file is given
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage:${NC} $0 targets.txt"
  exit 1
fi

INPUT_FILE="$1"

# Check if file exists
if [ ! -f "$INPUT_FILE" ]; then
  echo -e "${RED}Error:${NC} File '$INPUT_FILE' not found!"
  exit 1
fi

echo -e "${YELLOW}The ssh_audit command can report it has failed when it has not.${NC}"
echo -e "${BLUE}Starting SSH audits...${NC}"

# Loop through each line
while IFS= read -r target || [[ -n "$target" ]]; do
  # Skip empty or commented lines
  if [[ -z "$target" || "$target" == \#* ]]; then
    continue
  fi

  # Sanitize filename
  filename_safe=$(echo "$target" | tr ':' '-')

  echo -e "${GREEN}Auditing SSH on${NC} ${YELLOW}$target${NC}..."

  ssh-audit "$target" > "./SSH/ssh_audit_${filename_safe}.txt" 2>/dev/null

  # Check if output file exists and is not empty
  if [ -s "ssh_audit_${filename_safe}.txt" ]; then
    echo -e "${GREEN}✓ Completed:${NC} Report saved to ${BLUE}ssh_audit_${filename_safe}.txt${NC}"
  else
    echo -e "${RED}✗ Error:${NC} ssh-audit failed or returned no output for ${target}"
  fi
  echo ""

done < "$INPUT_FILE"

echo -e "${BLUE}All SSH audits complete.${NC}"
