#one-line function with sort
function sort_ ([string] $str) {
 ((($str.toCharArray() |% {[int]$_}) | sort) |% {[char]$_}) -join ""
 }
sort_ "This is an example text line."

#manual bubble sort
function sort_ ([Object[]] $a) {
 for ($n = 0; $n -lt $a.length; $n++) {
  for ($n2 = 0; $n2 -lt $a.length-$n-1; $n2++) {
   if ($a[$n2] -gt $a[$n2 + 1]) {
    $s = $a[$n2]
    $a[$n2] = $a[$n2+1]
    $a[$n2+1] = $s
    }
   }
  }
 $a
 }
$str = "This is an example text line."
(sort_ $str.toCharArray()) -join ""
