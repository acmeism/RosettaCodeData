4,8,16,32,64,128 | Get-RandomInteger | Format-Wide {"0x{0:X}" -f $_} -Column 6 -Force
