using Gtk, Random

function puzzle16app(bsize)
    aclock, clock = "\u27f2", "\u27f3"
    win = GtkWindow("16 Game", 300, 300) |> (GtkFrame() |> (box = GtkBox(:v)))
    toolbar = GtkToolbar()
    newgame = GtkToolButton("New Game")
    set_gtk_property!(newgame, :label, "New Game")
    set_gtk_property!(newgame, :is_important, true)
    push!(toolbar, newgame)
    grid = GtkGrid()
    map(w -> push!(box, w),[toolbar, grid])
    buttons = Array{Gtk.GtkButtonLeaf,2}(undef, bsize + 2, bsize + 2)
    for i in 1:bsize+2, j in 1:bsize+2
        grid[i,j] = buttons[i,j] = GtkButton()
        set_gtk_property!(buttons[i,j], :expand, true)
    end

    inorder = string.(reshape(1:bsize*bsize, bsize, bsize))
    puzzle = shuffle(inorder)
    rotatecol(puzzle, col, n) = puzzle[:, col] .= circshift(puzzle[:, col], n)
    rotaterow(puzzle, row, n) = puzzle[row, :] .= circshift(puzzle[row, :], n)
    iswon() = puzzle == inorder
    won = false

    function findrowcol(button)
        for i in 1:bsize+2, j in 1:bsize+2
            if buttons[i, j] == button
                return i, j
            end
        end
        return 0, 0
    end

    function playerclicked(button)
        if !won
        i, j = findrowcol(button)
            if i == 1
                rotatecol(puzzle, j - 1, 1)
            elseif i == bsize + 2
                rotatecol(puzzle, j - 1, -1)
            elseif j == 1
                rotaterow(puzzle, i - 1, 1)
            elseif j == bsize + 2
                rotaterow(puzzle, i - 1, -1)
            end
        end
        update!()
    end

    function setup!()
        for i in 1:bsize+2, j in 1:bsize+2
            if 1 < j < bsize + 2
                if i == 1
                    signal_connect(playerclicked, buttons[i, j], "clicked")
                elseif i == bsize + 2
                    signal_connect(playerclicked, buttons[i, j], "clicked")
                end
            elseif 1 < i < bsize + 2
                if j == 1
                    signal_connect(playerclicked, buttons[i, j], "clicked")
                elseif j == bsize + 2
                    signal_connect(playerclicked, buttons[i, j], "clicked")
                end
            end
        end
    end

    function update!()
        for i in 1:bsize+2, j in 1:bsize+2
            if 1 < j < bsize + 2
                if i == 1
                    set_gtk_property!(buttons[i, j], :label, clock)
                elseif i == bsize + 2
                    set_gtk_property!(buttons[i, j], :label, aclock)
                else
                    set_gtk_property!(buttons[i, j], :label, puzzle[i-1, j-1])
                end
            elseif 1 < i < bsize + 2
                if j == 1
                    set_gtk_property!(buttons[i, j], :label, clock)
                elseif j == bsize + 2
                    set_gtk_property!(buttons[i, j], :label, aclock)
                end
            end
        end
        if iswon()
            won = true
            info_dialog("Game over.\nScore: $score", win)
        end
        showall(win)
    end

    function initialize!(w)
        puzzle = shuffle(inorder)
        won = false
        update!()
    end

    setup!()
    condition = Condition()
    endit(w) = notify(condition)
    signal_connect(initialize!, newgame, :clicked)
    signal_connect(endit, win, :destroy)
    initialize!(win)
    showall(win)
    wait(condition)
end

puzzle16app(4)
