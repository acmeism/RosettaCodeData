import tango.text.Arguments;
import tango.io.Stdout;

void main(char[][] realArgs)
{
    auto args = new Arguments;

    args("hello").required.params(1).requires("world");
    args("world").params(1).aliased('w');

    if (! args.parse(realArgs)) {
        Stdout ("bad arguments");

    } else {
        Stdout("argument for --hello ") (args("hello").assigned).newline;
        Stdout("argument for --world ") (args("world").assigned).newline;
    }
}
