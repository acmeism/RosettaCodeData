global nCells, cMap, best
record Pos(r,c)

procedure main(A)
    puzzle := showPuzzle("Input",readPuzzle())
    QMouse(puzzle,findStart(puzzle),&null,0)
    showPuzzle("Output", solvePuzzle(puzzle)) | write("No solution!")
end

procedure readPuzzle()
    # Start with a reduced puzzle space
    p := []
    nCells := maxCols := 0
    every line := !&input do {
        put(p,[: gencells(line) :])
        maxCols <:= *p[-1]
        }
    # Now normalize all rows to the same length
    every i := 1 to *p do p[i] := [: !p[i] | (|-1\(maxCols - *p[i])) :]
    return p
end

procedure gencells(s)
    static WS, NWS
    initial {
        NWS := ~(WS := " \t")
        cMap := table()     # Map to/from internal model
        cMap["_"] :=  0; cMap[0]   := "_"
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
    method atEnd(); return (nCells = val, puzzle[loc.r,loc.c] = (val|0)); end
    method visit(r,c); return (/best, validPos(r,c), Pos(r,c)); end

    method validPos(r,c)
        v := val+1      # number we're looking for
        xv := puzzle[r,c] | fail
        if (xv ~= 0) & (xv != v) then fail
        if xv = (0|v) then {
            ancestor := self
            while xl := (ancestor := \ancestor.getParent()).getLoc() do
                if (xl.r = r) & (xl.c = c) then fail
            return
            }
    end

initially
    val := val+1
    if atEnd() then return best := self
    QMouse(puzzle, visit(loc.r-1,loc.c)  , self, val)   # North
    QMouse(puzzle, visit(loc.r,  loc.c+1), self, val)   # East
    QMouse(puzzle, visit(loc.r+1,loc.c),   self, val)   # South
    QMouse(puzzle, visit(loc.r,  loc.c-1), self, val)   # West
end
