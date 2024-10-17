using CSFML.LibCSFML, Gtk.ShortNames, Colors, Graphics, Cairo

#------------ input code ----------------------#

mutable struct Joystick
    devnum::Int
    isconnected::Bool
    hasXaxis::Bool
    nbuttons::Int
    pressed::Vector{Bool}
    ypos::Int
    xpos::Int
    name::String
    Joystick(n, b=2, c=false, x=true) = new(n, c, x, b, fill(false, b), 0, 0)
end

const devnum = 0
const buttons = 2
const jstick = Joystick(devnum, buttons)

function polljoystick(jstick, sleepinterval=0.05)
    while !sfJoystick_isConnected(jstick.devnum)
        sleep(0.25) # wait till connected
        sfJoystick_update()
    end
    jstick.name =  sfJoystick_getIdentification(jstick.devnum).name
    jstick.isconnected = true
    jstick.hasXaxis = sfJoystick_hasAxis(jstick.devnum, 0)
    jstick.nbuttons = sfJoystick_getButtonCount(jstick.devnum)
    while true
        sfJoystick_update()
        for i in 1:jstick.nbuttons
            jstick.pressed[i] =  sfJoystick_isButtonPressed(jstick.devnum, i - 1)
        end
        jstick.ypos = sfJoystick_getAxisPosition(jstick.devnum, 1)
        jstick.xpos = sfJoystick_getAxisPosition(joystick.devnum, 0)
        yield()
        sleep(sleepinterval)
    end
end

#------------ output code -------------------#

makelabel() = "Button 1: " * (jstick.pressed[1] ? "DOWN" : "UP") *
    "  Button 2: " * (jstick.pressed[2] ? "DOWN" : "UP")

const fontpointsize = 80
const wid = 500
const hei = 500
win = Window("Cursor Task", wid, hei) |> (Frame() |> (vbox = Box(:v)))
set_gtk_property!(vbox, :expand, true)
can = Canvas(wid, hei)
label = Label(makelabel())
push!(vbox, can, label)

joytoxpos() = div((jstick.xpos + 100) * width(can), 200)
joytoypos() = div((jstick.ypos + 100) * height(can), 200)
Gtk.showall(win)

@guarded draw(can) do widget
    ctx = getgc(can)
    select_font_face(ctx, "Courier", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_BOLD)
    set_font_size(ctx, fontpointsize)
    set_source(ctx, colorant"red")
    move_to(ctx, joytoxpos(), joytoypos())
    show_text(ctx, "+")
    set_gtk_property!(label, :label, makelabel())
end

@async polljoystick(jstick)

while true
    draw(can)
    sleep(0.2)
    yield()
end
