$xp=127;
$yp=127;

while (1) {

 $a = $na;
 for ($n=0; $n<$na; $n++) {
  if (($x[$n]==$xp) && ($y[$n]==$yp)) {
   $a=$n;
   last;
   }
  }

 if ($a == $na) {
  $na++;
  $x[$a]=$xp;
  $y[$a]=$yp;
  for ($n=0; $n<4; $n++) {
   $e[4*$a+$n] = int(rand(2));
   }
  for ($n=0; $n<$na; $n++) {
   if (($x[$n]==$x[$a]+1) && ($y[$n]==$y[$a]  ))  {$e[4*$a]=$e[4*$n+2];}
   elsif (($x[$n]==$x[$a]  ) && ($y[$n]==$y[$a]+1)) {$e[4*$a+1]=$e[4*$n+3];}
   elsif (($x[$n]==$x[$a-1]) && ($y[$n]==$y[$a]  )) {$e[4*$a+2]=$e[4*$n];}
   elsif (($x[$n]==$x[$a]  ) && ($y[$n]==$y[$a]-1)) {$e[4*$a+3]=$e[4*$n+1];}
   }
  }

 print("Paths: ");
 if ($e[4*$a+$f]) {print(" ahead");}
 if ($e[4*$a+($f+1)%4]) {printf(" right");}
 if ($e[4*$a+($f+2)%4]) {printf(" back" );}
 if ($e[4*$a+($f+3)%4]) {printf(" left" );}
 printf("\n");

 $d=-1;
 while ($d<0) {

  print("> ");
  $entry=<>;
  chomp($entry);
  if ($entry eq "ahead") {$d=$f%4;}
  elsif ($entry eq "right") {$d=($f+1)%4;}
  elsif ($entry eq "back") {$d=($f+2)%4;}
  elsif ($entry eq "left") {$d=($f+3)%4;}
  elsif ($entry eq "quit") {exit;}

  if ($d==0) {if ($e[4*$a]) {$xp++; $f=$d;} else {$d=-1;}}
  elsif ($d==1) {if ($e[4*$a+1]) {$yp++; $f=$d;} else {$d=-1;}}
  elsif ($d==2) {if ($e[4*$a+2]) {$xp--; $f=$d;} else {$d=-1;}}
  elsif ($d==3) {if ($e[4*$a+3]) {$yp--; $f=$d;} else {$d=-1;}}

  if ($d<0) {print "No path.\n";}

  }

 }
