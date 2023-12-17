/* FTP.wren */

var FTPLIB_CONNMODE = 1
var FTPLIB_PASSIVE  = 1
var FTPLIB_ASCII    = 65 // 'A'

foreign class Ftp {
    foreign static init()

    construct connect(host) {}

    foreign login(user, pass)

    foreign options(opt, val)

    foreign chdir(path)

    foreign dir(outputFile, path)

    foreign get(output, path, mode)

    foreign quit()
}

Ftp.init()
var ftp = Ftp.connect("ftp.easynet.fr")
ftp.login("anonymous", "ftptest@example.com")
ftp.options(FTPLIB_CONNMODE, FTPLIB_PASSIVE)
ftp.chdir("/debian/")
ftp.dir("", ".")
ftp.get("ftp.README", "README", FTPLIB_ASCII)
ftp.quit()
