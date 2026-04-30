$years = for ($i = 400; $i -le 2100; $i+=100) {$i}
$years0400to2100 = $years | Get-Easter
$years2010to2020 = 2010..2020 | Get-Easter

Write-Host "Christian holidays, related to Easter, for each centennial from 400 to 2100 AD:"
$years0400to2100 | Format-Table
Write-Host "Christian holidays, related to Easter, for years from 2010 to 2020 AD:"
$years2010to2020 | Format-Table
