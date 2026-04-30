include std\console.e
include std\graphics.e

sequence grid = repeat(repeat(1,100),100) --fill 100 by 100 grid with white (1)
sequence antData = {48, 53, 360} --ant x coordinate, y coordinate, facing angle
integer iterations = 0

--while ant isn't out of bounds of the 100 by 100 area..
while antData[1] > 0 and antData[1] < 100 and antData[2] > 0 and antData[2] < 100 do
    switch grid[antData[1]][antData[2]] do
        case 1 then--cell is already white
            grid[antData[1]][antData[2]] = 0 --cell turns black, ant turns right
            antData[3] += 90
            break
        case 0 then--cell is already black
            grid[antData[1]][antData[2]] = 1 --cell turns white, ant turns left
            antData[3] -= 90
            break
    end switch
    --wrap ant directions if > 360 or < 90 (by 90)
    switch antData[3] do
        case 450 then
            antData[3] = 90
            break
        case 0 then
            antData[3] = 360
            break
    end switch
    --move ant based on its new facing, one square
    --first north, then south, east, west
    switch antData[3] do
        case 360 then
            antData[2] -= 1
            break
        case 180 then
            antData[2] += 1
            break
        case 90 then
            antData[1] += 1
            break
        case 270 then
            antData[1] -= 1
            break
    end switch
iterations += 1
end while

wrap(0) --don't wrap text output, the grid wouldnt display as a square

for y=1 to 100 do
    printf(1,"\n")
    for x=1 to 100 do
        switch grid[x][y] do--each grid block , based on color
            case 0 then
                printf(1,".")
                break
            case 1 then
                printf(1,"#")
                break
        end switch
    end for
end for

printf(1,"\n%d Iterations\n",iterations)
any_key()--wait for keypress, put default message 'press any key..'
