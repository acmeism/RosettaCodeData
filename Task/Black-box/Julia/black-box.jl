using Colors, Cairo, Graphics, Gtk

struct BoxPosition
    x::Int
    y::Int
    BoxPosition(i = 0, j = 0) = new(i, j)
end

@enum TrialResult Miss Hit Reflect Detour

struct TrialBeam
    entry::BoxPosition
    exit::Union{BoxPosition, Nothing}
    result::TrialResult
end

function blackboxapp(boxlength=8, boxwidth=8, numballs=4)
    r, turncount, guesses, guesscount, correctguesses = 20, 0, BoxPosition[], 0, 0
    showballs, boxoffsetx, boxoffsety = false, r, r
    boxes = fill(colorant"wheat", boxlength + 4, boxwidth + 4)
    beamhistory, ballpositions = Vector{TrialBeam}(), Vector{BoxPosition}()
    win = GtkWindow("Black Box Game", 348, 800) |> (GtkFrame() |> (box = GtkBox(:v)))
    settingsbox = GtkBox(:v)
    playtoolbar = GtkToolbar()

    newgame = GtkToolButton("New Game")
    set_gtk_property!(newgame, :label, "New Game")
    set_gtk_property!(newgame, :is_important, true)

    reveal = GtkToolButton("Reveal")
    set_gtk_property!(reveal, :label, "Reveal Box")
    set_gtk_property!(reveal, :is_important, true)

    map(w->push!(playtoolbar, w),[newgame, reveal])

    scrwin = GtkScrolledWindow()
    can = GtkCanvas()
    set_gtk_property!(can, :expand, true)
    map(w -> push!(box, w),[settingsbox, playtoolbar, scrwin])
    push!(scrwin, can)

    function newgame!(w)
        empty!(ballpositions)
        empty!(guesses)
        empty!(beamhistory)
        guessing, showballs, guesscount, correctguesses = false, false, 0, 0
        fill!(boxes, colorant"wheat")
        boxes[2, 3:end-2] .= boxes[end-1, 3:end-2] .= colorant"red"
        boxes[3:end-2, 2] .= boxes[3:end-2, end-1] .= colorant"red"
        boxes[3:end-2, 3:end-2] .= colorant"black"
        while length(ballpositions) < numballs
            p = BoxPosition(rand(3:boxlength+2), rand(3:boxwidth+2))
            if !(p in ballpositions)
                push!(ballpositions, p)
            end
        end
        draw(can)
    end

    @guarded draw(can) do widget
        ctx = Gtk.getgc(can)
        select_font_face(ctx, "Courier", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_BOLD)
        fontpointsize = 12
        set_font_size(ctx, fontpointsize)
        # print black box graphic
        for i in 1:boxlength + 4, j in 1:boxwidth + 4
            set_source(ctx, boxes[i, j])
            move_to(ctx, boxoffsetx + i * r, boxoffsety + j * r)
            rectangle(ctx, boxoffsetx + i * r, boxoffsety + j * r, r, r)
            fill(ctx)
            p = BoxPosition(i, j)
            # show current guesses
            if p in guesses
                set_source(ctx, colorant"red")
                move_to(ctx, boxoffsetx + i * r + 2, boxoffsety + j * r + fontpointsize)
                show_text(ctx, p in ballpositions ? "+" : "-")
                stroke(ctx)
            end
            # show ball placements if reveal -> showballs
            if showballs && p in ballpositions
                set_source(ctx, colorant"green")
                circle(ctx, boxoffsetx + (i + 0.5) * r , boxoffsety + (j + 0.5) * r, 0.4 * r)
                fill(ctx)
            end
        end
        # draw dividing lines
        set_line_width(ctx, 2)
        set_source(ctx, colorant"wheat")
        for i in 4:boxlength + 2
            move_to(ctx, boxoffsetx + i * r, boxoffsety + 3 * r)
            line_to(ctx, boxoffsetx + i * r, boxoffsety + (boxlength + 3) * r)
            stroke(ctx)
        end
        for j in 4:boxwidth + 2
            move_to(ctx, boxoffsetx + 3 * r, boxoffsety + j * r)
            line_to(ctx, boxoffsetx + (boxlength + 3) * r, boxoffsety + j * r)
            stroke(ctx)
        end
        # show scoring update
        set_source(ctx, colorant"white")
        rectangle(ctx, 0, 305, 400, 50)
        fill(ctx)
        correct, incorrect = string(correctguesses), string(guesscount - correctguesses)
        score = string(2 * correctguesses - guesscount)
        set_source(ctx, colorant"black")
        move_to(ctx, 0, 320)
        show_text(ctx, " Correct: $correct  Incorrect: $incorrect  Score: $score")
        stroke(ctx)
        # show latest trial beams and results and trial history
        set_source(ctx, colorant"white")
        rectangle(ctx, 0, 360, 400, 420)
        fill(ctx)
        set_source(ctx, colorant"black")
        move_to(ctx, 0, 360)
        show_text(ctx, "      Test Beam History")
        stroke(ctx)
        move_to(ctx, 0, 360 + fontpointsize * 1.5)
        show_text(ctx, " #  Start   Result      End")
        stroke(ctx)
        for (i, p) in enumerate(beamhistory)
            move_to(ctx, 0, 360 + fontpointsize * (i + 1.5))
            set_source(ctx, colorant"black")
            s = " " * rpad(i, 3) * rpad("($(p.entry.x - 2),$(p.entry.y - 2))", 8) *
                rpad(p.result, 12) * (p.exit == nothing ? " " :
                    "($(p.exit.x - 2), $(p.exit.y - 2))")
            show_text(ctx, s)
            stroke(ctx)
            move_to(ctx, graphicxyfrombox(p.entry, 0.5 * fontpointsize)...)
            set_source(ctx, colorant"yellow")
            show_text(ctx, string(i))
            stroke(ctx)
            if p.exit != nothing
                move_to(ctx, graphicxyfrombox(p.exit, 0.5 * fontpointsize)...)
                set_source(ctx, colorant"lightblue")
                show_text(ctx, string(i))
                stroke(ctx)
            end
        end
        Gtk.showall(win)
    end

    reveal!(w) = (showballs = !showballs; draw(can); Gtk.showall(win))
    boxfromgraphicxy(x, y) = Int(round(x / r - 1.5)), Int(round(y / r - 1.5))
    graphicxyfrombox(p, oset) = boxoffsetx + p.x * r + oset/2, boxoffsety + p.y * r + oset * 2
    dirnext(x, y, dir) = x + dir[1], y + dir[2]
    rightward(d) = (-d[2], d[1])
    leftward(d) = (d[2], -d[1])
    rearward(direction) = (-direction[1], -direction[2])
    ballfront(x, y, d) = BoxPosition(x + d[1], y + d[2]) in ballpositions
    ballright(x, y, d) = BoxPosition((dirnext(x, y, d) .+ rightward(d))...) in ballpositions
    ballleft(x, y, d) = BoxPosition((dirnext(x, y, d) .+ leftward(d))...) in ballpositions
    twocorners(x, y, d) = !ballfront(x, y, d) && ballright(x, y, d) && ballleft(x, y, d)
    enteringstartzone(x, y, direction) = atstart(dirnext(x, y, direction)...)

    function atstart(x, y)
        return ((x == 2 || x == boxlength + 3) && (2 < y <= boxwidth + 3)) ||
               ((y == 2 || y == boxwidth + 3) && (2 < x <= boxlength + 3))
    end

    function runpath(x, y)
        startp = BoxPosition(x, y)
        direction = (x == 2) ? (1, 0) : (x == boxlength + 3) ? (-1, 0) :
                    (y == 2) ? (0, 1) : (0, -1)
        while true
            if ballfront(x, y, direction)
                return Hit, nothing
            elseif twocorners(x, y, direction)
                if atstart(x, y)
                    return Reflect, startp
                end
                direction = rearward(direction)
                continue
            elseif ballleft(x, y, direction)
                if atstart(x, y)
                    return Reflect, startp
                end
                direction = rightward(direction)
                continue
            elseif ballright(x, y, direction)
                if atstart(x, y)
                    return Reflect, startp
                end
                direction = leftward(direction)
                continue
            elseif enteringstartzone(x, y, direction)
                x2, y2 = dirnext(x, y, direction)
                endp = BoxPosition(x2, y2)
                if x2 == startp.x && y2 == startp.y
                    return Reflect, endp
                else
                    if startp.x == x2 ||  startp.y == y2
                        return Miss, endp
                    else
                        return Detour, endp
                    end
                end
            end
            x, y = dirnext(x, y, direction)
            @assert((2 < x < boxlength + 3) && (2 < y < boxwidth + 3))
        end
    end

    can.mouse.button1press = @guarded (widget, event) -> begin
        x, y = boxfromgraphicxy(event.x, event.y)
        # get click in blackbox area as a guess
        if 2 < x < boxlength + 3 && 2 < y < boxwidth + 3
            p = BoxPosition(x, y)
            if !(p in guesses)
                push!(guesses, BoxPosition(x, y))
                guesscount += 1
                if p in ballpositions
                    correctguesses += 1
                end
            end
            draw(can)
        # test beam
        elseif atstart(x, y)
            result, endpoint = runpath(x, y)
            push!(beamhistory, TrialBeam(BoxPosition(x, y), endpoint, result))
            if length(beamhistory) > 32
                popfirst!(beamhistory)
            end
            draw(can)
        end
    end

    condition = Condition()
    endit(w) = notify(condition)
    signal_connect(endit, win, :destroy)
    signal_connect(newgame!, newgame, :clicked)
    signal_connect(reveal!, reveal, :clicked)

    newgame!(win)
    Gtk.showall(win)
    wait(condition)
end

blackboxapp()
