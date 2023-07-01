#=
Regex based variable name convention change string functions.
    `sep` is the separator targeted for change from (to camel case) or to (to snake case)
    `allsep` is the separators other than `sep` that may be changed to `sep`
    `lcmiddle` is a boolean to set whether caps within camel case words are made lowercase
=#

function snakeToCamelCase(s; sep=r"[_]+", lcmiddle=false)
    isempty(s) && return s
    words = split(strip(s), sep)
    return lowercasefirst(join(uppercasefirst.(lcmiddle ? lowercase.(words) : words)))
end

spaceToCamelCase(s) = snakeToCamelCase(s; sep=r"\s+")
kebabToCamelCase(s) = snakeToCamelCase(s; sep=r"[\-]+")
periodToCamelCase(s) = snakeToCamelCase(s; sep=r"[\.]+")
allsepToCamelCase(s) = snakeToCamelCase(s; sep=r"[ \-_\.]+")
lowermiddle_allsepToCamelCase(s) = snakeToCamelCase(s; sep=r"[ \-_\.]+", lcmiddle=true)

function camel_to_snake_case(s; sep="_", insep=sep, allsep=r"_+", lcmiddle=true)
    s = isempty(s) ? (return s) : lowercasefirst(strip(s))
    s = replace(s, r"[A-Z]+" => x -> sep * (lcmiddle ? lowercase(x) : lowercasefirst(x)))
    return replace(s, allsep => sep)
end

preserve_midcaps_camel_to_snake_case(s) = camel_to_snake_case(s; lcmiddle=false)
allsep_to_snake_case(s) = camel_to_snake_case(s; allsep=r"[ \-\._]+")
allsep_to_kebab_case(s) = camel_to_snake_case(s; allsep=r"[ \-\._]+", sep="-")
allsep_to_space_case(s) = camel_to_snake_case(s; allsep=r"[ \-\._]+", sep=" ")
allsep_to_period_case(s) = camel_to_snake_case(s; allsep=r"[ \-\._]+", sep=".")
allsep_to_slash_case(s) = camel_to_snake_case(s; allsep=r"[ \-\._]+", sep="/")

for f in [
    snakeToCamelCase,
    spaceToCamelCase,
    kebabToCamelCase,
    periodToCamelCase,
    allsepToCamelCase,
    lowermiddle_allsepToCamelCase,
    camel_to_snake_case,
    preserve_midcaps_camel_to_snake_case,
    allsep_to_snake_case,
    allsep_to_kebab_case,
    allsep_to_space_case,
    allsep_to_period_case,
    allsep_to_slash_case,
]
    println("Testing function $f:")

    for teststring in [
        "snakeCase",
        "snake_case",
        "snake-case",
        "snake case",
        "snake CASE",
        "snake.case",
        "variable_10_case",
        "variable10Case",
        "ɛrgo rE tHis",
        "hurry-up-joe!",
        "c://my-docs/happy_Flag-Day/12.doc",
        " spaces ",
    ]
        println(lpad(teststring, 36), "  =>  ", f(teststring))
    end
    println()
end
