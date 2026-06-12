import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

class Game {
    static init() {
        Window.title = "Möbius strip"
        Window.resize(600, 600)
        Canvas.resize(600, 600)
        Canvas.cls(Color.black)
        drawMobius()
    }

   static drawMobius() {
        var radius = 150
        var halfWidth = 60

        var u = 0
        while (u < 360) {
            var radU = u * Num.pi / 180

            // Inner edge point.
            var v1 = -halfWidth
            var x1 = (radius + v1 * Math.cos(radU / 2)) * Math.cos(radU)
            var y1 = (radius + v1 * Math.cos(radU / 2)) * Math.sin(radU)
            var z1 = v1 * Math.sin(radU / 2)
            var px1 = Math.round(300 + x1 + (z1 * 0.3))
            var py1 = Math.round(300 + y1 - (z1 * 0.3))

            // Outer edge point.
            var v2 = halfWidth
            var x2 = (radius + v2 * Math.cos(radU / 2)) * Math.cos(radU)
            var y2 = (radius + v2 * Math.cos(radU / 2)) * Math.sin(radU)
            var z2 = v2 * Math.sin(radU / 2)
            var px2 = Math.round(300 + x2 + (z2 * 0.3))
            var py2 = Math.round(300 + y2 - (z2 * 0.3))

            // Draw a red line between the two edges.
            Canvas.line(px1, py1, px2, py2, Color.red)
            u = u + 2
        }
    }

    static update() {}

    static draw(alpha) {}
}
