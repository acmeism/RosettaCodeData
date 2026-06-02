' ============================================
' https://rosettacode.org/wiki/Associative_array/Creation
' https://rosettacode.org/wiki/Associative_array/Iteration
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' In BazzBasic, any DIM array accepts string keys,
' making it a natural associative array / dictionary.

[inits]
    DIM person$
    person$("name")    = "Alice"
    person$("age")     = 30
    person$("city")    = "Helsinki"
    person$("hobbies") = "bass, coding"

    ' Keep an ordered key list for iteration
    DIM keys$
    keys$(0) = "name"
    keys$(1) = "age"
    keys$(2) = "city"
    keys$(3) = "hobbies"

[creation]
    PRINT "--- Creation ---"
    PRINT "name:    "; person$("name")
    PRINT "age:     "; person$("age")
    PRINT "city:    "; person$("city")
    PRINT "hobbies: "; person$("hobbies")
    PRINT ""

[iteration]
    PRINT "--- Iteration ---"
    FOR i$ = 0 TO 3
        PRINT keys$(i$); ": "; person$(keys$(i$))
    NEXT
END

' Output:
' --- Creation ---
' name:    Alice
' age:     30
' city:    Helsinki
' hobbies: bass, coding
'
' --- Iteration ---
' name: Alice
' age: 30
' city: Helsinki
' hobbies: bass, coding
