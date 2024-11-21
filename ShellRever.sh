#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display the menu
function show_menu() {
    echo -e "${YELLOW}Linux Troubleshooting Toolkit${NC}"
    echo "1. Check Network Connectivity"
    echo "2. Check Failed Services"
    echo "3. Analyze Disk Space"
    echo "4. Fix File Permissions"
    echo "5. System Information"
    echo "6. User Management"
    echo "7. Exit"
    echo -n "Choose an option: "
}

# 1. Network Diagnostics
function check_network() {
    echo -e "${GREEN}Checking network connectivity...${NC}"
    echo -e "${BLUE}Ping Test (google.com):${NC}"
    ping -c 4 google.com
    echo
    echo -e "${BLUE}DNS Resolution Check:${NC}"
    nslookup google.com
    echo
    echo -e "${BLUE}Traceroute to google.com:${NC}"
    traceroute google.com
    echo
}

# 2. Service Check
function check_failed_services() {
    echo -e "${GREEN}Checking for failed services...${NC}"
    systemctl --failed
    echo
    echo -e "${BLUE}Recent logs for failed services:${NC}"
    journalctl -p 3 -xb | tail -n 20
    echo
}

# 3. Disk Space Check
function analyze_disk_space() {
    echo -e "${GREEN}Analyzing disk space...${NC}"
    df -h | grep -E '^Filesystem|/$'
    echo
}

# 4. Fix File Permissions
function fix_permissions() {
    echo -e "${GREEN}Fixing file permissions...${NC}"
    echo -e "${BLUE}Scanning for files with incorrect permissions in /var/www:${NC}"
    find /var/www -type f ! -perm 644 -exec chmod 644 {} \;
    find /var/www -type d ! -perm 755 -exec chmod 755 {} \;
    echo -e "${YELLOW}Permissions fixed in /var/www.${NC}"
    echo
}

# 5. System Information
function system_info() {
    echo -e "${GREEN}Gathering system information...${NC}"
    echo -e "${BLUE}Uptime:${NC}"
    uptime
    echo
    echo -e "${BLUE}Memory Usage:${NC}"
    free -h
    echo
    echo -e "${BLUE}Disk Usage:${NC}"
    df -h
    echo
    echo -e "${BLUE}CPU Load:${NC}"
    top -bn1 | grep "Cpu(s)"
    echo
}

# 6. User Management
function user_management() {
    echo -e "${GREEN}User Management Options:${NC}"
    echo "1. Create a new user"
    echo "2. Delete a user"
    echo "3. List all users"
    echo "4. Back to main menu"
    echo -n "Choose an option: "

    read -r um_choice
    case $um_choice in
        1) create_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) return ;;
        *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
    esac
}

# Function to create a new user
function create_user() {
    echo -n "Enter the username to create: "
    read -r username
    echo -n "Enter the groups to add the user to (comma separated): "
    read -r groups
    sudo adduser "$username"
    sudo usermod -aG $groups "$username"
    echo -e "${GREEN}User $username created and added to groups: $groups.${NC}"
}

# Function to delete a user
function delete_user() {
    echo -n "Enter the username to delete: "
    read -r username
    sudo deluser --remove-home "$username"
    echo -e "${GREEN}User $username deleted.${NC}"
}

# Function to list all users
function list_users() {
    echo -e "${GREEN}Listing all users:${NC}"
    cut -d: -f1 /etc/passwd
}

# Main Program Loop
while true; do
    show_menu
    read -r choice
    case $choice in
        1) check_network ;;
        2) check_failed_services ;;
        3) analyze_disk_space ;;
        4) fix_permissions ;;
        5) system_info ;;
        6) user_management ;;
        7) echo -e "${GREEN}Exiting...${NC}"; break ;;
        *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
    esac
done
