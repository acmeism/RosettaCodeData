function tag(x::Pair, attr::Pair...)
    t, b = x
    attrstr = join(" $n=\"$p\"" for (n, p) in attr)
    return "<$t$attrstr>$b</$t>"
end

colnames = split(",X,Y,Z", ',')

header = join(tag(:th => txt) for txt in colnames) * "\n"
rows   = collect(tag(:tr => join(tag(:td => i, :style => "font-weight: bold;") * join(tag(:td => rand(1000:9999)) for j in 1:3))) for i in 1:6)
body   = "\n" * join(rows, '\n') * "\n"
table  = tag(:table => string('\n', header, body, '\n'), :style => "width: 60%")
println(table)
