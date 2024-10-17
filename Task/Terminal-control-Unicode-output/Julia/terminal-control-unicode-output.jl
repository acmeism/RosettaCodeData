c = '\u25b3'

if ismatch(r"UTF", get(ENV, "LANG", ""))
    println("This output device supports Unicode: ", c)
else
    println("This output device does not support Unicode.")
end
