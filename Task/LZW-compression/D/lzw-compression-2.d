import std.array: empty;

struct LZW {
    // T is ubyte instead of char because D strings are UTF-8.
    alias T = ubyte;
    alias Tcomp = ushort;
    static assert(Tcomp.sizeof > 1);
    alias Ta = immutable(T)[];

    enum int initDictSize = 256;
    static immutable ubyte[initDictSize] bytes;
    static this() {
        foreach (immutable i; 0 .. initDictSize)
            bytes[i] = cast(T)i;
    }

    //static Tcomp[] compress(in T[] original)
    static Tcomp[] compress(immutable scope T[] original)
    /*pure nothrow*/ out(result) {
        if (!original.empty)
            assert(result[0] < initDictSize);
    } body {
        if (original.empty)
            return [];
        Tcomp[Ta] dict;
        foreach (immutable b; bytes)
            dict[[b]] = b;

        // In this algorithm regular slices give lower efficiency.
        struct Slice {
            size_t start, end;
            @property opSlice() const pure nothrow {
                return original[start .. end];
            }
            alias opSlice this;
        }

        Slice w;
        Tcomp[] result;
        foreach (immutable i; 0 .. original.length) {
            auto wc = Slice(w.start, w.end + 1);
            if (wc in dict) {
                w = wc;
            } else {
                result ~= dict[w];
                // AA.length is not pure nor nothrow.
                //assert(dict.length <= Tcomp.max);
                //dict[wc] = cast(Tcomp)dict.length;
                assert(dict.length < Tcomp.max); // Overflow guard.
                dict[wc] = cast(Tcomp)(dict.length - 1);
                w = Slice(i, i + 1);
            }
        }

        if (!w.empty)
            result ~= dict[w];
        return result;
    }

    static Ta decompress(in Tcomp[] compressed) pure
    in {
        if (!compressed.empty)
            assert(compressed[0] < initDictSize, "Bad compressed");
    } body {
        if (compressed.empty)
            return [];

        auto dict = new Ta[initDictSize];
        foreach (immutable b; bytes)
            dict[b] = [b];

        auto w = dict[compressed[0]];
        auto result = w;
        foreach (immutable k; compressed[1 .. $]) {
            Ta entry;
            if (k < dict.length)
                entry = dict[k];
            else if (k == dict.length)
                entry = w ~ w[0];
            else
                throw new Exception("Bad compressed k.");
            result ~= entry;

            dict ~= w ~ entry[0];
            w = entry;
        }

        return result;
    }
}

void main() {
    import std.stdio;
    immutable txt = "TOBEORNOTTOBEORTOBEORNOT";
    /*immutable*/ const compressed = LZW.compress(cast(LZW.Ta)txt);
    writeln(compressed);
    immutable decompressed = LZW.decompress(compressed);
    writeln(cast(string)decompressed);
}
