global nCells, cMap, best
record Pos(r,c)

procedure main(A)
    puzzle := showPuzzle("Input",readPuzzle())
    QMouse(puzzle,findStart(puzzle),&null,0)
    showPuzzle("Output", solvePuzzle(puzzle)) | write("No solution!")
end

procedure readPuzzle()
    # Start with a reduced puzzle space
    p := [[-1]]
    nCells := maxCols := 0
    every line := !&input do {
        put(p,[: -1 | gencells(line) | -1 :])
        maxCols <:= *p[-1]
        }
    put(p, [-1])
    # Now normalize all rows to the same length
    every i := 1 to *p do p[i] := [: !p[i] | (|-1\(maxCols - *p[i])) :]
    return p
end

procedure gencells(s)
    static WS, NWS
    initial {
        NWS := ~(WS := " \t")
        cMap := table()     # Map to/from internal model
        cMap["#"] := -1;  cMap["_"] :=  0
        cMap[-1]  := " "; cMap[0]   := "_"
        }

    s ? while not pos(0) do {
            w := (tab(many(WS))|"", tab(many(NWS))) | break
            w := numeric(\cMap[w]|w)
            if -1 ~= w then nCells +:= 1
            suspend w
            }
end

procedure showPuzzle(label, p)
    write(label," with ",nCells," cells:")
    every r := !p do {
        every c := !r do writes(right((\cMap[c]|c),*nCells+1))
        write()
        }
    return p
end

procedure findStart(p)
    if \p[r := !*p][c := !*p[r]] = 1 then return Pos(r,c)
end

procedure solvePuzzle(puzzle)
    if path := \best then {
        repeat {
            loc := path.getLoc()
            puzzle[loc.r][loc.c] := path.getVal()
            path := \path.getParent() | break
            }
        return puzzle
        }
end

class QMouse(puzzle, loc, parent, val)
    method getVal(); return val; end
    method getLoc(); return loc; end
    method getParent(); return parent; end
    method atEnd(); return (nCells = val) = puzzle[loc.r][loc.c]; end
    method goNorth(); return visit(loc.r-1,loc.c);   end
    method goNE();    return visit(loc.r-1,loc.c+1); end
    method goEast();  return visit(loc.r,  loc.c+1); end
    method goSE();    return visit(loc.r+1,loc.c+1); end
    method goSouth(); return visit(loc.r+1,loc.c);   end
    method goSW();    return visit(loc.r+1,loc.c-1); end
    method goWest();  return visit(loc.r,  loc.c-1); end
    method goNW();    return visit(loc.r-1,loc.c-1); end

    method visit(r,c)
        if /best & validPos(r,c) then return Pos(r,c)
    end

    method validPos(r,c)
        xv := puzzle[r][c]
        if xv = (val+1) then return
        if xv = 0 then {  # make sure this path hasn't already gone there
            ancestor := self
            while xl := (ancestor := \ancestor.getParent()).getLoc() do
                if (xl.r = r) & (xl.c = c) then fail
            return
            }
    end

initially
    val +:= 1
    if atEnd() then return best := self
    QMouse(puzzle, goNorth(), self, val)
    QMouse(puzzle, goNE(),    self, val)
    QMouse(puzzle, goEast(),  self, val)
    QMouse(puzzle, goSE(),    self, val)
    QMouse(puzzle, goSouth(), self, val)
    QMouse(puzzle, goSW(),    self, val)
    QMouse(puzzle, goWest(),  self, val)
    QMouse(puzzle, goNW(),    self, val)
end
