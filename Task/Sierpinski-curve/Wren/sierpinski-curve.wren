import "graphics" for Canvas, Color
import "dome" for Window

var PX = 0
var PY = 0
var CX = 0
var CY = 0
var H  = 0

class SierpinskiCurve {
    construct new(width, height, level, back, fore) {
        Window.title = "Sierpinski Curve"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _l = level
        _bc = back
        _fc = fore
    }

    init() {
        Canvas.cls(Color.blue)
        CX = _w /2
        CY = _h
        H  = CX / 2.pow(_l + 1)
        PX = CX - _w/2 + 2*H
        PY = _h - CY + 3*H
        squareCurve(_l)
    }

    lineTo(newX, newY) {
        Canvas.line(PX, PY, PX = newX - _w/2 + H, PY = _h - newY + 2*H, _fc, 2)
        CX = newX
        CY = newY
    }

    lineN() { lineTo(CX, CY - 2*H) }
    lineS() { lineTo(CX, CY + 2*H) }
    lineE() { lineTo(CX + 2*H, CY) }
    lineW() { lineTo(CX - 2*H, CY) }

    lineNW() { lineTo(CX - H, CY - H) }
    lineNE() { lineTo(CX + H, CY - H) }
    lineSE() { lineTo(CX + H, CY + H) }
    lineSW() { lineTo(CX - H, CY + H) }

    sierN(level) {
        if (level == 1) {
            lineNE()
            lineN()
            lineNW()
        } else {
            sierN(level - 1)
            lineNE()
            sierE(level - 1)
            lineN()
            sierW(level - 1)
            lineNW()
            sierN(level - 1)
        }
    }

    sierE(level) {
        if (level == 1) {
            lineSE()
            lineE()
            lineNE()
        } else {
            sierE(level - 1)
            lineSE()
            sierS(level - 1)
            lineE()
            sierN(level - 1)
            lineNE()
            sierE(level - 1)
        }
    }

    sierS(level) {
        if (level == 1) {
            lineSW()
            lineS()
            lineSE()
        } else {
            sierS(level - 1)
            lineSW()
            sierW(level - 1)
            lineS()
            sierE(level - 1)
            lineSE()
            sierS(level - 1)
        }
    }

    sierW(level) {
        if (level == 1) {
            lineNW()
            lineW()
            lineSW()
        } else {
            sierW(level - 1)
            lineNW()
            sierN(level - 1)
            lineW()
            sierS(level - 1)
            lineSW()
            sierW(level - 1)
        }
    }

    squareCurve(level) {
        sierN(level)
        lineNE()
        sierE(level)
        lineSE()
        sierS(level)
        lineSW()
        sierW(level)
        lineNW()
        lineNE() // needed to close the square in the top left hand corner
    }

    update() {}

    draw(alpha) {}
}

var Game = SierpinskiCurve.new(770, 770, 5, Color.blue, Color.yellow)
