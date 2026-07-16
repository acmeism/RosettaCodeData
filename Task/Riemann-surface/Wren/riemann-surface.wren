import "dome" for Window
import "graphics" for Canvas, Color
import "math" for Math

// Global variables for rotation and scaling.
var AngleY = 0.5
var AngleX = 0.6
var Scale  = 160
var Width  = 800
var Height = 600

class RiemannSurface {
    construct new() {
        Window.title = "Riemann Surface"
        Window.resize(Width, Height)
        Canvas.resize(Width, Height)
        Canvas.cls(Color.white)
    }

    init() {
        drawSurface()
    }

    drawSurface() {
        var rSteps = 15
        var tSteps = 70

        // Calculation and projection of mathematical surface points.
        for (rIdx in 1..rSteps) {
            var r = rIdx / rSteps * 1.8
            for (tIdx in 1..tSteps) {
                var theta = (tIdx / tSteps) * 4 * Num.pi

                // Equation of a Riemann surface: f(z) = sqrt(z).
                var x = r * Math.cos(theta)
                var y = r * Math.sin(theta)
                var z = r.sqrt * Math.cos(theta / 2)

                // 3-D rotation around the y-axis.
                var x1 = x * Math.cos(AngleY) - z * Math.sin(AngleX)
                var z1 = x * Math.sin(AngleY) + z * Math.cos(AngleX)

                // 3-D rotation around the x-axis.
                var y1 = y * Math.cos(AngleX) - z1 * Math.sin(AngleX)

                // Orthographic projection onto the 2-D screen.
                var screenX = Width  / 2 + x1 * Scale
                var screenY = Height / 2 - y1 * Scale

                // Coloring based on height (Z)
                // (Dark blue–purple–dark red transition against a white background).
                var colorVal = Math.floor((z + 1.4) * 85)
                colorVal = Math.clamp(colorVal, 0, 255)

                // Stronger colors so they stand out clearly against the white background.
                var clr = Color.rgb(colorVal, 20, 255 - colorVal, 255)

                // Slightly thicker dots for better visibility.
                var radius = 2
                Canvas.circlefill(screenX, screenY, radius, clr)
            }
        }
    }

    update() {
        // Increasing the angle for the next frame of the rotation
        AngleY = AngleY + 0.02
    }

    draw(dt) {
        Canvas.cls(Color.white)
        drawSurface()
    }
}

var Game = RiemannSurface.new()
