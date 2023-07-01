import "random" for Random
import "/ioutil" for Input
import "/str" for Str

var Rand = Random.new()

class Mastermind {
    construct new(codeLen, colorsCnt, guessCnt, repeatClr) {
        var color = "ABCDEFGHIJKLMNOPQRST"
        _codeLen = codeLen.clamp(4, 10)
        var cl = colorsCnt
        if (!repeatClr && cl < _codeLen) cl = _codeLen
        _colorsCnt = cl.clamp(2, 20)
        _guessCnt = guessCnt.clamp(7, 20)
        _repeatClr = repeatClr
        _colors = color.take(_colorsCnt).join()
        _combo = ""
        _guesses = []
        _results = []
    }

    play() {
        var win = false
        _combo = getCombo_()
        while (_guessCnt != 0) {
            showBoard_()
            if (checkInput_(getInput_())) {
                win = true
                break
            }
            _guessCnt = _guessCnt - 1
        }
        System.print("\n\n--------------------------------")
        if (win) {
            System.print("Very well done!\nYou found the code: %(_combo)")
        } else {
            System.print("I am sorry, you couldn't make it!\nThe code was: %(_combo)")
        }
        System.print("--------------------------------\n")
    }

    showBoard_() {
        for (x in 0..._guesses.count) {
            System.print("\n--------------------------------")
            System.write("%(x + 1): ")
            for (y in _guesses[x]) System.write("%(y) ")
            System.write(" :  ")
            for (y in _results[x]) System.write("%(y) ")
            var z = _codeLen - _results[x].count
            if (z > 0) System.write("- " * z)
        }
        System.print("\n")
    }

    getInput_() {
        while (true) {
            var a = Str.upper(Input.text("Enter your guess (%(_colors)): ", 1)).take(_codeLen)
            if (a.all { |c| _colors.contains(c) } ) return a.join()
        }
    }

    checkInput_(a) {
        _guesses.add(a.toList)
        var black = 0
        var white = 0
        var gmatch = List.filled(_codeLen, false)
        var cmatch = List.filled(_codeLen, false)
        for (i in 0..._codeLen) {
            if (a[i] == _combo[i]) {
                gmatch[i] = true
                cmatch[i] = true
                black = black + 1
            }
        }
        for (i in 0..._codeLen) {
            if (gmatch[i]) continue
            for (j in 0..._codeLen) {
                if (i == j || cmatch[j]) continue
                if (a[i] == _combo[j]) {
                    cmatch[j] = true
                    white = white + 1
                    break
                }
            }
        }
        var r = []
        r.addAll(("X" * black).toList)
        r.addAll(("O" * white).toList)
        _results.add(r)
        return black == _codeLen
    }

    getCombo_() {
        var c =  ""
        var clr = _colors
        for (s in 0..._codeLen) {
            var z = Rand.int(clr.count)
            c = c + clr[z]
            if (!_repeatClr) Str.delete(clr, z)
        }
        return c
    }
}

var m = Mastermind.new(4, 8, 12, false)
m.play()
