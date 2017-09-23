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

-- Usage example:
sequence image
image = new_image(800,600,black)

-- Set pixel color:
image[400][300] = red

-- Get pixel color
atom color
color = image[400][300] -- Now color is #FF0000
