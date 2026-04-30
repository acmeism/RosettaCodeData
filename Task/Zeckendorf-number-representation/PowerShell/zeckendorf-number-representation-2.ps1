#  Get Zeckendorf numbers through 20, convert to binary for display
0..20 | ForEach { [convert]::ToString( ( Get-ZeckendorfNumber $_ ), 2 ) }
