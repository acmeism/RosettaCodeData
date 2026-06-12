import "dome" for Window
import "graphics" for Canvas, Color
import "math" for Math

// Celestial bodies: [Name, Distance, Speed, Size, Current_Angle, Color, ColorName]
var Planets = [
    ["Moon",       70,  0.05,  6,  0, Color.rgb(200, 200, 200), "Light Grey"],
    ["Mercury",   120,  0.03,  5,  0, Color.rgb(150, 150, 150), "Grey"],
    ["Venus",     170,  0.02,  9,  0, Color.rgb(255, 200,   0), "Yellow"],
    ["Sun",       230,  0.015, 18, 0, Color.rgb(255, 150,   0), "Orange"],
    ["Mars",      300,  0.01,  7,  0, Color.rgb(255,  50,   0), "Red"],
    ["Jupiter",   360,  0.007, 15, 0, Color.rgb(200, 150, 100), "Brown"]
]

var Width = 800
var Height = 800

class GeocentricModel {
    construct new() {
        Window.resize(Width, Height)
        Canvas.resize(Width, Height)
        Window.title = "Geocentric Model"
        _back  = Color.rgb(5, 5, 20)
        _orbit = Color.rgb(60, 60, 60)
        Canvas.cls(_back)
        _cx = Width / 2
        _cy = Height / 2
    }

    init() {}

    update() {}

    // Note: DOME calls this method automatically 60 times per second.
    draw(alpha) {
        Canvas.cls(_back)

        // Orbits and planets
        for (p in Planets) {
            p[4] = p[4] + p[2]  // update angle
            Canvas.circle(_cx, _cy, p[1], _orbit)
            var px = _cx + Math.cos(p[4]) * p[1]
            var py = _cy + Math.sin(p[4]) * p[1]
            Canvas.circlefill(px, py, p[3], p[5])
        }
    }
}

// Terminal output: Planet and Color list
System.print("--- Planet Colors ---\n")
for (p in Planets) System.print("%(p[0])\t%(p[6])")
System.print("---------------------")

var Game = GeocentricModel.new()
