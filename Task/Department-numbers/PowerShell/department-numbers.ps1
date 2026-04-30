# Department numbers

Write-Output "POLICE SANITATION FIRE"
for ($p = 2; $p -le 7; $p += 2) {
  for ($s = 1; $s -le 7; $s++) {
    if ($s -ne $p) {
      $f = 12 - $p - $s
      if (($f -ne $s) -and ($f -ne $p) -and ($f -ge 1) -and ($f -le 7)) {
          Write-Output "   $p       $s       $f"
      }
    }
  }
}
