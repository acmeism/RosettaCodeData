$dateHash = @{}
$goodLineCount = 0
ForEach ($rawLine in ( get-content c:\temp\readings.txt) ){
    $line = $rawLine.split(" |`t",2)
    if ($dateHash.containskey($line[0])) {
        $line[0] + " is duplicated"
    } else {
        $dateHash.add($line[0], $line[1])
    }
    $readings = [regex]::matches($line[1],"\d+\.\d+\s-?\d")
    if ($readings.count -ne 24) { "incorrect number of readings for date " + $line[0] }
    $goodLine = $true
    foreach ($flagMatch in [regex]::matches($line[1],"\d\.\d*\s(?<flag>-?\d)")) {
        if ([int][string]$flagMatch.groups["flag"].value -lt 1) {
            $goodLine = $false
        }
    }
    if ($goodLine) { $goodLineCount++}
}
[string]$goodLineCount + " good lines"
