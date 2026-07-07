using Luxor

"""
    Draw a 3D representation of a Rubik's cube with colored squares.
    The cube is drawn in a 3D perspective, with each face represented by a square.
    The colors of the squares can be customized to represent different states of the cube.
    The squares are set up as scrambled. Squares on the front face are colored red,
    green, and blue, squares on the right face are colored orange, white and blue, and
    squares on the top face are colored yellow, orange, and white.
"""
function drawrubikscube()
    Drawing(400, 400, "rubiks_cube.png")
    origin()
    background("white")
    setline(2) # outline width for the cube edges
    s   = 40   # cell size in pixels
    skx = 20   # horizontal skew per depth step
    sky = -12  # vertical skew per depth step (negative = upward on screen)
    fx, fy = -90, 78  # Bottom-left corner of the front face, chosen to center cube in the drawing

    # Color tables — [visual row, visual col] for front/right, [depth row, col] for top
    frontcolors = [
        "red"   "red"   "green";
        "red"   "blue"  "green";
        "blue"  "blue"  "green"
    ]
    topcolors = [
        "yellow" "orange" "white";
        "yellow" "orange" "white";
        "yellow" "orange" "white"
    ]
    rightcolors = [
        "orange" "orange" "orange";
        "white"  "white"  "white";
        "blue"   "blue"   "blue"
    ]
    # Helper function fills polygon with given color and outlines it in black
    function drawcell(corners, color)
        sethue(color)
        poly(corners, :fill, close=true)
        sethue("black")
        poly(corners, :stroke, close=true)
    end
    # Front face
    for j in 0:2, i in 0:2
        x = fx + i * s
        y = fy - (3 - j) * s
        corners = [Point(x, y), Point(x+s, y), Point(x+s, y+s), Point(x, y+s)]
        drawcell(corners, frontcolors[j+1, i+1])
    end
    # Top face
    for k in 0:2, i in 0:2
        x0 = fx + i*s + k*skx
        y0 = (fy - 3*s) + k*sky
        corners = [
            Point(x0,           y0),
            Point(x0 + s,       y0),
            Point(x0 + s + skx, y0 + sky),
            Point(x0 + skx,     y0 + sky)
        ]
        drawcell(corners, topcolors[k+1, i+1])
    end
    # Right face
    for k in 0:2, j in 0:2
        x0 = fx + 3*s + k*skx
        y0 = fy - (3 - j)*s + k*sky
        corners = [
            Point(x0,        y0),
            Point(x0 + skx,  y0 + sky),
            Point(x0 + skx,  y0 + sky + s),
            Point(x0,        y0 + s)
        ]
        drawcell(corners, rightcolors[j+1, k+1])
    end

    finish()
end

drawrubikscube()
