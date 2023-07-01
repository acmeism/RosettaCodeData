import "dome" for Window, Platform, Process
import "graphics" for Canvas, Color
import "math" for Math, Point
import "random" for Random
import "input" for Keyboard
import "./dynamic" for Struct

var Start  = Platform.time
var Rand   = Random.new()

var fields = [
    "particleNum",
    "positions",
    "velocities",
    "lifetimes",
    "points",
    "numPoints",
    "saturation",
    "spread",
    "range",
    "reciprocate"
]
var ParticleFountain = Struct.create("ParticleFountain", fields)

class ParticleDisplay {
    construct new(particleNum, width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "Wren Particle System!"
        _pn = particleNum
        _w = width
        _h = height
        _df = 1 / 200 // say
        _pf = ParticleFountain.new(
            _pn,                      // particleNum
            List.filled(_pn * 2, 0),  // positions
            List.filled(_pn * 2, 0),  // velocities
            List.filled(_pn, 0),      // lifetimes
            List.filled(_pn, null),   // points
            0,                        // numPoints
            0.4,                      // saturation
            1.5,                      // spread
            1.5,                      // range
            false                     // reciprocate
        )
        for (i in 0..._pn) _pf.points[i] = Point.new(0, 0)
    }

    init() {
        Canvas.cls()
        _frames = 0
    }

    updatePF() {
        var xidx = 0
        var yidx = 1
        var pointIdx = 0
        var recip = Fn.new { _pf.reciprocate ? _pf.range * Math.sin(Platform.time/1000) : 0 }
        for (idx in 0..._pf.particleNum) {
            var willDraw = false
            if (_pf.lifetimes[idx] <= 0) {
                if (Rand.float() < _df) {
                    _pf.lifetimes[idx]  = 2.5       // time to live
                    _pf.positions[xidx] = _w / 20   // starting position x
                    _pf.positions[yidx] = _h / 10   // and y

                     // starting velocities x and y
                     // randomized slightly so points reach different heights
                    _pf.velocities[xidx] = 10 * (_pf.spread * Rand.float() - _pf.spread / 2 + recip.call())
                    _pf.velocities[yidx] = (Rand.float() - 2.9) * _h / 20.5
                    _willDraw = true
                }
            } else {
                if (_pf.positions[yidx] > _h/10 && _pf.velocities[yidx] > 0) {
                    _pf.velocities[yidx] = _pf.velocities[yidx] * (-0.3)   // bounce
                }
                _pf.velocities[yidx] = _pf.velocities[yidx] + _df * _h / 10             // adjust velocity
                _pf.positions[xidx]  = _pf.positions[xidx] + _pf.velocities[xidx] * _df // adjust position x
                _pf.positions[yidx]  = _pf.positions[yidx] + _pf.velocities[yidx] * _df // and y
                _pf.lifetimes[idx]   = _pf.lifetimes[idx] - _df
                willDraw = true
            }
            if (willDraw) {  // gather all the points that are going to be rendered
                _pf.points[pointIdx] = Point.new((_pf.positions[xidx] * 10).floor,
                                                 (_pf.positions[yidx] * 10).floor)
                 pointIdx = pointIdx + 1
            }
            xidx = xidx + 2
            yidx = xidx + 1
            _pf.numPoints = pointIdx
        }
    }

    update() {
        if (Keyboard["Up"].justPressed) {
            _pf.saturation = Math.min(_pf.saturation + 0.1, 1)
        } else if (Keyboard["Down"].justPressed) {
            _pf.saturation = Math.max(_pf.saturation - 0.1, 0)
        } else if (Keyboard["PageUp"].justPressed) {
            _pf.spread = Math.min(_pf.spread + 1, 50)
        } else if (Keyboard["PageDown"].justPressed) {
            _pf.spread = Math.max(_pf.spread - 0.1, 0.2)
        } else if (Keyboard["Left"].justPressed) {
            _pf.range = Math.min(_pf.range + 0.1, 12)
        } else if (Keyboard["Right"].justPressed) {
            _pf.range = Math.max(_pf.range - 0.1, 0.1)
        } else if (Keyboard["Space"].justPressed) {
            _pf.reciprocate = !_pf.reciprocate
        } else if (Keyboard["Q"].justPressed) {
            Process.exit()
        }
        updatePF()
    }

    draw(alpha) {
        var c = Color.hsv((Platform.time % 5) * 72, _pf.saturation, 0.5, 0x7f)
        for (i in 0..._pf.numPoints) {
            Canvas.pset(_pf.points[i].x, _pf.points[i].y, c)
        }
        _frames = _frames + 1
        var now = Platform.time
        if (now - Start >= 1) {
            Start = now
            Window.title = "Wren Particle System!    (FPS = %(_frames))"
            _frames = 0
        }
    }
}

System.print("""

    Use UP and DOWN arrow keys to modify the saturation of the particle colors.
    Use PAGE UP and PAGE DOWN keys to modify the "spread" of the particles.
    Toggle reciprocation off / on with the SPACE bar.
    Use LEFT and RIGHT arrow keys to modify angle range for reciprocation.
    Press the "q" key to quit.
""")

var Game = ParticleDisplay.new(3000, 800, 800)
