sub infix:<·> { [+] @^a Z* @^b }
sub infix:<×>(@A, @B) { (@A X· [Z] @B).rotor(@B) }
