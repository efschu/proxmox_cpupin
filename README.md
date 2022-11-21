# proxmox_cpupin
I'm using this script to pin the vcores exactly to physical cores to not loose L1/L2 Cache and clock frequency

# install
you must enable cgroups v1 by adding:

systemd.unified_cgroup_hierarchy=0 

to your kernel cmdline

add following to your VMID.conf:

args: -smp '16,cores=8,threads=2,sockets=1,maxcpus=16' -cpu 'host,topoext=on,host-cache-info=on,hv_ipi,hv_relaxed,hv_reset,hv_runtime,hv_spinlocks=0x1fff,hv_stimer,hv_synic,hv_time,hv_vapic,hv_vpindex,+kvm_pv_eoi,+kvm_pv_unhalt'
