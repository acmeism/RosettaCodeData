function madlibs(template)
    println("The story template is:\n", template)
    fields = Set(getfield.(collect(eachmatch(r"<[^>]+>", template)), :match))
    print("\nInput a comma-separated list of words to replace the following items:",
          join(fields, ", "), "\n -> ")
    values = split(readline(STDIN), ",")
    for (m, v) in zip(fields, values)
        template = replace(template, m, v)
    end
    println("\nThe story becomes:\n", template)
end

const template = """
<name> went for a walk in the park. <he or she>
found a <noun>. <name> decided to take it home.
"""

madlibs(template)
