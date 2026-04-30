$dateHash = @{}
$goodLineCount = 0
get-content c:\temp\readings.txt |
    ForEach-Object {
        $line = $_.split(" |`t",2)
        if ($dateHash.containskey($line[0])) {
            $line[0] + " is duplicated"
        } else {
            $dateHash.add($line[0], $line[1])
        }
        $readings = $line[1].split()
        $goodLine = $true
        if ($readings.count -ne 48) { $goodLine = $false; "incorrect line length : $line[0]"  }
        for ($i=0; $i -lt $readings.count; $i++) {
            if ($i % 2 -ne 0) {
                if ([int]$readings[$i] -lt 1) {
                    $goodLine = $false
                }
            }
        }
        if ($goodLine) { $goodLineCount++ }
    }
[string]$goodLineCount + " good lines"
