$url  = "https://oeis.org/A000045/b000045.txt"
$file = "$env:TEMP\FibonacciNumbers.txt"
(New-Object System.Net.WebClient).DownloadFile($url, $file)

$benford = Get-Content -Path $file |
         Select-Object -Skip 1 -First 1000 |
         ForEach-Object {(($_ -split " ")[1].ToString().ToCharArray())[0]} |
         Group-Object |
         Select-Object -Property @{Name="Digit"   ; Expression={[int]($_.Name)}},
                                 Count,
                                 @{Name="Actual"  ; Expression={$_.Count/1000}},
                                 @{Name="Expected"; Expression={[double]("{0:f5}" -f [Math]::Log10(1 + 1 / $_.Name))}}

$benford | Sort-Object -Property Digit | Format-Table -AutoSize

Remove-Item -Path $file -Force -ErrorAction SilentlyContinue
