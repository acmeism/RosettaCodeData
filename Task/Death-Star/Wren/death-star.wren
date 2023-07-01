import "dome" for Window
import "graphics" for Canvas, Color, ImageData
import "math" for Vector

var Normalize = Fn.new{ |vec|
    var invLen = 1 / vec.dot(vec).sqrt
    vec.x = vec.x * invLen
    vec.y = vec.y * invLen
    vec.z = vec.z * invLen
}

class Sphere {
    construct new(cx, cy, cz, r) {
        _cx = cx
        _cy = cy
        _cz = cz
        _r  = r
    }

    cx { _cx }
    cy { _cy }
    cz { _cz }
    r  { _r  }

    hit(x, y) {
        x = x - _cx
        y = y - _cy
        var zsq = _r*_r - x*x - y*y
        if (zsq >= 0) {
            var zsqrt = zsq.sqrt
            return [_cz - zsqrt, _cz + zsqrt, true]
        }
        return [0, 0, false]
    }
}

class DeathStar {
    construct new(width, height) {
        Window.title = "Death star"
        Window.resize(width, height)
        Canvas.resize(width, height)
    }

    init() {
        Canvas.cls(Color.white)
        var dir = Vector.new(20, -40, 10)
        Normalize.call(dir)
        var pos = Sphere.new(220, 190, 220, 120)
        var neg = Sphere.new(130, 100, 190, 100)
        deathStar(pos, neg, 1.5, 0.2, dir)
    }

    deathStar(pos, neg, k, amb, dir) {
        var w = pos.r * 4
        var h = pos.r * 3
        var img = ImageData.create("deathStar", w, h)
        var vec = Vector.new(0, 0, 0)
        for (y in pos.cy - pos.r..pos.cy + pos.r) {
            for (x in pos.cx - pos.r..pos.cx + pos.r) {
                var res = pos.hit(x, y)
                var zb1 = res[0]
                var zb2 = res[1]
                var hit = res[2]
                if (!hit) continue
                res = neg.hit(x, y)
                var zs1 = res[0]
                var zs2 = res[1]
                hit = res[2]
                if (hit) {
                    if (zs1 > zb1) {
                        hit = false
                    } else if (zs2 > zb2) {
                        continue
                    }
                }
                if (hit) {
                    vec.x = neg.cx - x
                    vec.y = neg.cy - y
                    vec.z = neg.cz - zs2
                } else {
                    vec.x = x - pos.cx
                    vec.y = y - pos.cy
                    vec.z = zb1 - pos.cz
                }
                Normalize.call(vec)
                var s = dir.dot(vec)
                if (s < 0) s = 0
                var lum = 255 * (s.pow(k) + amb) / (1 + amb)
                lum = lum.clamp(0, 255)
                img.pset(x, y, Color.rgb(lum, lum, lum))
            }
        }
        img.draw(pos.cx - w/2, pos.cy - h/2)
        img.saveToFile("deathStar.png")
    }

    update() {
    }

    draw(alpha) {
    }
}

var Game = DeathStar.new(400, 400)
