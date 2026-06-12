using Random
using Raylib
using StaticArrays

# Define color palette
const palette = [
    Raylib.BLUE,
    Raylib.GREEN,
    Raylib.RED,
    Raylib.SKYBLUE,
    Raylib.MAGENTA,
    Raylib.GRAY,
    Raylib.LIME,
    Raylib.PURPLE,
    Raylib.VIOLET,
    Raylib.PINK,
    Raylib.GOLD,
    Raylib.ORANGE,
    Raylib.MAROON,
    Raylib.BEIGE,
    Raylib.BROWN,
    Raylib.RAYWHITE
]

# Constants
const screenWidth = Int32(960)
const screenHeight = Int32(840)
const radius = screenHeight ÷ 14
const fontSize = 2 * radius ÷ 5
const angle = π / 6
const incr = 2 * angle
const blank = Ref{Int}(15)  # Using Ref for mutable global
const moves = Ref{Int}(0)
const gameover = Ref{Bool}(false)

# Arrays
const centers = Vector{SVector{2}}(undef, 16)
const cubes = Vector{Int}(0:15)  # Initialized with 0 to 15


function drawcube(n::Int, pos::Int)
    """ Draw a single cube numbered n at position pos """
    r = Float32(radius)
    Raylib.DrawPoly(centers[pos+1], 6, r, 0, palette[n+1])
    cx, cy = centers[pos+1].x, centers[pos+1].y
    for i in 1:2:5
        fi = Float64(i)
        vx = Int32(round(r * cos(angle + fi * incr) + cx))
        vy = Int32(round(r * sin(angle + fi * incr) + cy))
        Raylib.DrawLine(Int32(round(cx)), Int32(round(cy)), vx, vy, Raylib.BLACK)
    end
    ns = (n < 15 || gameover[]) ? string(n + 1) : ""
    hr, er, tqr = r / 2, r / 8, 0.75 * r
    Raylib.DrawText(ns, Int32(round(cx + hr - er)), Int32(round(cy)), fontSize, Raylib.RAYWHITE)
    Raylib.DrawText(ns, Int32(round(cx - hr - er)), Int32(round(cy)), fontSize, Raylib.RAYWHITE)
    Raylib.DrawText(ns, Int32(round(cx - er)), Int32(round(cy - tqr)), fontSize, Raylib.RAYWHITE)
end

function update()
    """ Update game state based on keyboard input """
    gameover[] && return  # If game is over, stop taking moves
    if Raylib.IsKeyPressed(Int32(Raylib.KEY_LEFT))
        if blank[] % 4 != 0
            cubes[blank[]+1], cubes[blank[]] = cubes[blank[]], cubes[blank[]+1]
            blank[] -= 1
            moves[] += 1
        end
    elseif Raylib.IsKeyPressed(Int32(Raylib.KEY_RIGHT))
        if (blank[] + 1) % 4 != 0
            cubes[blank[]+1], cubes[blank[]+2] = cubes[blank[]+2], cubes[blank[]+1]
            blank[] += 1
            moves[] += 1
        end
    elseif Raylib.IsKeyPressed(Int32(Raylib.KEY_UP))
        if blank[] > 3
            cubes[blank[]+1], cubes[blank[]-3] = cubes[blank[]-3], cubes[blank[]+1]
            blank[] -= 4
            moves[] += 1
        end
    elseif Raylib.IsKeyPressed(Int32(Raylib.KEY_DOWN))
        if blank[] < 12
            cubes[blank[]+1], cubes[blank[]+5] = cubes[blank[]+5], cubes[blank[]+1]
            blank[] += 4
            moves[] += 1
        end
    end
end


function completed()
    """ returns true if puzzle is completed """
    for i in 1:16
        cubes[i] != i - 1 && return false
    end
    palette[16] = Raylib.DARKGREEN
    gameover[] = true
    return true
end

function puzzle3dcubes()
    """ Main function to run the '15-puzzle' game using 3D drawn cubes """
    # Initialize cubes
    for i in 1:16
        cubes[i] = i - 1
    end
    shuffle!(view(cubes, 1:15))  # Shuffle first 15 elements
    Raylib.InitWindow(screenWidth, screenHeight, "15-puzzle game using 3D cubes")
    Raylib.SetTargetFPS(60)

    x, y = Float32(screenWidth) / 10, Float32(radius)
    for i in 0:3
        cx = 2 * x * (i + 1)
        for j in 0:3
            cy = (x + y) * (j + 1)
            centers[j*4 + i + 1] = SVector{2}([cx, cy])
        end
    end

    while !Raylib.WindowShouldClose()
        Raylib.BeginDrawing()
        Raylib.ClearBackground(Raylib.BLACK)
        for i in 0:15
            drawcube(cubes[i+1], i)
        end

        if !completed()
            m = "Moves = $(moves[])"
            Raylib.DrawText(m, Int32(4 * x), Int32(13 * y), fontSize, Raylib.RAYWHITE)
        else
            m = "You've completed the puzzle in $(moves[]) moves!"
            Raylib.DrawText(m, Int32(3 * x), Int32(13 * y), fontSize, Raylib.RAYWHITE)
        end
        Raylib.EndDrawing()
        update()
    end

    Raylib.CloseWindow()
end

# Run the game
puzzle3dcubes()
