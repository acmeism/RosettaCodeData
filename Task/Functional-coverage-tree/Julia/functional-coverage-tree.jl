using CSV, DataFrames, Formatting

function updatecoverage(dfname, outputname)
    df = CSV.read(dfname)
    dchild = Dict{Int, Vector{Int}}([i => Int[] for i in 0:maximum(df[!, 1])])

    for row in eachrow(df)
        push!(dchild[row[3]], row[1])
    end

    function coverage(t)
        return dchild[t] == [] ? df[t, :COVERAGE] * df[t, :WEIGHT] :
            sum(coverage, dchild[t]) / sum(x -> df[x, :WEIGHT], dchild[t]) * df[t, :WEIGHT]
    end

    df[!, :COVERAGE] .= coverage.(df.NUMBER)

    function possibleincrease(t)
        if !isempty(dchild[t])
            return 0.0
        else
            newcoverage = deepcopy(df.COVERAGE)
            newcoverage[t] = 1.0
            oldcoverage = newcoverage[1]
            function potentialcoverage(t)
                return dchild[t] == [] ? newcoverage[t] * df[t, :WEIGHT] :
                    sum(potentialcoverage, dchild[t]) / sum(x -> df[x, :WEIGHT],
                        dchild[t]) * df[t, :WEIGHT]
            end

            newcoverage .= potentialcoverage.(df[!, 1])
            return newcoverage[1] - oldcoverage
        end
    end

    df.POTENTIAL = possibleincrease.(df[!, 1])

    CSV.write(outputname, df)
end

function displaycoveragedb(dfname)
    df = CSV.read(dfname)
    indentlevel(t) = (i = 0; while (j = df[t, 3]) != 0 i += 1; t = j end; i)
    indent1 = [indentlevel(i) for i in df.NUMBER]
    maxindent = maximum(indent1)
    indent2 = maxindent .- indent1
    showpot = size(df)[2] == 6
    println("INDEX       NAME_HIERARCHY                         WEIGHT      COVERAGE    (POTENTIAL INCREASE)")
    for (i, row) in enumerate(eachrow(df))
        println(rpad(row[1], 7), "       "^indent1[i], rpad(row[2], 20), "       "^indent2[i],
            rpad(row[4], 8), rpad(format(row[5]), 12), showpot && row[6] != 0 ? format(row[6]) : "")
    end
end

const dbname = "coverage.csv"
const newdbname = "coverageupdated.csv"

println("Input data:")
displaycoveragedb(dbname)
updatecoverage(dbname, newdbname)
println("\nUpdated data:")
displaycoveragedb(newdbname)
