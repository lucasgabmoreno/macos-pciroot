#!/bin/bash

# Function to convert PCI address from 00.0 to Pci(0x0,0x0) without leading zeros
macpci() {
    local pci_address="$1"
    IFS='.' read -r bus device <<< "$pci_address"
    
    # Remove leading zeros
    bus=$((10#$bus))  # Convert to decimal to remove leading zeros
    device=$((10#$device))  # Convert to decimal to remove leading zeros
    
    echo "Pci(0x${bus},0x${device})"
}

# Initialize arrays
declare -a pci
declare -a device

# Get the output of lspci -P
lspci_output=$(lspci -P)

# Process each line of the output
while IFS= read -r line; do
    # Split the line into PCI address and device name
    pci_address=$(echo "$line" | awk '{print $1}')
    device_name=$(echo "$line" | cut -d' ' -f2-)

    # Remove "00:" from the PCI address
    pci_address=${pci_address/00:/}

    # Store the PCI address and device name in arrays
    pci+=("$pci_address")
    device+=("$device_name")
done <<< "$lspci_output"

# Print the formatted output
for i in "${!pci[@]}"; do
    # Check if the PCI address contains a '/'
    if [[ "${pci[i]}" == *"/"* ]]; then
        # Split the address by '/'
        IFS='/' read -r -a parts <<< "${pci[i]}"
        pci_parts=""
        for part in "${parts[@]}"; do
            pci_parts+=$(macpci "$part")"/"
        done
        # Remove the trailing '/'
        pci_parts=${pci_parts%/}
    else
        # Apply macpci function directly
        pci_parts=$(macpci "${pci[i]}")
    fi

    # Print the final output
    echo "PciRoot(0x1)/$pci_parts ${device[i]}"
done
