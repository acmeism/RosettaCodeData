// Kotlin Native v0.6.2

import kotlinx.cinterop.*
import platform.posix.*

fun talk(s: String) {
    val pid = fork()
    if (pid < 0) {
       perror("fork")
       exit(1)
    }
    if (pid == 0) {
       execlp("espeak", "espeak", s, null)
       perror("espeak")
       _exit(1)
    }
    memScoped {
        val status = alloc<IntVar>()
        waitpid(pid, status.ptr, 0)
        if (status.value > 0) println("Exit status was ${status.value}")
    }
}

fun main(args: Array<String>) {
    talk("This is an example of speech synthesis.")
}
