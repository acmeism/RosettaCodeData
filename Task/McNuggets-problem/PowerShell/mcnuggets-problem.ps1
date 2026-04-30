$possible = @{}
For ($i=0; $i -lt 18; $i++) {
  For ($j=0; $j -lt 13; $j++) {
    For ( $k=0; $k -lt 6; $k++ ) {
      $possible[ $i*6 + $j*9 + $k*20 ] = $true
    }
  }
}

For ( $n=100; $n -gt 0; $n-- ) {
  If ($possible[$n]) {
    Continue
  }
  Else {
    Break
  }
}
Write-Host "Maximum non-McNuggets number is $n"
