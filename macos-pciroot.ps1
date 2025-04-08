# Get PnP Devices and extract FriendlyName and InstanceID
$PnpDevices = Get-PnpDevice | Where-Object { $_.InstanceId -like "PCI*" }
$FriendlyName = $PnpDevices | Select-Object -ExpandProperty FriendlyName
$InstanceID = $PnpDevices | Select-Object -ExpandProperty InstanceId

# Get LocationPaths using InstanceID
$LocationPaths = @()
foreach ($id in $InstanceID) {
    $locationPath = Get-PnpDeviceProperty -KeyName DEVPKEY_Device_LocationPaths -InstanceId $id | Select-Object -ExpandProperty Data
    if ($locationPath) {
        $LocationPaths += $locationPath
    }
}

# Function macpci
function macpci {
    param(
        [string]$argument
    )

    $bus = ""
    $device = ""

    if ($argument.Substring(0, 1) -eq "0") {
        $bus = $argument.Substring(1, 1)
    } else {
        $bus = $argument.Substring(0, 2)
    }

    if ($argument.Substring(2, 1) -eq "0") {
        $device = $argument.Substring(3, 1)
    } else {
        $device = $argument.Substring(2, 2)
    }

    return "Pci(0x$bus,0x$device)"
}

# Process LocationPaths
$LocationPaths = $LocationPaths | Where-Object { $_ -notlike "*ACPI*" } | ForEach-Object {
    $stringPath = $_.ToString()
    $stringPath = $stringPath -replace "PCI", "" -replace "ROOT\(0\)#", "" -replace "\(", "" -replace "\)", "" -replace " ", ""

    $parts = $stringPath -split "#"
    $convertedParts = @()
    foreach ($part in $parts) {
        $convertedParts += (macpci $part)
    }
    $convertedParts -join "/"
}

# Generate and print output
$output = @()
for ($i = 0; $i -lt $FriendlyName.Length; $i++) {
    $line = "PciRoot(0x1)/" + $LocationPaths[$i] + "/" + $FriendlyName[$i]
    $output += $line
    Write-Host $line
}

# Export to file
$output | Out-File -FilePath ".\macos-pciroot.txt"