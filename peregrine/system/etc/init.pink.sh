#!/system/bin/sh

echo "[pink kernel] start tweaking" | tee /dev/kmsg

echo 4 > /sys/module/lpm_levels/enable_low_power/l2
echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
echo 1 > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 20 > /sys/module/cpu_boost/parameters/boost_ms
echo 998000 > /sys/module/cpu_boost/parameters/sync_threshold
echo 100000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
echo 1094000 > /sys/module/cpu_boost/parameters/input_boost_freq
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms

############################
# pink Tweaks
#
echo 192000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 192000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 192000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 192000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "fiops" > /sys/block/mmcblk0/queue/scheduler
echo "intelliactive" > /sys/devices/system/cpu/cpu0/scaling_governor
echo "intelliactive" > /sys/devices/system/cpu/cpu1/scaling_governor
echo "intelliactive" > /sys/devices/system/cpu/cpu2/scaling_governor
echo "intelliactive" > /sys/devices/system/cpu/cpu3/scaling_governor

echo 0 > /sys/kernel/sched/gentle_fair_sleepers
echo "[pink kernel] Various tweaks" | tee /dev/kmsg

############################
# Intelliplug activate
#
stop mpdecision
echo 1 > /sys/module/intelli_plug/parameters/intelli_plug_active
echo 1 > /sys/module/intelli_plug/parameters/touch_boost_active
echo 787200 > /sys/module/intelli_plug/parameters/screen_off_max
echo "[pink kernel] IntelliPlug Active" | tee /dev/kmsg


############################
# IntelliThermal V2 activate
#
echo "Y" > /sys/module/msm_thermal_v2/parameters/enabled
echo "12" > /sys/module/msm_thermal_v2/parameters/core_control_mask
echo "90" > /sys/module/msm_thermal_v2/parameters/limit_temp_degC
echo "85" > /sys/module/msm_thermal_v2/parameters/core_limit_temp_degC
echo "[pink kernel] IntelliThermal V2  Active" | tee /dev/kmsg

############################
# Enable Powersuspend
#
echo "3" > /sys/kernel/power_suspend/power_suspend_mode
echo "[pink kernel] PowerSuspend Active" | tee /dev/kmsg

############################
# Tweak UKSM
#
chown root system /sys/kernel/mm/uksm/cpu_governor
chown root system /sys/kernel/mm/uksm/run
chown root system /sys/kernel/mm/uksm/sleep_millisecs
chown root system /sys/kernel/mm/uksm/max_cpu_percentage
chmod 644 /sys/kernel/mm/uksm/cpu_governor
chmod 664 /sys/kernel/mm/uksm/sleep_millisecs
chmod 664 /sys/kernel/mm/uksm/run
chmod 644 /sys/kernel/mm/uksm/max_cpu_percentage
echo 1 > /sys/kernel/mm/uksm/run
echo 250 > /sys/kernel/mm/uksm/sleep_millisecs
echo quiet > /sys/kernel/mm/uksm/cpu_governor
echo 10 > /sys/kernel/mm/uksm/max_cpu_percentage
echo "[pink kernel] UKSM Active" | tee /dev/kmsg

############################
# Init VNSWAP
#
echo 402653184 > /sys/block/vnswap0/disksize
mkswap /dev/block/vnswap0
swapon /dev/block/vnswap0
echo "[pink kernel] VNSWAP Active" | tee /dev/kmsg

############################
# Init ZSWAP
#
echo 35 > /sys/module/zswap/parameters/max_pool_percent
echo 80 > /proc/sys/vm/swappiness
echo "[pink kernel] ZSWAP Tweak" | tee /dev/kmsg

############################
# Init Simple GPU
#
echo 1 > /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate
echo 7000 > /sys/module/simple_gpu_algorithm/parameters/simple_ramp_threshold
echo "[pink kernel] simple GPU Active" | tee /dev/kmsg

############################
# Script to launch frandom at boot by Ryuinferno @ XDA
#
# Seems unstable in lolipop
#
# chmod 644 /dev/frandom
# chmod 644 /dev/erandom
# mv /dev/random /dev/random.ori
# mv /dev/urandom /dev/urandom.ori
# ln /dev/frandom /dev/random
# chmod 644 /dev/random
# ln /dev/erandom /dev/urandom
# chmod 644 /dev/urandom
# echo "[pink kernel] frandom Active" | tee /dev/kmsg

############################
#
# Lioux
# Thanks to Lisan Xda
# Enable FQ Codel
#
# active fq_codel on the most used interfaces
tc qdisc add dev p2p0 root fq_codel
tc qdisc add dev rmnet0 root fq_codel
tc qdisc add dev wlan0 root fq_codel
# reduce txqueuelen to 0 until we have byte queue instead of a packet one
echo 0 > /sys/class/net/p2p0/tx_queue_len
echo 0 > /sys/class/net/rmnet0/tx_queue_len
echo 0 > /sys/class/net/wlan0/tx_queue_len
# suitable configuration to help reduce network latency
echo 2 > /proc/sys/net/ipv4/tcp_ecn
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 1 > /proc/sys/net/ipv4/tcp_dsack
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
echo 1 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/route/flush
echo 1 > /proc/sys/net/ipv4/tcp_rfc1337
echo 0 > /proc/sys/net/ipv4/ip_no_pmtu_disc
echo 1 > /proc/sys/net/ipv4/tcp_fack
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
echo "4096 39000 187000" > /proc/sys/net/ipv4/tcp_rmem
echo "4096 39000 187000" > /proc/sys/net/ipv4/tcp_wmem
echo "187000 187000 187000" > /proc/sys/net/ipv4/tcp_mem
echo 1 > /proc/sys/net/ipv4/tcp_no_metrics_save
echo 1 > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
echo "[pink kernel] FQ Codel Active" | tee /dev/kmsg

