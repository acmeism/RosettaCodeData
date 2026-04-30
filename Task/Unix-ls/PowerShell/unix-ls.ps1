# Prints Name, Length, Mode, and LastWriteTime
Get-ChildItem | Sort-Object Name | Write-Output

# Prints only the name of each file in the directory
Get-ChildItem | Sort-Object Name | ForEach-Object Name | Write-Output
