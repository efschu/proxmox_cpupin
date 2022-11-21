# proxmox_cpupin
I'm using this script to pin the vcores exactly to physical cores to not loose L1/L2 Cache and clock frequency

# install
you must enable cgroups v1 by adding:

systemd.unified_cgroup_hierarchy=0 

to your kernel cmdline

