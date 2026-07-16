import "dome" for Window
import "graphics" for Canvas, Color
import "math" for Math

class KleinBottle {
    construct new() {
        Window.title = "Klein Bottle"
        Window.resize(900, 700)
        Canvas.resize(900, 700)
        var clr = Color.rgb(10, 10, 15, 255) // dark navy/black
        Canvas.cls(clr)
    }

    init() {
        drawBottle()
    }

    drawBottle() {
        // Resolution parameters for the true shape.
        var stepsU = 50
        var stepsV = 40

        // 2D arrays to store screen coordinates for drawing grid lines.
        var pointsX = List.filled(stepsU + 1, null)
        var pointsY = List.filled(stepsU + 1, null)
        for (i in 0..stepsU) {
            pointsX[i] = List.filled(stepsV + 1, 0)
            pointsY[i] = List.filled(stepsV + 1, 0)
        }

        // STEP 1: Calculate mathematical points and project them.
        for (u in 0..stepsU) {
            var uVal = (u / stepsU) * 2 * Num.pi  // true range: 0 to 2pi
            for (v in 0..stepsV) {
                var vVal = (v / stepsV) * 2 * Num.pi
                var x
                var z

                // Klein bottle equations (Stewart Dickson / Mathworld formula)
                if (uVal < Num.pi) {
                    x = 6 * Math.cos(uVal) * (1 + Math.sin(uVal)) + 4 * (1 - Math.cos(uVal)/2) * Math.cos(uVal) * Math.cos(vVal)
                    z = 16 * Math.sin(uVal) + 4 * (1 - Math.cos(uVal)/2) * Math.sin(uVal) * Math.cos(vVal)
                } else {
                    x = 6 * Math.cos(uVal) * (1 + Math.sin(uVal)) + 4 * (1 - Math.cos(uVal)/2) * Math.cos(vVal + Num.pi)
                    z = 16 * Math.sin(uVal)
                }
                var y = 4 * (1 - Math.cos(uVal)/2) * Math.sin(vVal)

                // 3D -> 2D Projection (with 30-degree rotation around Y and Z axes for better depth)
                var cosA = Math.cos(Num.pi / 6) // cos 30°
                var sinA = Math.sin(Num.pi / 6) // sin 30°

                // Rotated coordinates.
                var xRot = x * cosA - y * sinA
                var yRot = x * sinA + y * cosA
                var zRot = z

                // Scale and translate to the center of the window (900 x 700).
                var scale = 17
                var screenX = 450 + (xRot - yRot * 0.3) * scale
                var screenY = 400 - (zRot - yRot * 0.2) * scale

                // Save points for wireframe drawing.
                pointsX[u][v] = screenX
                pointsY[u][v] = screenY
            }
        }

        // STEP 2: Connect the 3D wireframe mesh.

        // Color: neon/cyan with slight transparency for depth effect.
        var clr = Color.rgb(0, 229, 255, 120)
        for (u in 0...stepsU) {
            for (v in 0...stepsV) {
                 // Line to adjacent V point (U lines).
                 Canvas.line(pointsX[u][v], pointsY[u][v], pointsX[u][v+1], pointsY[u][v+1], clr)
                 // Line to adjacent V point (U lines).
                 Canvas.line(pointsX[u][v], pointsY[u][v], pointsX[u+1][v], pointsY[u+1][v+1], clr)
            }
        }
    }

    update() {}

    draw(dt) {}
}

var Game = KleinBottle.new()
