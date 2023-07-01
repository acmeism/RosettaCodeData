class Record {
    private const string account;
    private const string password;
    private const int uid;
    private const int gid;
    private const string[] gecos;
    private const string directory;
    private const string shell;

    public this(string account, string password, int uid, int gid, string[] gecos, string directory, string shell) {
        import std.exception;
        this.account = enforce(account);
        this.password = enforce(password);
        this.uid = uid;
        this.gid = gid;
        this.gecos = enforce(gecos);
        this.directory = enforce(directory);
        this.shell = enforce(shell);
    }

    public void toString(scope void delegate(const(char)[]) sink) const {
        import std.conv   : toTextRange;
        import std.format : formattedWrite;
        import std.range  : put;

        sink(account);
        put(sink, ':');
        sink(password);
        put(sink, ':');
        toTextRange(uid, sink);
        put(sink, ':');
        toTextRange(gid, sink);
        put(sink, ':');
        formattedWrite(sink, "%-(%s,%)", gecos);
        put(sink, ':');
        sink(directory);
        put(sink, ':');
        sink(shell);
    }
}

public Record parse(string text) {
    import std.array  : split;
    import std.conv   : to;
    import std.string : chomp;

    string[] tokens = text.chomp.split(':');
    return new Record(
            tokens[0],
            tokens[1],
            to!int(tokens[2]),
            to!int(tokens[3]),
            tokens[4].split(','),
            tokens[5],
            tokens[6]);
}

void main() {
    import std.algorithm : map;
    import std.file      : exists, mkdir;
    import std.stdio;

    auto rawData = [
        "jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash",
        "jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash",
        "xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash"
    ];

    auto records = rawData.map!parse;

    if (!exists("_rosetta")) {
        mkdir("_rosetta");
    }

    auto passwd = File("_rosetta/.passwd", "w");
    passwd.lock();
    passwd.writeln(records[0]);
    passwd.writeln(records[1]);
    passwd.unlock();
    passwd.close();

    passwd.open("_rosetta/.passwd", "a");
    passwd.lock();
    passwd.writeln(records[2]);
    passwd.unlock();
    passwd.close();

    passwd.open("_rosetta/.passwd");
    foreach(string line; passwd.lines()) {
        parse(line).writeln();
    }
    passwd.close();
}
