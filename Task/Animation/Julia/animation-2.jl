using Gtk.ShortNames

const frameinterval = 0.12 # partial seconds between change on screen display

function textanimation(stepinterval::Float64)
    hello = "Hello World!                        "
    win = Window("Animation", 210, 40) |> (Frame() |> (but = Button("Switch Directions")))
    rightward = true
    switchdirections(s) = (rightward = !rightward)
    signal_connect(switchdirections, but, "clicked")
    permut = [hello[i:end] * hello[1:i-1] for i in length(hello)+1:-1:2]
    ppos = 1
    pmod = length(permut)
    nobreak = true
    endit(w) = (nobreak = false)
    signal_connect(endit, win, :destroy)
    showall(win)
    while nobreak
        setproperty!(but, :label, permut[ppos])
        sleep(stepinterval)
        if rightward
            ppos += 1
            if(ppos > pmod)
                ppos = 1
            end
        else
            ppos -= 1
            if(ppos < 1)
                ppos = pmod
            end
        end
    end
end

textanimation(frameinterval)
