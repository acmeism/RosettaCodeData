import Base: string

const BLACKLIST = [
    "drop", "delete", "erase", "kill", "wipe", "remove",
    "file", "files", "directory", "directories",
    "table", "tables", "record", "records", "database", "databases",
    "system", "system32", "system64", "rm", "rf", "rmdir", "format", "reformat"
]
const PUNC = [''', '-']
const LETT = ['a':'z'; 'A':'Z']

"""
    function validator(s)

    Validation of `s` requires:
        `s` is valid utf-8
        `s` only has chars that are in okc
        `s` is not in the `blist``, and if `csense` is false (the default),
        the lowercase version of `s` is not in the lowercase version of `blist`.

    Returns (true, s) if valid and (false, error message) if invalid.
"""
function validator(stri, okc = vcat(LETT, PUNC), blist = copy(BLACKLIST), csense = false)
    s = ""
    if !csense
        blist = lowercase.(blist)
    end
    try # some binary sequences are invalid utf8 and may throw error
       s = string(stri)
       lcs = csense ? s : lowercase(s)
       lcs ∈ blist && return false, "Sorry, name $s is forbidden."
       any(x -> x ∉ okc, s) && return false, "Sorry, name $s contains bad characters."
    catch y
        return false, y
    end
    return true, s
end

""" class for Person with firstname and lastname identity strings """
struct Person
    firstname::String
    lastname::String
end
""" convert a Person to its string representation """
Base.string(p::Person) = "$(p.firstname) $(p.lastname)"


""" Add Persons to plist with validation by validator """
function addsanitized!(plist, validator = validator)
    println("""\n    INSTRUCTIONS
       Enter new names as first name then last name.
       Allowable characters are a through z (A-Z), along with ' and - in names.
       Some words are reserved for use by the system and are thus excluded.
       Enter two blank lines to exit (Hit Enter for a blank entry).
    """)
    while true
        print("Enter first name: ")
        fn = strip(readline())
        ok, firstname = validator(fn)
        if !ok
            println(firstname)
            continue
        end
        print("Enter last name: ")
        ln = strip(readline())
        ok, lastname = validator(ln)
        if !ok
            println(lastname)
            continue
        end
        firstname == "" && lastname == "" && break
        push!(plist, Person(firstname, lastname))
    end
    return plist
end

const persons = addsanitized!(Person[])
println("\nAdded:\n", join(persons, "\n"))
