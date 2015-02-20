import tango.io.device.File;

void main()
{
    auto from = new File("input.txt");
    auto to = new File("output.txt", File.WriteCreate);
    to.copy(from).close;
    from.close;
}
