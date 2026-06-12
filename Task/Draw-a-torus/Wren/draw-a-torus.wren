import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

class Game {
    static init() {
        Window.title = "Torus"
        Window.resize(800, 600)
        Canvas.resize(800, 600)
        var clr = Color.rgb(10, 10, 15, 255)
        Canvas.cls(clr)
        drawTorus()
    }

    static drawTorus() {
        var R = 150  // outer radius
        var r = 60   // inner radius (tube radius)

        // Rotation angles (in radians).
        var A = 0.5  // tilt around X axis
        var B = 0.5  // tilt around Z axis

        var sinA = Math.sin(A)
        var cosA = Math.cos(A)
        var sinB = Math.sin(B)
        var cosB = Math.cos(B)

        for (jj in 0..628) {   // ring circumference (theta)
            var j = jj / 100
            var ii = 0
            while (ii < 628) { // tube circumference (phi)
                var i = ii / 100
                var sini = Math.sin(i)
                var cosi = Math.cos(i)
                var sinj = Math.sin(j)
                var cosj = Math.cos(j)

                // 3D coordinate calculation.
                var h = R + r * cosj
                var x = h * (cosB * cosi + sinA * sinB * sini) - r * cosA * sinB * sinj
                var y = h * (sinB * cosi - sinA * cosB * sini) + r * cosA * cosB * sinj
                var z = h * cosA * sini + r * sinA * sinj

                // Luminance calculation (dot product with light source).
                // Light source is coming from top-front.
                var tmp = cosj * cosi * sinB - sinA * cosj * sini * cosB - cosA * sinj * cosB
                var lum = 8 * (tmp - cosi * sinj * sinA)

                if (lum > 0) {
                    // Set color based on brightness (0-255).
                    var bright = Math.floor(lum * 30)
                    if (bright > 255) bright = 255
                    var clr = Color.rgb(Math.floor(bright / 2), bright, 255, 255)

                    // Perspective projection to 2D.
                    var ooz = 1 / (z + 500)   // depth feeling
                    var xp = 400 + x * ooz * 600
                    var yp = 300 - y * ooz * 600

                    Canvas.pset(xp, yp, clr)
                }
                ii = ii + 4
            }
        }
    }

    static update() {}

    static draw(alpha) {}
}
