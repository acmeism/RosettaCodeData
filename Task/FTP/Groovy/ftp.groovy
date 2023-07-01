@Grab(group='commons-net', module='commons-net', version='2.0')
import org.apache.commons.net.ftp.FTPClient

println("About to connect....");
new FTPClient().with {
    connect "ftp.easynet.fr"
    enterLocalPassiveMode()
    login "anonymous", "ftptest@example.com"
    changeWorkingDirectory "/debian/"
    def incomingFile = new File("README.html")
    incomingFile.withOutputStream { ostream -> retrieveFile "README.html", ostream }
    disconnect()
}
println("                      ...Done.");
