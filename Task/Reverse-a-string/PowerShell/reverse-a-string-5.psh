$s -replace
      ('(.)' * $s.Length),
      [string]::Join('', ($s.Length..1 | ForEach-Object { "`$$_" }))
