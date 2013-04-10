<?php
function halve($x)
{
  return floor($x/2);
}

function double($x)
{
  return $x*2;
}

function iseven($x)
{
  return !($x & 0x1);
}

function ethiopicmult($plier, $plicand, $tutor)
{
  if ($tutor) echo "ethiopic multiplication of $plier and $plicand\n";
  $r = 0;
  while($plier >= 1) {
    if ( !iseven($plier) ) $r += $plicand;
    if ($tutor)
      echo "$plier, $plicand ", (iseven($plier) ? "struck" : "kept"), "\n";
    $plier = halve($plier);
    $plicand = double($plicand);
  }
  return $r;
}

echo ethiopicmult(17, 34, true), "\n";

?>
