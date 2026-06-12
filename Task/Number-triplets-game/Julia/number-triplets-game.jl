using Random, Gtk

blue = GtkCssProvider(data="#blue {background:blue;}")
black = GtkCssProvider(data="#black {background:black;}")
yellow = GtkCssProvider(data="#yellow {background:yellow;}")
white =  GtkCssProvider(data="#white {background:white;}")
red = GtkCssProvider(data="#red {background:red; font-size:40px}")
spblue = GtkStyleProvider(blue)
spblack = GtkStyleProvider(black)
spyellow = GtkStyleProvider(yellow)
spwhite = GtkStyleProvider(white)
spred = GtkStyleProvider(red)
sp = [spblue spblack spblack spblack spblack;
      spblue spyellow spred spred spred;
      spblue spwhite spwhite spwhite spwhite;
      spblue spyellow spred spred spred;
      spblue spwhite spwhite spwhite spwhite;
      spblue spyellow spred spred spred;
      spblue spwhite spwhite spwhite spwhite;
      spblue spyellow spred spred spred;
      spblue spblack spblack spblack spblack;]
colors = ["blue" "black" "black" "black" "black";
          "blue" "yellow" "red" "red" "red";
          "blue" "white" "white" "white" "white";
          "blue" "yellow" "red" "red" "red";
          "blue" "white" "white" "white" "white";
          "blue" "yellow" "red" "red" "red";
          "blue" "white" "white" "white" "white";
          "blue" "yellow" "red" "red" "red";
          "blue" "black" "black" "black" "black";]
startingpositions = [(2, 5), (2, 4), (2, 3), (2, 2), (4, 5), (4, 4), (4, 3), (4, 2),
                     (6, 5), (6, 4), (6, 3), (6, 2), (8, 5), (8, 4), (8, 3), (8, 2)]
labels = ["" "" "" "" "";
             "" "" "1" "1" "1";
             "" "" "" "" "";
             "" "" "2" "2" "2";
             "" "" "" "" "";
             "" "" "3" "3" "3";
             "" "" "" "" "";
             "" "" "4" "4" "4";
             "" "" "" "" ""]

mutable struct GameTile
    style::GtkStyleProvider
    color::String
    label::String
end

function NumberTripletsApp(w=800, h=500)
    moves, won, ygrid, xgrid, basetiles, tiles = 0, false, 5, 9, Matrix{GameTile}, Matrix{GameTile}
    buttons = [GtkButton() for i in 1:xgrid, j in 1:ygrid]
    for i in 1:xgrid, j in 1:ygrid
        set_gtk_property!(buttons[i, j], :expand, true)
    end
    function newgame()
        moves, won = 0, false
        basetiles = [GameTile(sp[i, j], colors[i, j], labels[i, j])
            for i in 1:xgrid, j in 1:ygrid]
        tiles = deepcopy(basetiles)
        for (i, p) in enumerate(shuffle(startingpositions))
            x, y = startingpositions[i]
            tiles[first(p), last(p)], tiles[x, y] = tiles[x, y], tiles[first(p), last(p)]
        end
        for i in 2:2:8, j in 2:5  # previous red tile start becomes yellow if empty
            basetiles[i, j] = GameTile(spyellow, "yellow", "")
        end
        for i in 1:xgrid, j in 1:ygrid
            tiles[i, j].color != "red" && (tiles[i, j] = basetiles[i, j])
        end
        setbuttonview()
    end
    function setbuttonview()
        # set text, color of each GtkButton in buttons as per corresponding tiles
        for i in 1:xgrid, j in 1:ygrid
            GAccessor.label(buttons[i, j], "  ")
            GAccessor.label(buttons[i, j], tiles[i, j].label)
            sc = GAccessor.style_context(buttons[i, j])
            push!(sc, tiles[i, j].style, 550)
            set_gtk_property!(buttons[i, j], :name, tiles[i, j].color)
        end
    end
    newgame()
    win = GtkWindow("Number Triplets Game", w, h)
    vbox = GtkBox(:v)
    newgamebutton = GtkButton("New Game")
    signal_connect(w -> newgame(), newgamebutton, "clicked")
    prompt1, prompt2 = "Choose a Red Button", "Choose a Yellow or Blue Button"
    promptlabel = GtkLabel(prompt1)
    grid = GtkGrid()
    set_gtk_property!(grid, :column_homogeneous, true)
    set_gtk_property!(grid, :row_homogeneous, true)
    bstate, lasttile, lastx, lasty = 0, nothing, 0, 0
    function process_click(i, j)
        if bstate == 0
            if tiles[i, j].label != ""
                bstate, lasttile, lastx, lasty = 1, tiles[i, j], i, j
                GAccessor.text(promptlabel, "                               ")
                GAccessor.text(promptlabel, "(Moves: $moves) $prompt2")
            end
        elseif bstate == 1
            if tiles[i, j].color in ["yellow", "blue"] && lasttile != nothing &&
                hasclearpath(lastx, lasty, i, j)
                moves += 1
                lasttile = basetiles[i, j]
                tiles[i, j] = lasttile
                tiles[lastx, lasty], tiles[i, j] = basetiles[lastx, lasty], tiles[lastx, lasty]
                setbuttonview()
                if map(x -> x.label, tiles) == labels
                    !won && info_dialog("You have won the game. (Moves: $moves)")
                    won = true
                end
            end
            GAccessor.text(promptlabel, "                               ")
            GAccessor.text(promptlabel, prompt1)
            bstate, lasttile, lastx, lasty = 0, nothing, 0, 0
        end
    end
    function hasclearpath(x1, y1, x2, y2)
        dx, dy = x2 - x1, y2 -y1
        ((dx == 0 && dy == 0) || dx * dy != 0) && return false # rook-format moves
        if dx != 0
            for k in x1+sign(dx):x2
                tiles[k, y2].color != "blue" && return false
            end
        elseif dy != 0
            for k in y1+sign(dy):y2
                !(tiles[x2, k].color in ["yellow", "blue"]) && return false
            end
        end
        return true
    end
    for i in 1:xgrid, j in 1:ygrid
        signal_connect(w -> process_click(i, j), buttons[i, j], "clicked")
        grid[i, j] = buttons[i, j]
    end
    push!(vbox, promptlabel)
    push!(vbox, newgamebutton)
    push!(vbox, grid)
    push!(win, vbox)
    done = Condition()
    endit(w) = notify(done)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(done)
end

NumberTripletsApp()
