import "dome" for Window
import "graphics" for Canvas, Color, Font
import "./plot" for Axes
import "./big" for BigRat
import "./iterate" for Stepped

var s = """
960 939 379 918 958 884 971 672 962 127 852 754 715 004 339 660 129 306 651 505
519 271 702 802 395 266 424 689 642 842 174 350 718 121 267 153 782 770 623 355
993 237 280 874 144 307 891 325 963 941 337 723 487 857 735 749 823 926 629 715
517 173 716 995 165 232 890 538 221 612 403 238 855 866 184 013 235 585 136 048
828 693 337 902 491 454 229 288 667 081 096 184 496 091 705 183 454 067 827 731
551 705 405 381 627 380 967 602 565 625 016 981 482 083 418 783 163 849 115 590
225 610 003 652 351 370 343 874 461 848 378 737 238 198 224 849 863 465 033 159
410 054 974 700 593 138 339 226 497 249 461 751 545 728 366 702 369 745 461 014
655 997 933 798 537 483 143 786 841 806 593 422 227 898 388 722 980 000 748 404
719
"""

s = s.replace(" ", "").replace("\n", "").replace("\r", "")
var k = BigRat.new(s)

var Pts = []
for (j in 0..16) {
    var y = k + j
    var t1 = (y/17).floor
    var t2 = (y % 17).toInt
    for (x in 0..106) {
        var t3 = BigRat.two.pow(-17 * x - t2)
        if (BigRat.half < ((t1 * t3) % 2).floor) {
            Pts.add([106-x, 16-j])
            System.print([j, x]) // to show progress on terminal
        }
    }
}

class Main {
    construct new() {
        Window.title = "Tupper's self-referential formula"
        Canvas.resize(840, 260)
        Window.resize(840, 260)
        Canvas.cls(Color.white)
        Font.load("Go-Regular9", "Go-Regular.ttf", 9)
        Canvas.font = "Go-Regular9"
        var axes = Axes.new(100, 200, 660, 180, -10..110, -1..17)
        axes.draw(Color.black, 2)
        var xMarks = Stepped.new(-10..110, 10)
        var yMarks = Stepped.new(-1..17, 2)
        axes.mark(xMarks, yMarks, Color.black, 2)
        axes.label(xMarks, yMarks, Color.black, 2, Color.black)
        axes.plot(Pts, Color.black, "█") // uses character 0x2588
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
