import tango.io.device.File;

void main()
{
    auto to = new File("output.txt", File.WriteCreate);
    to.copy(new File("input.txt")).close;
}
