using Gtk

struct BState
    board::Matrix{Int}
    row::Int
    col::Int
end

function greedapp(r, c)
    rows, cols = c, r  # gtk rotates grid 90 degrees
    win = GtkWindow("Greed Game", 1200, 400) |> (GtkFrame() |> (box = GtkBox(:v)))
    toolbar = GtkToolbar()
    newgame = GtkToolButton("New Game")
    set_gtk_property!(newgame, :label, "New Game")
    set_gtk_property!(newgame, :is_important, true)
    undomove = GtkToolButton("Undo Move")
    set_gtk_property!(undomove, :label, "Undo Move")
    set_gtk_property!(undomove, :is_important, true)
    map(w->push!(toolbar,w),[newgame,undomove])
    scrwin = GtkScrolledWindow()
    grid = GtkGrid()
    map(w -> push!(box, w),[toolbar, scrwin])
    push!(scrwin, grid)
    buttons = Array{Gtk.GtkButtonLeaf, 2}(undef, rows, cols)
    for i in 1:rows, j in 1:cols
        grid[i,j] = buttons[i,j] = GtkButton()
        set_gtk_property!(buttons[i,j], :expand, true)
    end
    function findrowcol(button)
        for i in 1:rows, j in 1:cols
            if buttons[i, j] == button
                return i, j
            end
        end
        return 0, 0
    end
    board = zeros(Int, rows, cols)
    pastboardstates = Vector{BState}()
    score = 0
    condition = Condition()
    won = ""
    myrow, mycol = 1, 1
    function update!()
        for i in 1:rows, j in 1:cols
            label = (board[i, j] > 0) ? board[i, j] : " "
            set_gtk_property!(buttons[i, j], :label, label)
        end
        set_gtk_property!(buttons[myrow, mycol], :label, "@")
        won = all(iszero, board) ? "WINNING" : ""
        set_gtk_property!(win, :title, "$won Greed Game  (Score: $score)")
    end
    function erasefromtile!(moverow, movecol)
        xdir, ydir = moverow - myrow, movecol - mycol
        if abs(xdir) > 1 || abs(ydir) > 1 || 0 == xdir == ydir || board[moverow, movecol] == 0
            return
        end
        push!(pastboardstates, BState(deepcopy(board), myrow, mycol))
        for i in 1:board[moverow, movecol]
            x, y = myrow + xdir * i, mycol + ydir * i
            if 0 < x <= rows && 0 < y <= cols
                board[x, y] = 0
                score += 1
            end
        end
        board[myrow, mycol] = 0
        myrow = moverow
        mycol = movecol
        update!()
    end
    clicked(button) = begin x, y = findrowcol(button); erasefromtile!(x, y)  end
    function initialize!(w)
        won = ""
        possiblevals = collect(1:9)
        for i in 1:rows, j in 1:cols
            board[i, j] = rand(possiblevals)
            set_gtk_property!(buttons[i,j], :label, board[i, j])
            signal_connect(clicked, buttons[i, j], "clicked")
        end
        myrow = rand(1:rows)
        mycol = rand(1:cols)
        board[myrow, mycol] = 0
        update!()
    end
    function undo!(w)
        if won == "" && length(pastboardstates) > 0
            bst = pop!(pastboardstates)
            board, myrow, mycol = bst.board, bst.row, bst.col
            update!()
        end
    end
    endit(w) = notify(condition)
    initialize!(win)
    signal_connect(initialize!, newgame, :clicked)
    signal_connect(undo!, undomove, :clicked)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(condition)
end

# greedapp(22, 79)  # This would be per task, though a smaller game board is nicer
greedapp(12, 29)
