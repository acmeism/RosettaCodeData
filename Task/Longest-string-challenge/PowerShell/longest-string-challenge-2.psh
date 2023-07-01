@'
a
bb
ccc
ddd
ee
f
ggg
'@ -split "`r`n" |
    Group-Object  -Property Length |
    Sort-Object   -Property Name -Descending |
    Select-Object -Property Count, @{Name="Length"; Expression={[int]$_.Name}}, Group -First 1
