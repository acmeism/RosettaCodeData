#include <ftplib.h>

int main(void)
{
    netbuf *nbuf;

    FtpInit();
    FtpConnect("kernel.org", &nbuf);
    FtpLogin("anonymous", "", nbuf);
    FtpOptions(FTPLIB_CONNMODE, FTPLIB_PASSIVE, nbuf);
    FtpChdir("pub/linux/kernel", nbuf);
    FtpDir((void*)0, ".", nbuf);
    FtpGet("ftp.README", "README", FTPLIB_ASCII, nbuf);
    FtpQuit(nbuf);

    return 0;
}
