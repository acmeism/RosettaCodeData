import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math
import "./dynamic" for Enum, Tuple
import "./set" for Set
import "./polygon" for Polygon

var Type = Enum.create("Type", ["KITE", "DART"])

var Tile = Tuple.create("Tile", ["type", "x", "y", "angle", "size"])

var DistinctTiles = Fn.new { |tiles|
    var tileStr = tiles.map { |t| t.toString }.toList
    var tileSet = Set.new(tileStr)
    var tileDst = []
    for (tile in tiles) {
        var str = tile.toString
        if (tileSet.contains(str)) {
            tileDst.add(tile)
            tileSet.remove(str)
        }
    }
    return tileDst
}

var Radians = Fn.new { |d| d * Num.pi / 180 }

var G = (1 + 5.sqrt) / 2   // golden ratio
var T = Radians.call(36)   // theta

class PenroseTiling {
    construct new(width, height) {
        Window.title = "Penrose Tiling"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
    }

    init() {
        var tiles = deflateTiles_(setupPrototiles_(_w, _h), 5)
        drawTiles(tiles)
    }

    setupPrototiles_(w, h) {
        var proto = []
        var a = Num.pi / 2 + T
        while (a < 3 * Num.pi) {
            proto.add(Tile.new(Type.KITE, w / 2, h / 2, a, w / 2.5))
            a = a + 2 * T
        }
        return proto
    }

    deflateTiles_(tiles, generation) {
        if (generation <= 0) return tiles
        var next = []
        for (tile in tiles) {
            var x = tile.x
            var y = tile.y
            var a = tile.angle
            var nx
            var ny
            var size = tile.size / G
            if (tile.type == Type.DART) {
                next.add(Tile.new(Type.KITE, x, y, a + 5 * T, size))
                var sign = 1
                for (i in 0..1) {
                    nx = x + Math.cos(a - 4 * T * sign) * G * tile.size
                    ny = y - Math.sin(a - 4 * T * sign) * G * tile.size
                    next.add(Tile.new(Type.DART, nx, ny, a - 4 * T * sign, size))
                    sign = -sign
                }
            } else {
                var sign = 1
                for (i in 0..1) {
                    next.add(Tile.new(Type.DART, x, y, a - 4 * T * sign, size))
                    nx = x + Math.cos(a - T * sign) * G * tile.size
                    ny = y - Math.sin(a - T * sign) * G * tile.size
                    next.add(Tile.new(Type.KITE, nx, ny, a + 3 * T * sign, size))
                    sign = -sign
                }
            }
        }
        // remove duplicates and deflate
        return deflateTiles_(DistinctTiles.call(next), generation - 1)
    }

    drawTiles(tiles) {
        var dist = [ [G, G, G], [-G, -1, -G] ]
        for (tile in tiles) {
            var angle = tile.angle - T
            var x0 = tile.x
            var y0 = tile.y
            var ord = tile.type
            var vertices = [[x0, y0]]
            for (i in 0..2) {
                var x1 = tile.x + dist[ord][i] * tile.size * Math.cos(angle)
                var y1 = tile.y - dist[ord][i] * tile.size * Math.sin(angle)
                vertices.add([x1, y1])
                angle = angle + T
                x0 = x1
                y0 = y1
            }
            var poly = Polygon.quick(vertices)
            poly.drawfill((ord == 0) ? Color.orange : Color.yellow)
            poly.draw(Color.darkgray)
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = PenroseTiling.new(700, 450)
