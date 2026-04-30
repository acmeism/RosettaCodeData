$file = @'
John Doe abc1 K2hdystkrs
Jane Doe xyz2 Ew3jtdkufy
Joe Blow def3 Ouy1ttluyl
'@ -split [Environment]::NewLine

$file | Select-NumberFromString -Hexadecimal | Format-Table
