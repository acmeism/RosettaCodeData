// Kotlin Native version 0.5

import kotlinx.cinterop.*
import platform.posix.*
import platform.linux.*

typealias Func = (String)-> Int

var handle = 0

fun myOpenImage(s: String): Int {
    fprintf(stderr, "internal openImage opens %s...\n", s)
    return handle++
}

fun main(args: Array<String>) {
    var imgHandle: Int
    val imglib = dlopen("./fakeimglib.so", RTLD_LAZY)
    if (imglib != null) {
        val fp = dlsym(imglib, "openimage")
        if (fp != null) {
            val extOpenImage: CPointer<CFunction<Func>> = fp.reinterpret()
            imgHandle = extOpenImage("fake.img")
        }
        else {
            imgHandle = myOpenImage("fake.img")
        }
        dlclose(imglib)
    }
    else {
        imgHandle = myOpenImage("fake.img")
    }
    println("opened with handle $imgHandle")
}
