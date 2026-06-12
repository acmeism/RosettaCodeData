int main(int argc, array argv)
{
    if (sizeof(argv)>1 && argv[1] == "daemon")
    {
        Stdio.File newout = Stdio.File("foo", "wc");
        Process.spawn_pike(({ __FILE__ }), ([ "stdout":newout ]));
        return 1;
    }

    int i = 100;
    while(i--)
    {
        write(i+"\n");
        sleep(0.1);
    }
}
