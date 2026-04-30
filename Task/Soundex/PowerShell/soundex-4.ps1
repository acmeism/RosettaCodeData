 Function t([string]$value, [string]$expect) {
    $result = .\Soundex.ps1 -Phrase $value
    New-Object –TypeName PSObject –Prop @{ "Value"=$value; "Expect"=$expect; "Result"=$result; "Pass"=$($expect -eq $result) }
}
@(
(t "Ashcraft" "A261"); (t "Ashcroft" "A261"); (t "Burroughs" "B620"); (t "Burrows" "B620");
(t "Ekzampul" "E251"); (t "Example" "E251"); (t "Ellery" "E460"); (t "Euler" "E460");
(t "Ghosh" "G200"); (t "Gauss" "G200"); (t "Gutierrez" "G362"); (t "Heilbronn" "H416");
(t "Hilbert" "H416"); (t "Jackson" "J250"); (t "Kant" "K530"); (t "Knuth" "K530");
(t "Lee" "L000"); (t "Lukasiewicz" "L222"); (t "Lissajous" "L222"); (t "Ladd" "L300");
(t "Lloyd" "L300"); (t "Moses" "M220"); (t "O'Hara" "O600"); (t "Pfister" "P236");
(t "Rubin" "R150"); (t "Robert" "R163"); (t "Rupert" "R163"); (t "Soundex" "S532");
(t "Sownteks" "S532"); (t "Tymczak" "T522"); (t "VanDeusen" "V532"); (t "Washington" "W252");
(t "Wheaton" "W350");
) | Format-Table -Property Value,Expect,Result,Pass
