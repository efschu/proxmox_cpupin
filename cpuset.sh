#!/bin/bash
VMID="100"
VIRT_CORES="8-15,24-31"
HOST_CORES="0-7,16-23"

cset -m set -c $HOST_CORES -s machine.slice
cset -m set -c $VIRT_CORES -s user.slice

cpu_tasks() {
    expect <<EOF | sed -n 's/^.* CPU .*thread_id=\(.*\)$/\1/p' | tr -d '\r' || true
spawn qm monitor $VMID
expect ">"
send "info cpus\r"
expect ">"
EOF
}


    VCPUS=($(cpu_tasks))
    VCPU_COUNT="${#VCPUS[@]}"

    if [[ $VCPU_COUNT -eq 0 ]]; then
        echo "* No VCPUS for VM$VMID"
        exit 1
    fi

    echo "* Detected ${#VCPUS[@]} assigned to VM$VMID..."
    echo "* Resetting cpu shield..."

    # Set qemu task affinity
    core_match=(8 24 9 25 10 26 11 27 12 28 13 29 14 30 15 31)
    for CPU_INDEX in "${!VCPUS[@]}"
    do
        CPU_TASK="${VCPUS[$CPU_INDEX]}"
        echo "* Assigning ${core_match[$CPU_INDEX]} to $CPU_TASK..."
        cset proc --move --pid "$CPU_TASK" --toset=user.slice --force
        taskset -pc "${core_match[$CPU_INDEX]}" "$CPU_TASK"
    done
