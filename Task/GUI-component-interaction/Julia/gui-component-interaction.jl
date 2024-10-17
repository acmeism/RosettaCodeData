#=
The task: For a minimal "application", write a program that
presents a form with three components to the user: A numeric input
field ("Value") and two buttons ("increment" and "random").
=#

using Tk

w = Toplevel("Component Interaction Example")
fr = Frame(w)
pack(fr, expand=true, fill="both")

value = Entry(fr, "")
increment = Button(fr, "Increment")
random = Button(fr, "Random")

formlayout(value, "Value:")
formlayout(increment, " ")
formlayout(random, " ")

set_value(value, "0") ## The field is initialized to zero.

incrementvalue(s) = (val = parse(Int, get_value(value)); set_value(value, string(val + 1)))
bind(increment, "command", incrementvalue)

function validate_command(path, P)
    try
        length(P) > 0 && parse(Float64, P)
        tcl("expr", "TRUE")
    catch e
        tcl("expr", "FALSE")
    end
end
function invalid_command(path, W)
    println("Invalid value")
    tcl(W, "delete", "@0", "end")
end

"""
    Pressing the "random" button presents a confirmation dialog and
    resets the field's value to a random value if the answer is "Yes".
"""
function randval(s)
    out = Messagebox(w, title="Randomize input", detail="Select a new random number?")
    if out == "ok"
        new_value = rand(collect(1:99))
        set_value(value, string(new_value))
    end
end
bind(random, "command", randval)

while true sleep(1); end
