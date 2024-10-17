using Gtk, Colors, Cairo, Graphics

struct Guess
    code::Vector{Color}
    guess::Vector{Color}
    hint::Vector{Color}
end

function Guess(code, guess)
    len = length(code)
    hints = fill(colorant"gray", len) # gray default
    for (i, g) in enumerate(guess), (j, c) in enumerate(code)
        if g == c
            if i == j
                hints[i] = colorant"black"
            elseif hints[i] != colorant"black"
                hints[i] = colorant"white"
            end
        end
    end
    g = Guess([c for c in code], [c for c in guess], [c for c in hints])
end

tovec(guess) = [x for x in [guess.code; guess.guess; guess.hint]]

function mastermindapp()
    allu(s) = length(unique(s)) == length(s)
    ccode(c, n, rok) = while true a = rand(c, n); if rok || allu(a) return a end end

    numcolors, codelength, maxguesses, allowrep, gameover = 10, 4, 10, false, false
    colors = distinguishable_colors(numcolors)
    code = ccode(colors, numcolors, allowrep)
    guesshistory = Vector{Guess}()

    win = GtkWindow("Mastermind Game", 900, 750) |> (GtkFrame() |> (box = GtkBox(:v)))
    settingsbox = GtkBox(:h)
    playtoolbar = GtkToolbar()

    setcolors = GtkScale(false, 4:20)
    set_gtk_property!(setcolors, :hexpand, true)
    adj = GtkAdjustment(setcolors)
    set_gtk_property!(adj, :value, 10)
    clabel = GtkLabel("Number of Colors")

    setcodelength = GtkScale(false, 4:10)
    set_gtk_property!(setcodelength, :hexpand, true)
    adj = GtkAdjustment(setcodelength)
    set_gtk_property!(adj, :value, 4)
    slabel = GtkLabel("Code Length")

    setnumguesses = GtkScale(false, 4:40)
    set_gtk_property!(setnumguesses, :hexpand, true)
    adj = GtkAdjustment(setnumguesses)
    set_gtk_property!(adj, :value, 10)
    nlabel = GtkLabel("Max Guesses")

    allowrepeatcolor = GtkScale(false, 0:1)
    set_gtk_property!(allowrepeatcolor, :hexpand, true)
    rlabel = GtkLabel("Allow Repeated Colors (0 = No)")

    newgame = GtkToolButton("New Game")
    set_gtk_property!(newgame, :label, "New Game")
    set_gtk_property!(newgame, :is_important, true)

    tryguess = GtkToolButton("Submit Current Guess")
    set_gtk_property!(tryguess, :label, "Submit Current Guess")
    set_gtk_property!(tryguess, :is_important, true)

    eraselast = GtkToolButton("Erase Last (Unsubmitted) Pick")
    set_gtk_property!(eraselast, :label, "Erase Last (Unsubmitted) Pick")
    set_gtk_property!(eraselast, :is_important, true)

    map(w->push!(settingsbox, w),[clabel, setcolors, slabel, setcodelength,
        nlabel, setnumguesses, rlabel, allowrepeatcolor])
    map(w->push!(playtoolbar, w),[newgame, tryguess, eraselast])

    scrwin = GtkScrolledWindow()
    can = GtkCanvas()
    set_gtk_property!(can, :expand, true)
    map(w -> push!(box, w),[settingsbox, playtoolbar, scrwin])
    push!(scrwin, can)

    currentguess = RGB[]
    guessesused = 0
    colorpositions = Point[]

    function newgame!(w)
        empty!(guesshistory)

        numcolors = Int(GAccessor.value(setcolors))
        codelength = Int(GAccessor.value(setcodelength))
        maxguesses = Int(GAccessor.value(setnumguesses))
        allowrep = Int(GAccessor.value(allowrepeatcolor))

        colors = distinguishable_colors(numcolors)
        code = ccode(colors, codelength, allowrep == 1)
        empty!(currentguess)
        currentneeded = codelength
        guessesused = 0
        gameover = false
        draw(can)
    end
    signal_connect(newgame!, newgame, :clicked)

    function saywon!()
        warn_dialog("You have WON the game!", win)
        gameover = true
    end

    function outofguesses!()
        warn_dialog("You have Run out of moves! Game over.", win)
        gameover = true
    end

    can.mouse.button1press = @guarded (widget, event) -> begin
        if !gameover && (i = findfirst(p ->
            sqrt((p.x - event.x)^2 + (p.y - event.y)^2) < 20,
                colorpositions)) != nothing
            if length(currentguess) < codelength
                if allowrep == 0 && !allu(currentguess)
                    warn_dialog("Please erase the duplicate color.", win)
                else
                    push!(currentguess, colors[i])
                    draw(can)
                end
            else
                warn_dialog("You need to submit this guess if ready.", win)
            end
        end
    end

    @guarded draw(can) do widget
        ctx = Gtk.getgc(can)
        select_font_face(ctx, "Courier", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_BOLD)
        fontpointsize = 12
        set_font_size(ctx, fontpointsize)
        workcolor = colorant"black"
        set_source(ctx, workcolor)
        move_to(ctx, 0, fontpointsize)
        show_text(ctx, "Color options: " * "-"^70)
        stroke(ctx)
        empty!(colorpositions)
        for i in 1:numcolors
            set_source(ctx, colors[i])
            circle(ctx, i * 40, 40, 20)
            push!(colorpositions, Point(i * 40, 40))
            fill(ctx)
        end
        set_gtk_property!(can, :expand, false) # kludge for good text overwriting
        move_to(ctx, 0, 80)
        set_source(ctx, workcolor)
        show_text(ctx, string(maxguesses - guessesused, pad = 2) * " moves remaining.")
        stroke(ctx)
        set_gtk_property!(can, :expand, true)
        for i in 1:codelength
            set_source(ctx, i > length(currentguess) ? colorant"lightgray" : currentguess[i])
            circle(ctx, i * 40, 110, 20)
            fill(ctx)
        end
        if length(guesshistory) > 0
            move_to(ctx, 0, 155)
            set_source(ctx, workcolor)
            show_text(ctx, "Past Guesses: " * "-"^70)
            for (i, g) in enumerate(guesshistory), (j, c) in enumerate(tovec(g)[codelength+1:end])
                x = j * 40 + (j > codelength ? 20 : 0)
                y = 150 + 40 * i
                set_source(ctx, c)
                circle(ctx, x, y, 20)
                fill(ctx)
            end
        end
        Gtk.showall(win)
    end

    function submitguess!(w)
        if length(currentguess) == length(code)
            g = Guess(code, currentguess)
            push!(guesshistory, g)
            empty!(currentguess)
            guessesused += 1
            draw(can)
            if all(i -> g.code[i] == g.guess[i], 1:length(code))
                saywon!()
            elseif guessesused > maxguesses
                outofguesses!()
            end
        end
    end
    signal_connect(submitguess!, tryguess, :clicked)

    function undolast!(w)
        if length(currentguess) > 0
            pop!(currentguess)
            draw(can)
        end
    end
    signal_connect(undolast!, eraselast, :clicked)

    newgame!(win)
    Gtk.showall(win)

    condition = Condition()
    endit(w) = notify(condition)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(condition)
end

mastermindapp()
