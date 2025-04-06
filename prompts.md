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
