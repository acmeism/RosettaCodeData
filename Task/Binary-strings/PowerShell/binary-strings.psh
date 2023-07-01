Clear-Host

## String creation (which is string assignment):
Write-Host "`nString creation (which is string assignment):" -ForegroundColor Cyan
Write-Host '[string]$s = "Hello cruel world"' -ForegroundColor Yellow
[string]$s = "Hello cruel world"

## String (or any variable) destruction:
Write-Host "`nString (or any variable) destruction:" -ForegroundColor Cyan
Write-Host 'Remove-Variable -Name s -Force' -ForegroundColor Yellow
Remove-Variable -Name s -Force

## Now reassign the variable:
Write-Host "`nNow reassign the variable:" -ForegroundColor Cyan
Write-Host '[string]$s = "Hello cruel world"' -ForegroundColor Yellow
[string]$s = "Hello cruel world"

Write-Host "`nString comparison -- default is case insensitive:" -ForegroundColor Cyan
Write-Host '$s -eq "HELLO CRUEL WORLD"' -ForegroundColor Yellow
$s -eq "HELLO CRUEL WORLD"
Write-Host '$s -match "HELLO CRUEL WORLD"' -ForegroundColor Yellow
$s -match "HELLO CRUEL WORLD"
Write-Host '$s -cmatch "HELLO CRUEL WORLD"' -ForegroundColor Yellow
$s -cmatch "HELLO CRUEL WORLD"

## Copy a string:
Write-Host "`nCopy a string:" -ForegroundColor Cyan
Write-Host '$t = $s' -ForegroundColor Yellow
$t = $s

## Check if a string is empty:
Write-Host "`nCheck if a string is empty:" -ForegroundColor Cyan
Write-Host 'if ($s -eq "") {"String is empty."} else {"String = $s"}' -ForegroundColor Yellow
if ($s -eq "") {"String is empty."} else {"String = $s"}

## Append a byte to a string:
Write-Host "`nAppend a byte to a string:" -ForegroundColor Cyan
Write-Host "`$s += [char]46`n`$s" -ForegroundColor Yellow
$s += [char]46
$s

## Extract (and display) substring from a string:
Write-Host "`nExtract (and display) substring from a string:" -ForegroundColor Cyan
Write-Host '"Is the world $($s.Substring($s.IndexOf("c"),5))?"' -ForegroundColor Yellow
"Is the world $($s.Substring($s.IndexOf("c"),5))?"

## Replace every occurrence of a byte (or a string) in a string with another string:
Write-Host "`nReplace every occurrence of a byte (or a string) in a string with another string:" -ForegroundColor Cyan
Write-Host "`$t = `$s -replace `"cruel`", `"beautiful`"`n`$t" -ForegroundColor Yellow
$t = $s -replace "cruel", "beautiful"
$t

## Join strings:
Write-Host "`nJoin strings [1]:" -ForegroundColor Cyan
Write-Host '"Is the world $($s.Split()[1]) or $($t.Split()[1])?"' -ForegroundColor Yellow
"Is the world $($s.Split()[1]) or $($t.Split()[1])?"
Write-Host "`nJoin strings [2]:" -ForegroundColor Cyan
Write-Host '"{0} or {1}... I don''t care." -f (Get-Culture).TextInfo.ToTitleCase($s.Split()[1]), $t.Split()[1]' -ForegroundColor Yellow
"{0} or {1}... I don't care." -f (Get-Culture).TextInfo.ToTitleCase($s.Split()[1]), $t.Split()[1]
Write-Host "`nJoin strings [3] (display an integer array using the -join operater):" -ForegroundColor Cyan
Write-Host '1..12 -join ", "' -ForegroundColor Yellow
1..12 -join ", "

## Display an integer array in a tablular format:
Write-Host "`nMore string madness... display an integer array in a tablular format:" -ForegroundColor Cyan
Write-Host '1..12 | Format-Wide {$_.ToString().PadLeft(2)}-Column 3 -Force' -NoNewline -ForegroundColor Yellow
1..12 | Format-Wide {$_.ToString().PadLeft(2)} -Column 3 -Force
