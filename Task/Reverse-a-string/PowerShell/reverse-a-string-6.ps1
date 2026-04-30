$s -replace
      ('(.)' * $s.Length),
      -join ($s.Length..1 | ForEach-Object { "`$$_" } )
