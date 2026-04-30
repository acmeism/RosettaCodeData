(4,9,16,25 | ForEach-Object { & (add $_) ([Math]::Sqrt($_)) }) -join ", "
