# Leonardo numbers

function Leonardo-Nums([long]$L0, [long]$L1, [long]$Sum, $Lmt) {
  $res = [long[]]::new($Lmt)
  if ($Lmt -ge 1) {
    $res[0] = $L0
  }
  if ($Lmt -ge 2) {
    $res[1] = $L1
  }
  if ($Lmt -gt 2) {
    foreach ($i in 2..($Lmt - 1)) {
      $res[$i] = [long]($L0 + $L1 + $Sum)
      $tmp = $L0
      $L0 = $L1
      $L1 = $tmp + $L1 + $Sum
    }
  }
  return $res
}

function Show-Result([string]$What, [long]$L0, [long]$L1, [long]$Sum, $Lmt) {
  Write-Output "$What ($L0, $L1, $Sum, $Lmt):"
  Write-Output "$(Leonardo-Nums $L0 $L1 $Sum $Lmt)"
}

Show-Result "Leonardo numbers" 1 1 1 25
Show-Result "Fibonacci numbers" 0 1 0 25
