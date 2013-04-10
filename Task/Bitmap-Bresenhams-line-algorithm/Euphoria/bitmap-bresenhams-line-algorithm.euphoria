include std/console.e
include std/graphics.e
include std/math.e

-- the new_image function and related code in the 25 or so
-- lines below are from http://rosettacode.org/wiki/Basic_bitmap_storage#Euphoria
-- as of friday, march 2, 2012

-- Some color constants:
constant
    black = #000000,
    white = #FFFFFF,
    red =   #FF0000,
    green = #00FF00,
    blue =  #0000FF

-- Create new image filled with some color
function new_image(integer width, integer height, atom fill_color)
    return repeat(repeat(fill_color,height),width)
end function

--grid used for drawing lines in this program
sequence screenData = new_image(16,16,black)

--the line algorithm
function bresLine(sequence screenData, integer x0, integer y0, integer x1, integer y1, integer color)

    integer deltaX = abs(x1 - x0), deltaY = abs(y1 - y0)
    integer stepX, stepY, lineError, error2

    if x0 < x1 then
        stepX = 1
        else
        stepX = -1
    end if

    if y0 < y1 then
        stepY = 1
        else
        stepY = -1
    end if

    if deltaX > deltaY then
        lineError = deltaX
        else
        lineError = -deltaY
    end if

    lineError = round(lineError / 2, 1)

    while 1 do

        screenData[x0][y0] = color

        if (x0 = x1 and y0 = y1) then
            exit
        end if

        error2 = lineError

        if error2 > -deltaX then
            lineError -= deltaY
            x0 += stepX
        end if
        if error2 < deltaY then
            lineError += deltaX
            y0 += stepY
        end if
    end while
    return screenData -- return modified version of the screenData sequence
end function

--prevents console output wrapping to next line if it is too big for the screen
wrap(0)
--outer diamond
screenData = bresLine(screenData,8,1,16,8,white)
screenData = bresLine(screenData,16,8,8,16,white)
screenData = bresLine(screenData,8,16,1,8,white)
screenData = bresLine(screenData,1,8,8,1,white)
--inner diamond
screenData = bresLine(screenData,8,4,12,8,white)
screenData = bresLine(screenData,12,8,8,12,white)
screenData = bresLine(screenData,8,12,4,8,white)
screenData = bresLine(screenData,4,8,8,4,white)
-- center lines drawing from left to right, and the next from right to left.
screenData = bresLine(screenData,7,7,9,7,white)
screenData = bresLine(screenData,9,9,7,9,white)
--center dot
screenData = bresLine(screenData,8,8,8,8,white)

--print to the standard console output
for i = 1 to 16 do
    puts(1,"\n")
    for j = 1 to 16 do
            if screenData[j][i] = black then
                printf(1, "%s", ".")
            else
                printf(1, "%s", "#")
            end if
    end for
end for

puts(1,"\n\n")
any_key()

--/*
--output was edited to replace the color's hex digits for clearer output graphics.
--to output all the hex digits, use printf(1,"%06x", screenData[j][i])
--to output 'shortened' hex digits, use :
--printf(1, "%x", ( abs( ( (screenData[j][i] / #FFFFF) - 1 ) ) - 1 ) )
--and
--printf(1,"%x", abs( ( (screenData[j][i] / #FFFFF) - 1 ) ) )
--
--,respectively in the last if check.
--*/
