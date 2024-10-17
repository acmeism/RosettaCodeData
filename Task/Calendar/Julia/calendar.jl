using Dates

const pagesizes = Dict( "lpr" => [132, 66], "tn3270" => [80, 43])

pagefit(prn) = haskey(pagesizes, prn) ?
    [div(pagesizes[prn][1], 22), div(pagesizes[prn][2], 12)] : [1, 1]
pagecols(prn) = haskey(pagesizes, prn) ? pagesizes[prn][1] : 20

function centerobject(x, cols)
    content = string(x)
    rpad(lpad(content, div(cols + length(content), 2)), cols)
end

function ljustlines(x, cols)
    arr = Vector{String}()
    for s in split(x, "\n")
        push!(arr, rpad(s, cols)[1:cols])
    end
    join(arr, "\n")
end

function formatmonth(yr, mo)
    dt = Date("$yr-$mo-01")
    dayofweekfirst = dayofweek(dt)
    numweeklines = 1
    str = centerobject(monthname(dt), 20) * "\nMo Tu We Th Fr Sa Su\n"
    str *= " " ^ (3 * (dayofweekfirst - 1)) * lpad(string(1), 2)
    for i = 2:daysinmonth(dt)
        if (i + dayofweekfirst + 5) % 7 == 0
            str *= "\n" * lpad(i, 2)
            numweeklines += 1
        else
            str *= lpad(string(i), 3)
        end
    end
    str *= numweeklines < 6 ? "\n\n\n" : "\n\n"
    ljustlines(str, 20)
end

function formatyear(displayyear, printertype)
    calmonths = [formatmonth(displayyear, mo) for mo in 1:12]
    columns = pagecols(printertype)
    monthsperline = pagefit(printertype)[1]
    joinspaces = max( (monthsperline > 1) ?
        div(columns - monthsperline * 20, monthsperline - 1) : 1, 1)
    str = "\n" * centerobject(displayyear, columns) * "\n"
    monthcal = [split(formatmonth(displayyear, i), "\n") for i in 1:12]
    for i in 1:monthsperline:length(calmonths) - 1
        for j in 1:length(monthcal[1])
            monthlines = map(x->monthcal[x][j], i:i + monthsperline - 1)
            str *= rpad(join(monthlines, " " ^ joinspaces), columns) * "\n"
        end
        str *= "\n"
    end
    str
end

function lineprintcalendar(years)
    for year in years, printer in keys(pagesizes)
        println(formatyear(year, printer))
    end
end

lineprintcalendar(1969)
