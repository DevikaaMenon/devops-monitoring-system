#!/usr/bin/env bash
# T1.4: laptop readiness check.
# Usage: ./scripts/check-env.sh "<your name>" <M1|M2|M3>
# Prints a pass/fail summary and a Markdown row to paste into docs/environment.md.
set -uo pipefail

NAME=${1:-"$(git config user.name 2>/dev/null || echo "$USER")"}
ROLE=${2:-"M?"}

pass=0; fail=0; warn=0
ok()   { printf '  \033[32mPASS\033[0m  %s\n' "$1"; pass=$((pass+1)); }
bad()  { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; fail=$((fail+1)); }
note() { printf '  \033[33mWARN\033[0m  %s\n' "$1"; warn=$((warn+1)); }
ver()  { command -v "$1" >/dev/null 2>&1 && eval "$2" 2>/dev/null | head -1 || echo "not installed"; }

echo "Readiness check for $NAME ($ROLE)"
echo

# OS
OS=$(lsb_release -ds 2>/dev/null || grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
case "$OS" in
  *"Ubuntu 24.04"*|*"Ubuntu 22.04"*) ok "OS: $OS" ;;
  *) note "OS: $OS (the Ansible roles target Ubuntu 22.04/24.04)" ;;
esac

# Architecture
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ok "Architecture: $ARCH" || note "Architecture: $ARCH (k8s_tools role downloads amd64 binaries, so adjust it)"

# CPU
CPUS=$(nproc)
[ "$CPUS" -ge 4 ] && ok "CPU cores: $CPUS (need >= 4)" || bad "CPU cores: $CPUS (need >= 4)"

# Virtualisation
VIRT=$(grep -Ec '(vmx|svm)' /proc/cpuinfo || true)
[ "$VIRT" -gt 0 ] && ok "Virtualisation flags present" || note "No vmx/svm flags (fine for the Docker driver; enable it in BIOS if you need VMs)"

# RAM
MEM_GB=$(awk '/MemTotal/ {printf "%d", $2/1024/1024 + 0.5}' /proc/meminfo)
if   [ "$MEM_GB" -ge 16 ]; then ok "RAM: ${MEM_GB} GiB (Minikube can get 6 GB)"; MK_MEM=6144; MK_CPU=4
elif [ "$MEM_GB" -ge 8 ];  then note "RAM: ${MEM_GB} GiB (use minikube_memory_mb=4096, minikube_cpus=2)"; MK_MEM=4096; MK_CPU=2
else bad "RAM: ${MEM_GB} GiB (need >= 8)"; MK_MEM=-; MK_CPU=-; fi

# Disk
DISK_GB=$(df -BG --output=avail "$HOME" | tail -1 | tr -dc '0-9')
[ "$DISK_GB" -ge 25 ] && ok "Free disk in \$HOME: ${DISK_GB} GiB (need >= 25)" || bad "Free disk in \$HOME: ${DISK_GB} GiB (need >= 25)"

# Python (ansible-core 2.21 needs >= 3.12)
PY=$(python3 -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")' 2>/dev/null || echo "0.0")
python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,12) else 1)' 2>/dev/null \
  && ok "Python: $PY (ansible-core 2.21 needs >= 3.12)" || bad "Python: $PY (ansible-core 2.21 needs >= 3.12)"

# Git
command -v git >/dev/null && ok "git: $(git --version | awk '{print $3}')" || bad "git not installed (sudo apt install git)"

# Tools that Phase 2 (Ansible) will install; report only
echo
echo "Tools that Phase 2 installs or pins (information only):"
DOCKER_V=$(ver docker "docker --version | awk '{print \$3}' | tr -d ,")
KUBECTL_V=$(ver kubectl "kubectl version --client -o json | python3 -c 'import sys,json; print(json.load(sys.stdin)[\"clientVersion\"][\"gitVersion\"])'")
MINIKUBE_V=$(ver minikube "minikube version --short")
ANSIBLE_V=$(ver ansible "ansible --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'")
printf '  docker   %s\n  kubectl  %s   (contract: v1.37.2)\n  minikube %s   (contract: v1.39.0)\n  ansible  %s   (contract: core 2.21.x)\n' \
  "$DOCKER_V" "$KUBECTL_V" "$MINIKUBE_V" "$ANSIBLE_V"
if command -v docker >/dev/null; then
  id -nG | tr ' ' '\n' | grep -qx docker && ok "User is in the docker group" || note "User not in docker group yet (the docker role adds it)"
fi

echo
echo "Result: $pass pass, $warn warn, $fail fail"
echo
echo "Paste this row into docs/environment.md:"
echo "| $NAME | $ROLE | $OS | $CPUS | ${MEM_GB} GiB | ${DISK_GB} GiB | $([ "$VIRT" -gt 0 ] && echo yes || echo no) | $PY | $DOCKER_V | $KUBECTL_V | $MINIKUBE_V | $MK_CPU / $MK_MEM | $(date +%F) |"

[ "$fail" -eq 0 ]
