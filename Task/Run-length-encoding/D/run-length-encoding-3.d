import std.stdio, std.conv, std.utf, std.array;
import vlq;

struct RLE { // for utf string
    ubyte[] encoded;

    RLE encode(const string s) {
        validate(s); // check if s is well-formed utf, throw if not
        encoded.length = 0; // reset
        if (s.length == 0) return this; // empty string
        string last;
        VLQ count;
        for (int i = 0; i < s.length; ) {
            auto k = s.stride(i);
            auto ucode = cast(string)s[i .. i + k];
            if (i == 0) last = ucode;
            if (ucode == last)
                count++;
            else {
                encoded ~= count.toVLQ ~ cast(ubyte[])last;
                last = ucode;
                count = 1;
            }
            i += k;
        }
        encoded ~= VLQ(count).toVLQ ~ cast(ubyte[])last;
        return this;
    }

    int opApply(int delegate(ref ulong c, ref string u) dg) {
        VLQ count;
        string ucode;

        for (int i = 0; i < encoded.length; ) {
            auto k = count.extract(encoded[i .. $]);
            i += k;
            if (i >= encoded.length)
                throw new Exception("not valid encoded string");
            k = stride(cast(string) encoded[i .. $], 0);
            if (k == 0xff) // not valid utf code point
                throw new Exception("not valid encoded string");
            ucode = cast(string)encoded[i .. i + k].dup;
            dg(count.value, ucode);
            i += k;
        }

        return 0;
    }

    string toString() {
        string res;
        foreach (ref i, s ; this)
            if (indexOf("0123456789#", s) == -1)
                res ~= text(i) ~ s;
            else
                res ~= text(i) ~ '#' ~ s;
        return res;
    }

    string decode() {
        string res;
        foreach (ref i, s; this)
            res ~= replicate(s, cast(uint)i);
        return res;
    }
}

void main() {
    RLE r;
    auto s = "尋尋覓覓冷冷清清淒淒慘慘戚戚\nWWWWWWWWWWWWBWWWWWWWWWWW" ~
             "WBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW\n" ~
             "11#222##333";
    auto f = File("display.txt", "w");
    f.writeln(s);
    r.encode(s);
    f.writefln("-----\n%s\n-----\n%s", r, r.decode());
    auto sEncoded = RLE.init.encode(s).encoded ;
    assert(s == RLE(sEncoded).decode(), "Not work");
}
