# EULER.PS1
$max = 250

$powers =  New-Object System.Collections.ArrayList
for ($i = 0; $i -lt $max; $i++) {
  $tmp = $powers.Add([Math]::Pow($i, 5))
}

for ($x0 = 1; $x0 -lt $max; $x0++) {
  for ($x1 = 1; $x1 -lt $x0; $x1++) {
    for ($x2 = 1; $x2 -lt $x1; $x2++) {
      for ($x3 = 1; $x3 -lt $x2; $x3++) {
        $sum = $powers[$x0] + $powers[$x1] + $powers[$x2] + $powers[$x3]
        $S1 = [int][Math]::pow($sum,0.2)

        if ($sum -eq $powers[$S1]) {
          Write-host "$x0^5 + $x1^5 + $x2^5 + $x3^5 = $S1^5"
          return
        }
      }
    }
  }
}
