<?

$contents = file('http://tycho.usno.navy.mil/cgi-bin/timer.pl');
foreach ($contents as $line){
  if (($pos = strpos($line, ' UTC')) === false) continue;
  echo subStr($line, 4, $pos - 4); //Prints something like "Dec. 06, 16:18:03"
  break;
}
