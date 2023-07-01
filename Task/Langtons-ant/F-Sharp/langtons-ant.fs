// Langton's ant  F#   https://rosettacode.org/wiki/Langton%27s_ant

// A list of cells which are black is maintained and then printed out at the end

type Cell = { X : int; Y : int }
type Direction = | North | South | East| West // direction the ant is facing

let withinBounds (dim:int) (cell: Cell) = // ant's cell within dimensions ?
    cell.X < dim && cell.Y < dim && cell.X >= 0 && cell.Y >= 0

let rotateLeft (currentDirection: Direction) =
    match currentDirection with
        | North -> West | South -> East | East -> North | West -> South

let rotateRight (currentDirection: Direction ) =
    match currentDirection with
        | North -> East | South -> West | East -> South | West -> North

let nextCell (dir:Direction) (cell: Cell) = // compute next cell based on the direction
    match dir with
        | North -> {cell with Y = cell.Y + 1 }
        | South -> {cell with Y = cell.Y - 1 }
        | East ->  {cell with X = cell.X + 1 }
        | West ->  {cell with X = cell.X - 1 }

let isBlackCell (blackCells: Cell list) (cell:Cell) =
    blackCells |> List.exists ( fun c -> c = cell)

let toggleCellColor (blackCells: Cell list) (cell: Cell) =
     if cell |> isBlackCell blackCells
     then blackCells |> List.where( fun c -> c <> cell) // remove the cell from list of black cells
     else cell::blackCells // add the cell to the list of black cells

let moveToCell (blackCells: Cell list) (currentDir : Direction) (cell: Cell) =
    let ndir = if cell |> isBlackCell blackCells  // next step direction is computed
                    then rotateLeft currentDir
                    else rotateRight currentDir
    let nlst  = cell |> toggleCellColor blackCells // next step updated list of black cells is computed
    let ncell = cell |> nextCell ndir  // next step cell is computedd
    (nlst, ndir, ncell) // return next step list of black cells, direction it will enter the cell, new cell

let rec doStep (dim:int) (blackCells: Cell list) (dir : Direction) (cell: Cell) =
        let (nlst, ndir, ncell) = moveToCell blackCells dir cell
        if withinBounds dim ncell // check if the next step is within bounds
            then doStep dim nlst ndir ncell // recursive call to next step
            else nlst, ndir, ncell

[<EntryPoint>]
let main _ =
   let dim = 100
   let (blacklist, _, _) = doStep dim []  North { X = dim/2 ; Y = dim/2 } // start with empty blacklist, facing north in the center

    // print out by row, 0th row is at the bottom
   seq { for row in [dim-1..-1..0] do for col in [0..dim-1]  -> (col,row) }
        |> Seq.iter (fun (row,col) -> if {X = row; Y = col } |> isBlackCell blacklist
                                        then printf "#"  else printf " "
                                      if row = (dim - 1 )
                                        then printf "\n"  else  ()
                    )
   0
