function Get-Gcd($a, $b){
    if($a -ge $b){
        $dividend = $a
        $divisor = $b
    }
    else{
        $dividend = $b
        $divisor = $a
    }
    $leftover = 1
    while($leftover -ne 0){
        $leftover = $dividend % $divisor
        if($leftover -ne 0){
				$dividend = $divisor
				$divisor = $leftover
			}
    }
    $divisor
}
function Is-Heron($heronArea){
    $heronArea -gt 0 -and $heronArea % 1 -eq 0
}
function Get-HeronArea($a, $b, $c){
    $s = ($a + $b + $c) / 2
    [math]::Sqrt($s * ($s - $a) * ($s - $b) * ($s - $c))
}
$result = @()
foreach ($c in 1..200){
    for($b = 1; $b -le $c; $b++){
        for($a = 1; $a -le $b; $a++){
            if((Get-Gcd $c (Get-Gcd $b $a)) -eq 1 -and (Is-Heron(Get-HeronArea $a $b $c))){
                $result += @(,@($a, $b, $c,($a + $b + $c), (Get-HeronArea $a $b $c)))
            }
        }
    }
}
$result = $result | sort-object @{Expression={$_[4]}}, @{Expression={$_[3]}}, @{Expression={$_[2]}}
"Primitive Heronian triangles with sides up to 200: $($result.length)`nFirst ten when ordered by increasing area, then perimeter,then maximum sides:`nSides`t`t`t`tPerimeter`tArea"
for($i = 0; $i -lt 10; $i++){
"$($result[$i][0])`t$($result[$i][1])`t$($result[$i][2])`t`t`t$($result[$i][3])`t`t`t$($result[$i][4])"
}
"`nArea = 210`nSides`t`t`t`tPerimeter`tArea"
foreach($i in $result){
    if($i[4] -eq 210){
        "$($i[0])`t$($i[1])`t$($i[2])`t`t`t$($i[3])`t`t`t$($i[4])"
    }
}
