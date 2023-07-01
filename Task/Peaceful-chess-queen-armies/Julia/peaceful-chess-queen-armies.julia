using Gtk

struct Position
    row::Int
    col::Int
end

function place!(numeach, bsize, bqueens, wqueens)
    isattack(q, pos) = (q.row == pos.row || q.col == pos.col ||
                        abs(q.row - pos.row) == abs(q.col - pos.col))
    noattack(qs, pos) = !any(x -> isattack(x, pos), qs)
    positionopen(bqs, wqs, p) = !any(x -> x == p, bqs) && !any(x -> x == p, wqs)

    placingbqueens = true
    if numeach < 1
        return true
    end
    for i in 1:bsize, j in 1:bsize
        bpos = Position(i, j)
        if positionopen(bqueens, wqueens, bpos)
            if placingbqueens && noattack(wqueens, bpos)
                push!(bqueens, bpos)
                placingbqueens = false
            elseif !placingbqueens && noattack(bqueens, bpos)
                push!(wqueens, bpos)
                if place!(numeach - 1, bsize, bqueens, wqueens)
                    return true
                end
                pop!(bqueens)
                pop!(wqueens)
                placingbqueens = true
            end
        end
    end
    if !placingbqueens
        pop!(bqueens)
    end
    false
end

function peacefulqueenapp()
    win = GtkWindow("Peaceful Chess Queen Armies", 800, 800) |> (GtkFrame() |> (box = GtkBox(:v)))
    boardsize = 5
    numqueenseach = 4
    hbox = GtkBox(:h)
    boardscale = GtkScale(false, 2:16)
    set_gtk_property!(boardscale, :hexpand, true)
    blabel = GtkLabel("Choose Board Size")
    nqueenscale = GtkScale(false, 1:24)
    set_gtk_property!(nqueenscale, :hexpand, true)
    qlabel = GtkLabel("Choose Number of Queens Per Side")
    solveit = GtkButton("Solve")
    set_gtk_property!(solveit, :label, "   Solve   ")
    solvequeens(wid) = (boardsize = Int(GAccessor.value(boardscale));
        numqueenseach = Int(GAccessor.value(nqueenscale)); update!())
    signal_connect(solvequeens, solveit, :clicked)
    map(w->push!(hbox, w),[blabel, boardscale, qlabel, nqueenscale, solveit])
    scrwin = GtkScrolledWindow()
    grid = GtkGrid()
    push!(scrwin, grid)
    map(w -> push!(box, w),[hbox, scrwin])
    piece = (white = "\u2655", black = "\u265B", blank = "   ")
    stylist = GtkStyleProvider(Gtk.CssProviderLeaf(data="""
        label {background-image: image(cornsilk); font-size: 48px;}
        button {background-image: image(tan); font-size: 48px;}"""))

    function update!()
        bqueens, wqueens = Vector{Position}(), Vector{Position}()
        place!(numqueenseach, boardsize, bqueens, wqueens)
        if length(bqueens) == 0
            warn_dialog("No solution for board size $boardsize and $numqueenseach queens each.", win)
            return
        end
        empty!(grid)
        labels = Array{Gtk.GtkLabelLeaf, 2}(undef, (boardsize, boardsize))
        buttons = Array{GtkButtonLeaf, 2}(undef, (boardsize, boardsize))
        for i in 1:boardsize, j in 1:boardsize
            if isodd(i + j)
                grid[i, j] = buttons[i, j] = GtkButton(piece.blank)
                set_gtk_property!(buttons[i, j], :expand, true)
                push!(Gtk.GAccessor.style_context(buttons[i, j]), stylist, 600)
            else
                grid[i, j] = labels[i, j] = GtkLabel(piece.blank)
                set_gtk_property!(labels[i, j], :expand, true)
                push!(Gtk.GAccessor.style_context(labels[i, j]), stylist, 600)
            end
            pos = Position(i, j)
            if pos in bqueens
                set_gtk_property!(grid[i, j], :label, piece.black)
            elseif pos in wqueens
                set_gtk_property!(grid[i, j], :label, piece.white)
            end
        end
        showall(win)
    end

    update!()
    cond = Condition()
    endit(w) = notify(cond)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(cond)
end

peacefulqueenapp()
