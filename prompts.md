Linux
```
Using bash languaje, create two arrays called pci and device, taken form lspci -P and divided by the first space.

create a function called macpci, that convert 00.0 to Pci(0x0,0x0) but avoiding every numeric values ​​having a leading zero

In every value from pci array:
Remove "00:"
AND
if has /, divide value with / and apply macpci and join again parts with /
else apply macpci function

Print "PciRoot(0x1)/" plus every pci value plus space plus every device value.
```

AI used: [Duck.AI](https://duck.ai/)

Windows
```
Using PowerShell commands 

Create two arrays called FriendlyName and InstanceID, taken from  Get-PnpDevice | Where-Object { $_.InstanceId -like "PCI*" } | Format-List *
Create one more array called LocationPaths, taken from Get-PnpDeviceProperty -KeyName DEVPKEY_Device_LocationPaths -InstanceId value | select -Property Data using InstanceID values

Create a function called macpci, 
into macpci function, create 2 variables called bus and device
if (first character of the argument is zero) { bus variable is the second character of the argument }
if (first character of the argument is not zero)  { bus variable is the first character of the argument plus second character of the argument }
if (third character of the argument is zero) { device variable is the fourth character of the argument }
if (third character of the argument is not zero) { device variable is the third character of the argument plus fourth character of the argument }
the function returns:  "Pci(0x" plus bus plus ",0x" plus device plus ")" 

From LocationPath array, remove all values with ACPI
From LocationPath array, convert every value to string
From LocationPath array, in every value remove all "PCI"
From LocationPath array, in every value remove all "ROOT(0)#"
From LocationPath array, in every value remove all "("
From LocationPath array, in every value remove all ")"
From LocationPath array, in every value remove all " "

In every value of LocationPath, divide value by # and convert every part with macpci and join all parts again with "/"

Create a for loop using FriendlyName lenght as index, that print "PciRoot(0x1)/"LocationPaths plus FriendlyName 
Export all printed into a file in Get-Location directory called macos-pciroot.txt
Show all printed
```
AI used: [Gemini](https://gemini.google.com/)
