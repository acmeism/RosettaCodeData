Get-ChildItem -Recurse |
  Where-Object { $_.Name -match 'foo[0-9]' -and $_.Length -gt 5MB }
