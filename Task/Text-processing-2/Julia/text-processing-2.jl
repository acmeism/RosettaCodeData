dupdate = df[nonunique(df[:,[:Date]]),:][:Date]
println("The following rows have duplicate DATESTAMP:")
println(df[df[:Date] .== dupdate,:])
println("All values good in these rows:")
println(df[df[:ValidValues] .== 24,:])
