import "graphics" for Canvas, Color
import "dome" for Window
import "random" for Random

class Game {
    static init() {
        Window.title = "Voronoi diagram"
        var cells = 70
        var size = 700
        Window.resize(size, size)
        Canvas.resize(size, size)
        voronoi(cells, size)
    }

    static update() {}

    static draw(alpha) {}

    static distSq(x1, x2, y1, y2) { (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) }

    static voronoi(cells, size) {
        var r = Random.new()
        var px = List.filled(cells, 0)
        var py = List.filled(cells, 0)
        var cl = List.filled(cells, 0)
        for (i in 0...cells) {
            px[i] = r.int(size)
            py[i] = r.int(size)
            cl[i] = Color.rgb(r.int(256), r.int(256), r.int(256))
        }
        for (x in 0...size) {
            for (y in 0...size) {
                var n = 0
                for (i in 0...cells) {
                     if (distSq(px[i], x, py[i], y) < distSq(px[n], x, py[n], y)) n = i
                }
                Canvas.pset(x, y, cl[n])
            }
        }
        for (i in 0...cells) {
            Canvas.circlefill(px[i], py[i], 2, Color.black)
        }
    }
}
