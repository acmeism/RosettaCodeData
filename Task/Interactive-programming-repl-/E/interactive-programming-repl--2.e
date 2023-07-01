? def f(string1 :String, string2 :String, separator :String) {
>     return separator.rjoin(string1, "", string2)
> }
# value: <f>

? f("Rosetta", "Code", ":")
# value: "Rosetta::Code"
