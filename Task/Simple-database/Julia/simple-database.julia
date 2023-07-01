using CSV, DataFrames, ArgParse, Dates

setting = ArgParseSettings()
@add_arg_table setting begin
    "--add"
        help = "add an entry, within double quotes, comma separated as \"name,birthdate,state,relation,email\" with birthdate as yyyy-mm-dd"
    "--latest"
        action = :store_true
        nargs = 0
        help = "print latest (last) entry"
    "--latestfriend"
        action = :store_true
        nargs = 0
        help = "print last friend listed"
    "--latestfamily"
        action = :store_true
        nargs = 0
        help = "print last family member listed"
    "--listbyage"
        action = :store_true
        nargs = 0
        help = "print all ages and entries in birth order"
end

const filename = "example.csv"
const df = CSV.File(filename, dateformat="yyyy-mm-dd") |> DataFrame
const commands = parse_args(setting)
if length(ARGS) == 0
    ArgParse.show_help(setting)
end
const changeflag = [false]

for (k, v) in commands
    if k == "add" && v != nothing
        newrow = Vector{Any}(split(v, r","))
        if length(newrow) == 5 && tryparse(DateTime, newrow[2]) != nothing
            newrow[2] = DateTime(newrow[2])
            push!(df, newrow)
            changeflag[1] = true
            println("Added entry $newrow.")
        end
    elseif k == "latest" && v
        println("The latest entry is $(df[end, :])")
    elseif k == "latestfriend" && v
        println(df[df.Relation .== "friend", :][end, :])
    elseif k == "latestfamily" && v
        println(df[df.Relation .== "family", :][end, :])
    elseif k == "listbyage" && v
        dobcol = df[:Birthdate]
        age = map(x -> round((now() - DateTime(x)).value /(1000*3600*24*365.25), digits=1), dobcol)
        df2 = deepcopy(df)
        df2 = insert!(df, 1, age, :Age)
        println(sort(df2, (:Age)))
    end
end

if changeflag[1]
    CSV.write(filename, df)
    println("Changes written to file $filename.")
end
