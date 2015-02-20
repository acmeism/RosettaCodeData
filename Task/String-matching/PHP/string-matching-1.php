<?php
/**********************************************************************************
* This program gets needle and haystack from the caller (chm.html) (see below)
* and checks for occurrences of the needle in the haystack
* 02.05.2013 Walter Pachl
* Comments or Suggestions welcome
**********************************************************************************/
$haystack = $_POST['haystack']; if ($haystack=='') {$haystack='no haystack given';}
$needle   = $_POST['needle'];   if ($needle=='')   {$needle='no needle given';}

function rexxpos($h,$n) {
  $pos = strpos($h,$n);
  if ($pos === false) { $pos=-1; }
  else                { $pos=$pos+1; }
  return ($pos);
 }

$pos=rexxpos($haystack,$needle);
$tx1 = "";
if ($pos==-1){ $n=0; }  // not found
else         { $n=1; }  // found once (so far)
// Special cases
if ($pos==1){ $tx1="needle found to be the start of the haystack"; }
if ($pos==strlen($haystack)-strlen($needle)+1)
            { $tx1="needle found at end of haystack"; }

if ($n>0) { // look for other occurrences
  $pl=$pos; // list of positions
  $p=$pos;  //
  $x="*************************************";
  $h=$haystack;
  while ($p>0) {
    $h=substr($x,0,$p).substr($h,$p);
    $p=rexxpos($h,$needle);
    if ( $p>0 ) { $n=$n+1; $pl=$pl.",&nbsp;".$p; }
  }
       if ($n==1) { $txt="needle found once in haystack, position: $pl."; }
  else if ($n==2) { $txt="needle found twice in haystack, position(s): $pl."; }
  else            { $txt="needle found $n times in haystack, position(s): $pl."; }
}
else              { $txt="needle not found in haystack."; }
?>
<html>
  <head>
    <title>Character Matching</title>
    <meta name="author" content="Walter Pachl">
    <meta name="date" content="02.05.2013">
    <style>
      p { font: 120% courier; }
    </style>
  </head>
  <body>
    <p><strong>Haystack:&nbsp;'<?php echo "$haystack" ?>'</strong></p>
    <p><strong>Needle:&nbsp;&nbsp;&nbsp;'<?php echo "$needle" ?>'</strong></p>
    <p><strong><?php echo "$txt" ?></strong></p>
    <!-- special message: -->
    <p  style="color: red";><strong><?php echo "$tx1" ?></strong></p>
  </body>
</html>
