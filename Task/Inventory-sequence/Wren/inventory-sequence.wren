import "dome" for Window
import "graphics" for Canvas, Color
import "./plot" for Axes
import "./iterate" for Stepped
import "./fmt" for Fmt

var max = 10000
var inv = [0]
var counts = List.filled(max + 100, 0) // say
counts[0] = 1
var lower = 100
var upper = 1000
var done = false
var ix = 0
while (!done) {
    var i = 0
    while(true) {
        var j = counts[i]
        if (inv.count < max) inv.add(j)
        counts[j] = counts[j] + 1
        ix = ix + 1
        if (inv.count >= lower) {
            System.print("Inventory sequence, first 100 elements:")
            Fmt.tprint("$2d", inv[0..99], 20)
            System.print()
            lower = max + 1
        }
        if (j == 0) break
        if (j >= upper) {
            Fmt.print("First element >= $,6d is $,6d at index $,7d", upper, j, ix)
            if (j >= max) {
                done = true
                break
            }
            upper = upper + 1000
        }
        i = i + 1
    }
}

// generate points for the plot
var Pts = (0...max).map { |i| [i, inv[i]] }.toList

class Main {
    construct new() {
        Window.title = "Inventory sequence - first 10,000 elements."
        Canvas.resize(1000, 600)
        Window.resize(1000, 600)
        Canvas.cls(Color.white)
        var axes = Axes.new(100, 500, 800, 400, 0..10000, 0..450)
        axes.draw(Color.black, 2)
        var xMarks = Stepped.new(0..10000, 500)
        var yMarks = Stepped.new(0..400, 50)
        axes.mark(xMarks, yMarks, Color.black, 2)
        var xMarks2 = Stepped.new(0..10000, 1000)
        var yMarks2 = Stepped.new(0..400, 100)
        axes.label(xMarks2, yMarks2, Color.black, 2, Color.black)
        axes.lineGraph(Pts, Color.blue, 2)
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
