println(expand("""~/{Downloads,Pictures}/*.{jpg,gif,png}""") mkString "\n")
println(expand("It{{em,alic}iz,erat}e{d,}, please.") mkString "\n")
println(expand("""{,{,gotta have{ ,\, again\, }}more }cowbell!""") mkString "\n")
println(expand("""{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}""") mkString "\n")
