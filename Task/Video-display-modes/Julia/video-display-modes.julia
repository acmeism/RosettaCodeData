if Base.Sys.islinux()
    run(`xrandr -s 640x480`)
    sleep(3)
    run(`xrandr -s 1280x960`)
else # windows
    run(`mode CON: COLS=40 LINES=100`)
    sleep(3)
    run(`mode CON: COLS=100 LINES=50`)
end
