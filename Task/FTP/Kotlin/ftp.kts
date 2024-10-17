// Kotlin Native v0.6

import kotlinx.cinterop.*
import ftplib.*

fun main(args: Array<String>) {
    val nbuf = nativeHeap.allocPointerTo<netbuf>()
    FtpInit()
    FtpConnect("ftp.easynet.fr", nbuf.ptr)
    val vnbuf = nbuf.value
    FtpLogin("anonymous", "ftptest@example.com", vnbuf)
    FtpOptions(FTPLIB_CONNMODE, FTPLIB_PASSIVE.toLong(), vnbuf)
    FtpChdir("/debian/", vnbuf)
    FtpDir(null, ".", vnbuf)
    FtpGet("ftp.README", "README.html", FTPLIB_ASCII.toByte(), vnbuf)
    FtpQuit(vnbuf)
    nativeHeap.free(nbuf)
}
