1..3 | ForEach-Object {((Get-Date -Hour ($_ + (1..4 | Get-Random))).AddDays($_ + (1..4 | Get-Random)))} |
       Select-Object -Unique |
       ForEach-Object {$_.ToString()}
