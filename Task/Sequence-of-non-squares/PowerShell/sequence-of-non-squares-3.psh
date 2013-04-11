1..1000000 `
    | Get-NonSquare `
    | Where-Object {
          $r = [Math]::Sqrt($_)
          [Math]::Truncate($r) -eq $r
      }
