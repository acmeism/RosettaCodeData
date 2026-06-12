$xp = 127
$yp = 127
$a = 0
$na = 0
$x = @()
$y = @()
$e = @()
$f = (random 4)

while ($true) {

 $a = $na;
 for ($n=0; $n-lt$na; $n++) {
  if (($x[$n]-eq$xp) -and ($y[$n]-eq$yp)) {$a=$n; break}
  }

 if ($a -eq $na) {
  $na++
  $x += $xp
  $y += $yp
  (0..3) |% {$e+=($true,$false)[(random 2)]}
  (0..($na-1)) |% {
       if (($x[$_]-eq$x[$a]+1) -and ($y[$_]-eq$y[$a]  )) {$e[4*$a  ]=$e[4*$_+2];}
   elseif (($x[$_]-eq$x[$a]  ) -and ($y[$_]-eq$y[$a]+1)) {$e[4*$a+1]=$e[4*$_+3];}
   elseif (($x[$_]-eq$x[$a]-1) -and ($y[$_]-eq$y[$a]  )) {$e[4*$a+2]=$e[4*$_  ];}
   elseif (($x[$_]-eq$x[$a]  ) -and ($y[$_]-eq$y[$a]-1)) {$e[4*$a+3]=$e[4*$_+1];}
   }
  }

 $str = "Paths:"
 if ($e[4*$a+$f%4])     {$str+=" ahead"}
 if ($e[4*$a+($f+1)%4]) {$str+=" right"}
 if ($e[4*$a+($f+2)%4]) {$str+=" back"}
 if ($e[4*$a+($f+3)%4]) {$str+=" left"}
 write-output $str

 $d=-1;
 while ($d-lt0) {

  write-host -n "> "
  $entry = (read-host)
      if ($entry-eq"ahead") {$d=$f}
  elseif ($entry-eq"right") {$d=($f+1)%4}
  elseif ($entry-eq"back")  {$d=($f+2)%4}
  elseif ($entry-eq"left")  {$d=($f+3)%4}
  elseif ($entry-eq"quit") {read-host; exit}
  else {write-host "Entry invalid."}

  }

 switch($d) {
  0 {if ($e[4*$a  ]) {$xp++; $f=$d} else {$d=-1}}
  1 {if ($e[4*$a+1]) {$yp++; $f=$d} else {$d=-1}}
  2 {if ($e[4*$a+2]) {$xp--; $f=$d} else {$d=-1}}
  3 {if ($e[4*$a+3]) {$yp--; $f=$d} else {$d=-1}}
  }

 if ($d-lt0) {write-host "No path."}

 }
