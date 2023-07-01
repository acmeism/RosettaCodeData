void main()
{
    if(Stdio.Terminfo.is_tty())
	write("Input comes from tty.\n");
    else
        write("Input doesn't come from tty.\n");
}
