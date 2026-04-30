   1..1000 | Where { $_ % ( [int[]][string[]][char[]][string]$_ | Measure -Sum ).Sum -eq 0 } | Select -First 20
1001..2000 | Where { $_ % ( [int[]][string[]][char[]][string]$_ | Measure -Sum ).Sum -eq 0 } | Select -First 1
