#!/bin/bash

# Authors: J0nan
# Version: 1.0.0
# Description: Automatic launches testssl on multiple hosts

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Check if testssl is installed
if ! command -v testssl &> /dev/null; then
  echo -e "${RED}Error:${NC} 'testssl' is not installed or not in your PATH."
  echo -e "${YELLOW}Get it from:${NC} https://github.com/drwetter/testssl.sh"
  echo -e "${BLUE}Install using:${NC}
           sudo git clone https://github.com/drwetter/testssl.sh.git /opt/testssl.sh
           sudo ln -s /opt/testssl.sh/testssl.sh /usr/bin/testssl"
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

echo -e "${BLUE}Starting testssl.sh scans...${NC}"

# Loop through each line
while IFS= read -r target || [[ -n "$target" ]]; do
  # Skip empty or commented lines
  if [[ -z "$target" || "$target" == \#* ]]; then
    continue
  fi

  # Sanitize filename
  filename_safe=$(echo "$target" | tr ':' '-')
  echo -e "${GREEN}Running testssl against${NC} ${YELLOW}$target${NC}..."
  testssl --quiet -s -p -U -P -f -S --htmlfile "./TLS/testssl_${filename_safe}.html" "$target" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Completed:${NC} Report saved to ${BLUE}testssl_${filename_safe}.html${NC}"
  else
    echo -e "${RED}✗ Error:${NC} testssl failed on ${target}"
  fi
  echo ""

done < "$INPUT_FILE"

echo -e "${BLUE}All scans complete.${NC}"
