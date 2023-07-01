module controlFieldsInStruct;

import tango.core.BitArray;
import tango.io.Stdout;
import tango.text.convert.Integer;

class RS232Wrapper(int Length = 9)
{
    static assert(Length == 9 || Length == 25, "ERROR, wrong type");
    BitArray ba;
    static uint[char[]] _map;

    public:

    static if (Length == 9) {
        static this() {
            _map = [ cast(char[])
                "CD"  : 1, "RD"  : 2, "TD"  : 3, "DTR" : 4, "SG"  : 5,
                "DSR" : 6, "RTS" : 7, "CTS" : 8, "RI"  : 9
            ];
        }
    } else {
        static this() {
            _map = [ cast(char[])
                "PG"  : 1u, "TD"  :  2, "RD"  :  3, "RTS" :  4, "CTS" :  5,
                "DSR" :  6, "SG"  :  7, "CD"  :  8, "+"   :  9, "-"   : 10,
                "SCD" : 12, "SCS" : 13, "STD" : 14, "TC"  : 15, "SRD" : 16,
                "RC"  : 17, "SRS" : 19, "DTR" : 20, "SQD" : 21, "RI"  : 22,
                "DRS" : 23, "XTC" : 24
            ];
        }
    }


    this() {
        ba.length = Length;
    }

    bool opIndex(uint pos) { return ba[pos]; }
    bool opIndexAssign(bool b, uint pos) { return (ba[pos] = b); }
    bool opIndex(char[] name) {
        assert (name in _map, "don't know that plug: " ~ name);
        return opIndex(_map[name]);
    }
    bool opIndexAssign(bool b, char[] name) {
        assert (name in _map, "don't know that plug: " ~ name);
        return opIndexAssign(b, _map[name]);
    }
    void opSliceAssign(bool b) { foreach (ref r; ba) r = b; }
    char[] toString() {
        char[] ret = "[";
        foreach (name, value; _map)
            ret ~= name ~ ":" ~ (ba[value]?"1":"0") ~", ";
        ret ~= "]";
        return ret;
    }
}

int main(char[][] args)
{
    auto ba = new RS232Wrapper!(25);

    // set all bits
    ba[] = 1;
    ba["RD"] = 0;
    ba[5] = 0;

    Stdout (ba).newline;

    return 0;
}
