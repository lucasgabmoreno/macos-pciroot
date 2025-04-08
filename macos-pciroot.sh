#!/bin/bash

# Capture lspci -P output and split into pci and devicename arrays
readarray -t lines < <(lspci -P)
pci=()
devicename=()

for line in "${lines[@]}"; do
  pci+=("$(echo "$line" | cut -d' ' -f1)")
  devicename+=("$(echo "$line" | cut -d' ' -f2-)")
done

# Process pci array
pci=("${pci[@]//00:/}")
pci=("${pci[@]//./}")
pci=("${pci[@]// /}")

# macpci function
macpci() {
  local arg="$1"
  local bus device

  if [[ "${arg:0:1}" == "0" ]]; then
    bus="${arg:1:1}"
  else
    bus="${arg:0:2}"
  fi

  if [[ -z "${arg:3:1}" ]]; then
    device="${arg:2:1}"
  else
    device="${arg:2:2}"
  fi

  echo "Pci(0x${bus},0x${device})"
}

# Process each pci entry
processed_pci=()
for item in "${pci[@]}"; do
  parts=($(echo "$item" | tr '/' '\n'))
  processed_parts=()
  for part in "${parts[@]}"; do
    processed_parts+=("$(macpci "$part")")
  done
  processed_pci+=("$(IFS=/; echo "${processed_parts[*]}")")
done

# Generate output and export to file
for i in "${!devicename[@]}"; do
  echo "PciRoot(0x1)/${processed_pci[i]} ${devicename[i]}"
done > macos-pciroot.txt

# Show file content
echo "Contents of macos-pciroot.txt:"
cat macos-pciroot.txt

# Unset variables and functions
unset lines pci devicename processed_pci
unset -f macpci
