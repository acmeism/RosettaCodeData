49927398716, 49927398717, 1234567812345678, 1234567812345670 | ForEach-Object {
    "{0,-17}: {1}" -f $_,"$(if(Test-LuhnNumber $_) {'Is valid.'} else {'Is not valid.'})"
}
