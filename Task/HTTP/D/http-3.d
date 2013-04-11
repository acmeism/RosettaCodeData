import tango.io.Console;
import tango.net.InternetAddress;
import tango.net.device.Socket;

void main() {
  auto site = new Socket;
  site.connect (new InternetAddress("google.com",80)).write ("GET / HTTP/1.0\n\n");

  Cout.stream.copy (site);
}
