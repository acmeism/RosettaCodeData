When-Condition -Test1 (Test-Path .\temp.txt) -Test2 (Test-Path .\tmp.txt) `
    -Both { "both true"
}   -First { "first true"
}   -Second { "second true"
}   -Neither { "neither true"
}
