# script.ps1

$in, $line = (Get-Content $args[0]), 0
$nb = $in[$line++]
1..$nb | foreach {
    $sum = 0
    $in[$line++].Split() | foreach{ $sum += $_}
    $sum
}

# ./script file.txt
