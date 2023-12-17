/* Call_a_function_in_a_shared_library.wren */

var RTLD_LAZY = 1

foreign class DL {
    construct open(file, mode) {}

    foreign call(symbol, arg)

    foreign close()
}

class My {
    static openimage(s) {
        System.print("internal openimage opens %(s)...")
        if (!__handle) __handle = 0
        __handle = __handle + 1
        return __handle - 1
    }
}

var file = "fake.img"
var imglib = DL.open("./fakeimglib.so", RTLD_LAZY)
var imghandle = (imglib != null) ? imglib.call("openimage", file) : My.openimage(file)
System.print("opened with handle %(imghandle)")
if (imglib != null) imglib.close()
