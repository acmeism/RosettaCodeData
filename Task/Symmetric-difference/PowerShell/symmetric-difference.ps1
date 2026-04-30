$A = @( "John"
        "Bob"
        "Mary"
        "Serena" )

$B = @( "Jim"
        "Mary"
        "John"
        "Bob" )

#  Full commandlet name and full parameter names
Compare-Object -ReferenceObject $A -DifferenceObject $B

#  Same commandlet using an alias and positional parameters
Compare $A $B

#  A - B
Compare $A $B | Where SideIndicator -eq "<=" | Select -ExpandProperty InputObject

#  B - A
Compare $A $B | Where SideIndicator -eq "=>" | Select -ExpandProperty InputObject
