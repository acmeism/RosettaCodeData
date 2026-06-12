'###############################
'###   A* search algorithm   ###
'###############################

'A number big enough to be greater than any possible path cost
#define MAX_DIST 100000

type coordinates
'coordinates of a cell
    row as integer
    col as integer
end type

type listCoordinates
'list of coordinates
    length as integer
    coord(1 to 64) as coordinates
end type

type cell
'properties of a cell
    cost as integer
    g as integer
    f as integer
    parent as coordinates
end type

sub AddCoordinates(list as listCoordinates, c as coordinates)
'Adds coordinates c to the listCoordinates, checking if it's already present
    dim i as integer, inList as integer = 0
    if (list.length > 0) then
        for i = 1 to list.length
            if (list.coord(i).row = c.row and list.coord(i).col = c.col) then
                inList = i
                exit for
            end if
        next
        if (inList > 0) then
            exit sub
        end if
    end if
    if (list.length < 64) then
        list.length = list.length + 1
        list.coord(list.length).row = c.row
        list.coord(list.length).col = c.col
    end if
end sub

sub RemoveCoordinates(list as listCoordinates, c as coordinates)
'Removes coordinates c from listCoordinates
    dim i as integer, inList as integer = 0
    if (list.length > 0) then
        for i = 1 to list.length
            if (list.coord(i).row = c.row and list.coord(i).col = c.col) then
                inList = i
                exit for
            end if
        next
        if (inList > 0) then
            list.coord(inList).row = list.coord(list.length).row
            list.coord(inList).col = list.coord(list.length).col
            list.length = list.length - 1
        end if
    end if
end sub

function GetOpened(list as listCoordinates, cells() as cell) as coordinates
'Gets the cell between the open ones with the shortest expected cost
    dim i as integer, minf as integer
    dim rv as coordinates
    minf = 1
    if (list.length > 1) then
        for i = 2 to list.length
            if (cells(list.coord(i).row, list.coord(i).col).f < cells(list.coord(minf).row, list.coord(minf).col).f) then
                minf = i
            end if
        next
    end if
    rv.row = list.coord(minf).row
    rv.col = list.coord(minf).col
    return rv
end function

function Heuristic(byval a as coordinates, byval b as coordinates) as integer
'In a chessboard, the shortest path of a king between two cells is the maximum value
'between the orizzontal distance and the vertical one. This could be used as
'heuristic value in the A* algorithm.
    dim dr as integer, dc as integer
    dr = abs(a.row - b.row)
    dc = abs(a.col - b.col)
    if (dr > dc) then
        return dr
    else
        return dc
    end if
end function

function IsACell(r as integer, c as integer) as integer
'It determines if a couple of indeces are inside the chessboard (returns 1) or outside (returns 0)
    dim isCell as integer
    if (r < 0 or r > 7 or c < 0 or c > 7) then
        isCell = 0
    else
        isCell = 1
    end if
    return isCell
end function

sub AppendCell(p as listCoordinates, c as coordinates)
'It appends che coordinates c at the end of the list p
    p.length = p.length + 1
    p.coord(p.length).row = c.row
    p.coord(p.length).col = c.col
end sub

function InList(r as integer, c as integer, p as listCoordinates) as integer
'It determines if the cell with coordinates (r,c) is in the list p
    dim isInPath as integer = 0
    dim i as integer
    for i = 1 to Ubound(p.coord)
        if (p.coord(i).row = r and p.coord(i).col = c) then
            isInPath = 1
            exit for
        end if
    next
    return isInPath
end function

'Variables declaration
'Cost to go to the cell of coordinates (row, column)
dim costs(0 to 7, 0 to 7) as integer => { _
    {1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1}, _
    {1, 1, 1, 1, 100, 100, 100, 1}, {1, 1, 100, 1, 1, 1, 100, 1}, _
    {1, 1, 100, 1, 1, 1, 100, 1}, {1, 1, 100, 100, 100, 100, 100, 1}, _
    {1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1}}
dim start as coordinates, finish as coordinates 'the first and the last cell
dim opened as listCoordinates, closed as listCoordinates
dim aCell as coordinates, nCell as coordinates 'the cell evaluates and the next one
dim cells(0 to 7, 0 to 7) as cell 'the cells of the chessboard
dim path as listCoordinates 'list used to the path found
dim i as integer, j as integer

'MAIN PROCEDURE
'Fixing the starting cell and the finishing one
start.row = 0
start.col = 0
finish.row = 7
finish.col = 7
opened.length = 0
closed.length = 0

'Initializing the chessboard
for i=0 to 7
    for j=0 to 7
        cells(i, j).cost = costs(i, j)
        cells(i, j).g = MAX_DIST
        cells(i, j).f = MAX_DIST
        cells(i, j).parent.row = -1
        cells(i, j).parent.col = -1
    next
next

cells(start.row, start.col).g = 0
cells(start.row, start.col).f = Heuristic(start, finish)
AddCoordinates(opened, start)

do while (opened.length > 0)
    aCell = GetOpened(opened, cells())
    for i = -1 to 1
        for j = -1 to 1
            if ((i <> 0 or j <> 0) and IsACell(aCell.row + i, aCell.col + j)) then
                nCell.row = aCell.row + i
                nCell.col = aCell.col + j
                if (nCell.row = finish.row and nCell.col = finish.col) then
                'The final cell is reached
                    cells(finish.row, finish.col).g = cells(aCell.row, aCell.col).g + cells(finish.row, finish.col).cost
                    cells(finish.row, finish.col).parent.row = aCell.row
                    cells(finish.row, finish.col).parent.col = aCell.col
                    exit do
                end if
                if (InList(nCell.row, nCell.col, opened) = 0 and InList(nCell.row, nCell.col, closed) = 0) then
                'This cell was never visited before
                    cells(nCell.row, nCell.col).g = cells(aCell.row, aCell.col).g + cells(nCell.row, nCell.col).cost
                    cells(nCell.row, nCell.col).f = cells(nCell.row, nCell.col).g + Heuristic(nCell, finish)
                    AddCoordinates(opened, nCell)
                    cells(nCell.row, nCell.col).parent.row = aCell.row
                    cells(nCell.row, nCell.col).parent.col = aCell.col
                else
                'This cell was visited before, it's reopened only if the actual path is shortest of the previous valutation
                    if (cells(aCell.row, aCell.col).g + cells(nCell.row, nCell.col).cost < cells(nCell.row, nCell.col).g) then
                        cells(nCell.row, nCell.col).g = cells(aCell.row, aCell.col).g + cells(nCell.row, nCell.col).cost
                        cells(nCell.row, nCell.col).f = cells(nCell.row, nCell.col).g + Heuristic(nCell, finish)
                        AddCoordinates(opened, nCell)
                        RemoveCoordinates(closed, nCell)
                        cells(nCell.row, nCell.col).parent.row = aCell.row
                        cells(nCell.row, nCell.col).parent.col = aCell.col
                    end if
                end if
            end if
        next
    next
    'The current cell is closed
    AddCoordinates(closed, aCell)
    RemoveCoordinates(opened, aCell)
loop

if (cells(finish.row, finish.col).parent.row >= 0) then
'A possible path was found
    'Add the cells of the shortest path to the list 'path', proceding backward
    path.length = 0
    aCell.row = finish.row
    aCell.col = finish.col
    do while (cells(aCell.row, aCell.col).parent.row >= 0)
        AppendCell(path, aCell)
        nCell.row = cells(aCell.row, aCell.col).parent.row
        aCell.col = cells(aCell.row, aCell.col).parent.col
        aCell.row = nCell.row
    loop

    'Drawing the path
    for i = 0 to 7
        for j = 0 to 7
            if (costs(i,j) > 1) then
                print chr(219);
            elseif (InList(i, j, path)) then
                print "X";
            else
                print ".";
            end if
        next
        print
    next

    'Writing the cells sequence and the path length
    print
    print "Path: "
    for i = path.length to 1 step -1
        print "("; path.coord(i).row; ","; path.coord(i).col; ")";
    next
    print
    print
    print "Path cost: "; cells(finish.row, finish.col).g
    print
else
    print "Path not found"
end if
end
