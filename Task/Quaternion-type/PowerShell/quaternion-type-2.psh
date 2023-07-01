function show([System.Numerics.Quaternion]$c) {
    function st([Double]$r) {
            if(0 -le $r) {return "+$r"} else {return "$r"}
    }
    return "$($c.w)$(st $c.y)i$(st $c.y)j$(st $c.z)k"
}
$q  = [System.Numerics.Quaternion]::new(1, 2, 3, 4)
$q1 = [System.Numerics.Quaternion]::new(2, 3, 4, 5)
$q2 = [System.Numerics.Quaternion]::new(3, 4, 5, 6)
$r = 7
"`$q: $(show $q)"
"`$q1: $(show $q1)"
"`$q2: $(show $q2)"
"`$r: $r"
"norm `$q: $($q.Length())"
"negate `$q: $(show ([System.Numerics.Quaternion]::Negate($q)))"
"conjugate `$q: $(show ([System.Numerics.Quaternion]::Conjugate($q)))"
"`$q + `$r: $(show ([System.Numerics.Quaternion]::new($q.w + $r, $q.x, $q.y, $q.z)))"
"`$q1 + `$q2: $(show ([System.Numerics.Quaternion]::Add($q1,$q2)))"
"`$q * `$r: $(show ([System.Numerics.Quaternion]::new($q.w * $r, $q.x * $r, $q.y * $r, $q.z * $r)))"
"`$q1 * `$q2: $(show ([System.Numerics.Quaternion]::Multiply($q1,$q2)))"
"`$q2 * `$q1: $(show ([System.Numerics.Quaternion]::Multiply($q2,$q1)))"
