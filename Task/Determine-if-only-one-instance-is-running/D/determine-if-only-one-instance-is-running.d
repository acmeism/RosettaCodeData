bool is_unique_instance()
{
    import std.socket;
    auto socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
    auto addr = new UnixAddress("\0/tmp/myapp.uniqueness.sock");
    try
    {
        socket.bind(addr);
        return true;
    }
    catch (SocketOSException e)
    {
        import core.stdc.errno : EADDRINUSE;

        if (e.errorCode == EADDRINUSE)
            return false;
        else
            throw e;
    }
}
