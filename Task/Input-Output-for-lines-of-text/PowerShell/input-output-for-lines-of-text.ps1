# script.ps1

$in = Get-Content $args[0]
$in[1..($in.Count-1)]

# ./script file.txt
