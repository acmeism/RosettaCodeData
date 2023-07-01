import wx

{.experimental.}

const
    TITLE       = "Rosetta Code - Window Creation Nim"
    WIDTH       = 300
    HEIGHT      = 300

let
    POSITION    = construct_wxPoint(100,100)
    SIZE        = construct_wxSize(WIDTH,HEIGHT)

let window = cnew construct_wxFrame(nil, wxID_ANY, TITLE, POSITION, SIZE)

window.show(true)

run_main_loop()
