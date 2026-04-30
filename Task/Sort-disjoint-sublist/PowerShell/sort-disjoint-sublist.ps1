function sublistsort($values, $indices) {
   $indices = $indices | sort
   $sub, $i = ($values[$indices] | sort), 0
   $indices | foreach { $values[$_] = $sub[$i++] }
   $values
}
$values = 7, 6, 5, 4, 3, 2, 1, 0
$indices = 6, 1, 7
"$(sublistsort $values $indices)"
