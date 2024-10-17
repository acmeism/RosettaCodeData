using Gtk.ShortNames

@enum Direction2048 Right Left Up Down

"""
    shifttiles!
The adding and condensing code is for a leftward shift, so if the move is not
leftward, this will rotate matrix to make move leftward, move, then undo rotation.
"""
function shifttiles!(b, siz, direction)
    if direction == Right
        tmpb = rot180(b); points, winner = leftshift!(tmpb, siz); tmpb = rot180(tmpb)
    elseif direction == Up
        tmpb = rotl90(b); points, winner = leftshift!(tmpb, siz); tmpb = rotr90(tmpb)
    elseif direction == Down
        tmpb = rotr90(b); points, winner = leftshift!(tmpb, siz); tmpb = rotl90(tmpb)
    else # left movement function as coded
        return leftshift!(b, siz)
    end
    for i in 1:siz, j in 1:siz
        b[i,j] = tmpb[i,j]   # copy tmpb contents back to b (modifies b)
    end
    points, winner
end


function compactleft!(b, siz, row)
    tmprow = zeros(Int, siz)
    tmppos = 1
    for j in 1:siz
        if b[row,j] != 0
            tmprow[tmppos] = b[row,j]
            tmppos += 1
        end
    end
    b[row,:] = tmprow
end

"""
    leftshift!
Work row by row. First, compact tiles to the left if possible. Second, find and
replace paired tiles in the row, then re-compact. Keep score of merges and return
as pointsgained. If a 2048 value tile is created, return a winner true value.
"""
function leftshift!(b, siz)
    pointsgained = 0
    winner = false
    for i in 1:siz
        compactleft!(b, siz, i)
        tmprow = zeros(Int, siz)
        tmppos = 1
        for j in 1:siz-1
            if b[i,j] == b[i,j+1]
                b[i,j] = 2 * b[i,j]
                b[i,j+1] = 0
                pointsgained += b[i,j]
                if b[i,j] == 2048     # made a 2048 tile, which wins game
                    winner = true
                end
            end
            if b[i,j] != 0
                tmprow[tmppos] = b[i,j]
                tmppos += 1
            end
        end
        tmprow[siz] = b[i,siz]
        b[i,:] = tmprow
        compactleft!(b, siz, i)
    end
    pointsgained, winner
end

"""
    app2048
Run game app, with boardsize (choose 4 for original game) as an argument.
"""
function app2048(bsize)
    win = Window("2048 Game", 400, 400) |> (Frame() |> (box = Box(:v)))
    toolbar = Toolbar()
    newgame = ToolButton("New Game")
    set_gtk_property!(newgame, :label, "New Game")
    set_gtk_property!(newgame, :is_important, true)
    undomove = ToolButton("Undo Move")
    set_gtk_property!(undomove, :label, "Undo Move")
    set_gtk_property!(undomove, :is_important, true)
    map(w->push!(toolbar,w),[newgame,undomove])
    grid = Grid()
    map(w -> push!(box, w),[toolbar, grid])
    buttons = Array{Gtk.GtkButtonLeaf,2}(undef, bsize, bsize)
    for i in 1:bsize, j in 1:bsize
        grid[i,j] = buttons[i,j] = Button()
        set_gtk_property!(buttons[i,j], :expand, true)
    end
    board = zeros(Int, (bsize,bsize))
    pastboardstates = []
    score = 0
    gameover = false
    condition = Condition()
    won = ""

    function update!()
        for i in 1:bsize, j in 1:bsize
            label = (board[i,j] > 0) ? board[i,j] : " "
            set_gtk_property!(buttons[i,j], :label, label)
        end
        set_gtk_property!(win, :title, "$won 2048 Game  (Score: $score)")
    end
    function newrandomtile!()
        blanks = Array{Tuple{Int,Int},1}()
        for i in 1:bsize, j in 1:bsize
            if board[i,j] == 0
                push!(blanks, (i,j))
            end
        end
        if length(blanks) == 0
            gameover = true
        else
            i,j = rand(blanks)
            board[i,j] = (rand() > 0.8) ? 4 : 2
        end
    end
    function initialize!(w)
        won = ""
        gameover = false
        for i in 1:bsize, j in 1:bsize
            board[i,j] = 0
            set_gtk_property!(buttons[i,j], :label, " ")
        end
        newrandomtile!()
        update!()
    end
    function undo!(w)
        if gameover == false
            board = pop!(pastboardstates)
            update!()
        end
    end
    function keypress(w, event)
        presses = Dict(37 => Up,    # code rotated 90 degrees
                       38 => Left,  # because of Gtk coordinates
                       39 => Down,  # y is downward positive
                       40 => Right)
        keycode = event.hardware_keycode
        if haskey(presses, keycode) && gameover == false
            push!(pastboardstates, copy(board))
            newpoints, havewon = shifttiles!(board, bsize, presses[keycode])
            score += newpoints
            if havewon && won != "Winning"
                won = "Winning"
                info_dialog("You have won the game.")
            end
            newrandomtile!()
            update!()
            if gameover
                info_dialog("Game over.\nScore: $score")
            end
        end
    end
    endit(w) = notify(condition)
    initialize!(win)
    signal_connect(initialize!, newgame, :clicked)
    signal_connect(undo!,undomove, :clicked)
    signal_connect(endit, win, :destroy)
    signal_connect(keypress, win, "key-press-event")
    Gtk.showall(win)
    wait(condition)
end


const boardsize = 4
app2048(boardsize)
