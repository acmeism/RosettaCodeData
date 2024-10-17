using Tk

const frameinterval = 0.12 # partial seconds between change on screen display

function windowanim(stepinterval::Float64)
    wind = Window("Animation", 300, 100)
    frm = Frame(wind)
    hello = "Hello World!                                           "
    but = Button(frm, width=30, text=hello)
    rightward = true
    callback(s) = (rightward = !rightward)
    bind(but, "command", callback)
    pack(frm, expand=true, fill = "both")
    pack(but, expand=true, fill = "both")
    permut = [hello[i:end] * hello[1:i-1] for i in length(hello)+1:-1:2]
    ppos = 1
    pmod = length(permut)
    while true
        but[:text] = permut[ppos]
        sleep(stepinterval)
        if rightward
            ppos += 1
            if ppos > pmod
                ppos = 1
            end
        else
            ppos -= 1
            if ppos < 1
                ppos = pmod
            end
        end
    end
end

windowanim(frameinterval)
