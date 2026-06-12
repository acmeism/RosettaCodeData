class Sgr {
    // capitalize the initial letter for bright colors
    static init_() {
        __cm = { "black": 30, "red"    : 31, "green": 32, "yellow": 33,
                 "blue" : 34, "magenta": 35, "cyan" : 36, "white" : 37,
                 "Black": 90, "Red"    : 91, "Green": 92, "Yellow": 93,
                 "Blue" : 94, "Magenta": 95, "Cyan" : 96, "White" : 97,
                 "gray" : 90, "Gray"   : 90
               }
    }

    static c(fore, back, text) {  // colorize
         if (!__cm) init_()
         var fcn = __cm[fore]
         if (!fcn) Fiber.abort("Invalid foreground color.")
         var bcn = __cm[back]
         if (!bcn) Fiber.abort("Invalid background color.")
         if (!(text is String)) text = text.toString
         var reset = "\e[39;49m"
         return "\e[%(fcn);%(bcn+10)m%(text)%(reset)"
    }


    static b(text) { "\e[1m%(text)\e[22m" }  // bold

    static f(text) { "\e[2m%(text)\e[22m" }  // faint

    static i(text) { "\e[3m%(text)\e[23m" }  // italic

    static u(text) { "\e[4m%(text)\e[24m" }  // underline

    static w(text) { "\e[5m%(text)\e[25m" }  // wink (or blink)

    static r(text) { "\e[7m%(text)\e[27m" }  // reverse video

    static s(text) { "\e[9m%(text)\e[29m" }  // strike out

    static o(text) { "\e[53m%(text)\e[55m" } // overline

}

System.print("%(Sgr.c("red", "green", "This")) is a color %(Sgr.c("yellow", "blue", "test")).")
System.print("\nOther effects:")
var effects = [
    Sgr.b("Bold"), Sgr.f("Faint"), Sgr.i("Italic"), Sgr.u("Underline"),
    Sgr.w("Wink"), Sgr.r("Reverse"), Sgr.s("Strike"), Sgr.o("Overline")
]
System.print(effects.join(", "))
