#!/bin/bash

function print_help() {
    cat <<EOF
Usage: $0 [options] <command> [args]

Options:
    --cpu PERCENT     CPU limit as percentage (1-100)
    --ram PERCENT     RAM limit as percentage (1-100)
    -h, --help       Show this help message

Example: 
    $0 --cpu 50 --ram 25 firefox
    $0 --cpu 25 stress-ng --cpu 1
    $0 --ram 50 python script.py
EOF
}

function validate_percentage() {
    local value=$1
    local name=$2

    if ! [[ $value =~ ^[0-9]+$ ]] || [ $value -lt 1 ] || [ $value -gt 100 ]; then
        echo "Error: $name must be a number between 1 and 100"
        exit 1
    fi
}

function run_with_limits() {
    local cmd=("systemd-run" "--scope")

    if [ ! -z "$cpu_limit" ]; then
        validate_percentage "$cpu_limit" "CPU limit"
        cmd+=("-p" "CPUQuota=${cpu_limit}%")
    fi

    if [ ! -z "$ram_limit" ]; then
        validate_percentage "$ram_limit" "RAM limit"
        local total_ram=$(free -m | awk '/^Mem:/{print $2}')
        local ram_bytes=$((total_ram * 1024 * 1024 * ram_limit / 100))
        cmd+=("-p" "MemoryMax=${ram_bytes}")
    fi

    if [ ${#command[@]} -eq 0 ]; then
        echo "Error: No command specified"
        print_help
        exit 1
    fi

    cmd+=("${command[@]}")
    "${cmd[@]}"
}

cpu_limit=""
ram_limit=""
command=()

while [[ $# -gt 0 ]]; do
    case $1 in
    --cpu)
        cpu_limit="$2"
        shift 2
        ;;
    --ram)
        ram_limit="$2"
        shift 2
        ;;
    -h | --help)
        print_help
        exit 0
        ;;
    *)
        command+=("$1")
        shift
        ;;
    esac
done

# Check if at least one limit is specified
if [ -z "$cpu_limit" ] && [ -z "$ram_limit" ]; then
    echo "Error: At least one limit (--cpu or --ram) must be specified"
    print_help
    exit 1
fi

run_with_limits
