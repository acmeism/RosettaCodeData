$file = '.\readings.txt'
$lines = Get-Content $file # $args[0]
$valid = $true
$startDate = $currStart = $endDate = ''
$startHour = $endHour = $currHour = $max = $currMax = $total = $readings = 0
$task = @()
foreach ($var in $lines) {
    $date, $rest = [regex]::Split($var,'\s+')
    $reject = $accept = $sum = $cnt = 0
    while ($rest) {
        $cnt += 1
        [Double]$val, [Double]$flag, $rest = $rest
        if (0 -lt $flag) {
            $currMax = 0
            $sum += $val
            $accept += 1
        } else {
            if (0 -eq $currMax) {
                $currStart = $date
                $currHour = $cnt
            }
            $currMax += 1
            $reject += 1
            if ($max -lt $currMax) {
                $startDate, $endDate = $currStart, $date
                $startHour, $endHour = $currHour, $cnt
                $max = $currMax
            }
        }
    }
    $readings += $accept
    $total += $sum
    $average = if (0 -lt $accept) {$sum/$accept} else {0}
    $task += [PSCustomObject]@{
        'Line' = $date
        'Reject' = $reject
        'Accept' = $accept
        'Sum' = $sum.ToString("N")
        'Average' = $average.ToString("N3")
    }
    $valid = 0 -eq $reject
}
$task  | Select -Last 3
$average = $total/$readings
"File(s)  = $file"
"Total    = {0}" -f $total.ToString("N")
"Readings = $readings"
"Average  = {0}" -f $average.ToString("N3")
""
"Maximum run(s) of $max consecutive false readings."
if (0 -lt $max) {
    "Consecutive false readings starts at line starting with date $startDate at hour {0:0#}:00." -f $startHour
    "Consecutive false readings ends at line starting with date $endDate at hour {0:0#}:00." -f $endHour
}
