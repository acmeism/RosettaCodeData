import tango.io.Console;
import tango.net.http.HttpGet;

void main() {
  Cout.stream.copy( (new HttpGet("http://google.com")).open );
}
