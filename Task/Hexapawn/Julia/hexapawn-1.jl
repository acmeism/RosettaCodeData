using Gtk, Base

const whitepawn = UInt8('w')
const blackpawn = UInt8('b')
const space = UInt8(' ')
const unipawns = Dict(space => " ", whitepawn => "\u2659", blackpawn => "\u265f")
ispawn(c) = (c == whitepawn || c == blackpawn)
oppositepawn(c1, c2) = ispawn(c1) && ispawn(c2) && c1 != c2

mutable struct HState
    board::Matrix{UInt8}
    whitetomove::Bool
    HState(arr, iswhite) = new(reshape(UInt8.(arr), 3, 3), iswhite)
end
string(h::HState) = join([Char(c) for c in h.board], "") * (h.whitetomove ? "|t" : "|f")

const avoided = Vector{String}()

function legalmoves(board, px, py)
    moves = Vector{Pair{Int, Int}}()
    c = board[py, px]
    newrow = px + (c == whitepawn ? +1 : -1)
    if ispawn(c) && 0 < newrow < 4
        if py > 1 && oppositepawn(c, board[py - 1, newrow])
            push!(moves, Pair(newrow, py - 1))
        end
        if board[py, newrow] == UInt8(' ')
            push!(moves, Pair(newrow, py))
        end
        if py < 3 && oppositepawn(c, board[py + 1, newrow])
            push!(moves, Pair(newrow, py + 1))
        end
    end
    moves
end

islegalmove(board, px, py, i, j) = Pair(i, j) in legalmoves(board, px, py)

function allavailablemoves(board, forwhite)
    allret = Vector{Pair{Vector{Int}, Vector{Pair{Int, Int}}}}()
    for i in 1:3, j in 1:3
        if (board[j, i] == whitepawn && forwhite) || (board[j, i] == blackpawn && !forwhite)
            legmov = legalmoves(board, i, j)
            if !isempty(legmov)
                push!(allret, [i, j] => legmov)
            end
        end
    end
    allret
end

function checkforwin(hstate)
    if any(x -> hstate.board[x] == whitepawn, 7:9)
        return whitepawn # white win
    elseif any(x -> hstate.board[x] == blackpawn, 1:3)
        return blackpawn # black win
    else
        if length(allavailablemoves(hstate.board, hstate.whitetomove)) == 0
            return hstate.whitetomove ? blackpawn : whitepawn
        end
    end
    UInt8(' ') # hstate is not a winning position
end

function hexapawnapp()
    win = GtkWindow("Hexapawn Game", 425, 425) |> (GtkFrame() |> (box = GtkBox(:v)))
    toolbar = GtkToolbar()
    newWgame = GtkToolButton("New Game, Play as White")
    set_gtk_property!(newWgame, :label, "New Game, Play as White")
    set_gtk_property!(newWgame, :is_important, true)
    newBgame = GtkToolButton("New Game, Play as Black")
    set_gtk_property!(newBgame, :label, "New Game, Play as Black")
    set_gtk_property!(newBgame, :is_important, true)
    map(w->push!(toolbar,w),[newWgame, newBgame])
    scrwin = GtkScrolledWindow()
    grid = GtkGrid()
    map(w -> push!(box, w),[toolbar, scrwin])
    push!(scrwin, grid)
    buttons = Array{Gtk.GtkButtonLeaf, 2}(undef, 3, 3)
    stylist = GtkStyleProvider(Gtk.CssProviderLeaf(data="button {font-size:64px;}"))
    for i in 1:3, j in 1:3
        grid[i, 4-j] = buttons[i, j] = GtkButton()
        set_gtk_property!(buttons[i, j], :expand, true)
        push!(Gtk.GAccessor.style_context(buttons[i, j]), stylist, 600)
    end

    state = HState(b"www   bbb", true)
    won = ""
    pwhite = true
    ptomove = false
    ctomove = false
    pselected = false
    xsel, ysel = 0, 0
    laststate = ""

    function update!()
        for i in 1:3, j in 1:3
            set_gtk_property!(buttons[i, j], :label, unipawns[state.board[i, j]])
        end
        if (w = checkforwin(state)) != UInt8(' ')
            if pwhite == (w == whitepawn)
                push!(avoided, laststate)
            end
            won = (w == whitepawn) ? "White Has Won" : "Black Has Won"
            ptomove, ctomove = false, false
        else
            won = ""
        end
        set_gtk_property!(win, :title, "$won Hexapawn Game")
    end

    function initialize!()
        state = HState(b"www   bbb", true)
        won = ""
        pselected = false
        update!()
    end

    function newgame!(p)
        initialize!()
        if p == whitepawn
            pwhite = true
            ptomove, ctomove = true, false
        else
            pwhite = false
            ptomove, ctomove = false, true
        end
    end

    function domove!(board, m)
        board[m[4], m[3]], board[m[2], m[1]] = board[m[2], m[1]], UInt8(' ')
        update!()
    end

    function findrowcol(button)
        for i in 1:3, j in 1:3
            if buttons[i, j] == button
                return i, j
            end
        end
        return 0, 0
    end

    function playerclicked(button)
        update!()
        if won == "" && ptomove
            j, i = findrowcol(button)
            if !pselected && i > 0 &&
                state.board[j, i] == (pwhite ? whitepawn : blackpawn)
                xsel, ysel = i, j
                pselected = true
            elseif pselected
                if islegalmove(state.board, xsel, ysel, i, j)
                    domove!(state.board, [xsel, ysel, i, j])
                    xsel, ysel = 0, 0
                    pselected = false
                    ptomove = false
                    ctomove = true
                    state.whitetomove = !state.whitetomove
                else
                    pselected = false
                    xsel, ysel = 0, 0
                end
            end
        end
        update!()
    end

    function computerplay!()
        while true
            if won == "" && ctomove
                cmoves = Vector{Vector{Int}}()
                update!()
                if string(state) == "www   bbb|t"
                    push!(cmoves, rand([[1, 1, 2, 1], [1, 2, 2, 2], [1, 3, 2, 3]]))
                else
                    for p in allavailablemoves(state.board, state.whitetomove), m in p[2]
                        b = deepcopy(state.board)
                        i1, j1, i2, j2 = p[1][1], p[1][2], m[1], m[2]
                        b[j1, i1], b[j2, i2] = b[j2, i2], b[j1, i1]
                        newstate = HState(b, !state.whitetomove)
                        x = checkforwin(newstate)
                        if x != space && state.whitetomove == (x == whitepawn)
                            empty!(cmoves)
                            push!(cmoves, [i1, j1, i2, j2])
                            break
                        elseif !(string(newstate) in avoided)
                            push!(cmoves, [i1, j1, i2, j2])
                        end
                    end
                end
                cmove = rand(cmoves)
                ptomove, ctomove = true, false
                state.whitetomove = !state.whitetomove
                domove!(state.board, cmove)
                laststate = string(state)
            end
            yield()
            sleep(0.2)
        end
    end

    for i in 1:3, j in 1:3
        signal_connect(playerclicked, buttons[i, j], "clicked")
    end
    newplayerwhitegame!(w) = newgame!(whitepawn)
    newplayerblackgame!(w) = newgame!(blackpawn)
    signal_connect(newplayerwhitegame!, newWgame, :clicked)
    signal_connect(newplayerblackgame!, newBgame, :clicked)
    newplayerwhitegame!(win)
    condition = Condition()
    endit(w) = notify(condition)
    signal_connect(endit, win, :destroy)
    showall(win)
    @async computerplay!()
    wait(condition)
end

hexapawnapp()
