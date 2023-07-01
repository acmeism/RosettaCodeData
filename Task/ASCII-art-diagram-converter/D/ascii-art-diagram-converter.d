string makeStructFromDiagram(in string rawDiagram) pure @safe {
    import std.conv: text;
    import std.format: format;
    import std.string: strip, splitLines, indexOf;
    import std.array: empty, popFront;

    static void commitCurrent(ref uint anonCount,
                              ref uint totalBits,
                              ref size_t currentBits,
                              ref string code,
                              ref string currentName) pure @safe {
        if (currentBits) {
            code ~= "\t";

            currentName = currentName.strip;
            if (currentName.empty) {
                anonCount++;
                currentName = "anonymous_field_" ~ anonCount.text;
            }

            string type;
            if (currentBits == 1)
                type = "bool";
            else if (currentBits <= ubyte.sizeof * 8)
                type = "ubyte";
            else if (currentBits <= ushort.sizeof * 8)
                type = "ushort";
            else if (currentBits <= uint.sizeof * 8)
                type = "uint";
            else if (currentBits <= ulong.sizeof * 8)
                type = "ulong";
            //else if (currentBits <= ucent.sizeof * 8)
            //    type = "ucent";
            else assert(0, "Too many bits for the item " ~ currentName);

            immutable byteOffset = totalBits / 8;
            immutable bitOffset = totalBits % 8;


            // Getter:
            code ~= "@property " ~ type ~ " " ~ currentName ~
                    "() const pure nothrow @safe {\n";
            code ~= "\t\t";
            if (currentBits == 1) {
                code ~= format("return (_payload[%d] & (1 << (7-%d))) ? true : false;",
                               byteOffset, bitOffset);
            } else if (currentBits < 8) {
                auto mask = (1 << currentBits) - 1;
                mask <<= 7 - bitOffset - currentBits + 1;
                code ~= format("return (_payload[%d] & 0b%08b) >> %d;",
                               byteOffset, mask, 7 - bitOffset - currentBits + 1);
            } else {
                assert(currentBits % 8 == 0);
                assert(bitOffset == 0);
                code ~= type ~ " v = 0;\n\t\t";

                code ~= "version(LittleEndian) {\n\t\t";
                foreach (immutable i; 0 .. currentBits / 8)
                    code ~=  "\tv |= (cast(" ~ type ~ ") _payload[" ~
                             text(byteOffset + i) ~ "]) << (" ~
                             text((currentBits / 8) - i - 1) ~
                             " * 8);\n\t\t";
                code ~= "} else static assert(0);\n\t\t";
                code ~= "return v;";
            }
            code ~= "\n";
            code ~= "\t}\n\t";


            // Setter:
            code ~= "@property void " ~ currentName ~ "(in " ~ type ~
                    " value) pure nothrow @safe {\n";
            code ~= "\t\t";
            if (currentBits < 8) {
                auto mask = (1 << currentBits) - 1;
                mask <<= 7 - bitOffset - currentBits + 1;
                code ~= format("_payload[%d] &= ~0b%08b;\n\t\t",
                               byteOffset, mask);
                code ~= "assert(value < " ~ text(1 << currentBits) ~
                        ");\n\t\t";
                code~=format("_payload[%d] |= cast(ubyte) value << %d;",
                               byteOffset, 7 - bitOffset - currentBits + 1);
            } else {
                assert(currentBits % 8 == 0);
                assert(bitOffset == 0);

                code ~= "version(LittleEndian) {\n\t\t";
                foreach (immutable i; 0 .. currentBits / 8)
                    code ~= "\t_payload[" ~ text(byteOffset + i) ~
                            "] = (value >> (" ~
                            text((currentBits / 8) - i - 1) ~
                            " * 8) & 0xff);\n\t\t";
                code ~= "} else static assert(0);";
            }

            code ~= "\n";
            code ~= "\t}\n";
            totalBits += currentBits;
        }

        currentBits = 0;
        currentName = null;
    }

    enum C : char { pipe='|', cross='+' }
    enum cWidth = 3; // Width of a bit cell in the table.
    immutable diagram = rawDiagram.strip;

    size_t bitCountPerRow = 0, currentBits;
    uint anonCount = 0, totalBits;
    string currentName;
    string code = "struct {\n"; // Anonymous.

    foreach (line; diagram.splitLines) {
        assert(!line.empty);
        line = line.strip;
        if (line[0] == C.cross) {
            commitCurrent(anonCount, totalBits, currentBits, code, currentName);
            if (bitCountPerRow == 0)
                bitCountPerRow = (line.length - 1) / cWidth;
            else
                assert(bitCountPerRow == (line.length - 1) / cWidth);
        } else {
            // A field of some sort.
            while (line.length > 2) {
                assert(line[0] != '/',
                       "Variable length data not supported");
                assert(line[0] == C.pipe, "Malformed table");
                line.popFront;
                const idx = line[0 .. $ - 1].indexOf(C.pipe);
                if (idx != -1) {
                    const field = line[0 .. idx];
                    line = line[idx .. $];

                    commitCurrent(anonCount, totalBits, currentBits, code, currentName);
                    currentName = field;
                    currentBits = (field.length + 1) / cWidth;
                    commitCurrent(anonCount, totalBits, currentBits, code, currentName);
                } else {
                    // The full row or a continuation of the last.
                    currentName ~= line[0 .. $ - 1];
                    // At this point, line does not include the first
                    // C.pipe, but the length will include the last.
                    currentBits += line.length / cWidth;

                    line = line[$ .. $];
                }
            }
        }
    }

    // Using bytes to avoid endianness issues.
    // hopefully the compiler will optimize it, otherwise
    // maybe we could specialize the properties more.
    code ~= "\n\tprivate ubyte[" ~ text((totalBits + 7) / 8) ~ "] _payload;\n";

    return code ~ "}";
}


void main() { // Testing.
    import std.stdio;

    enum diagram = "
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      ID                       |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    QDCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ANCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    NSCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ARCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+";

    // To debug the code generation:
    //pragma(msg, diagram.makeStructFromDiagram);

    // Usage.
    static struct Header {
        mixin(diagram.makeStructFromDiagram);
    }

    Header h;
    h.ID = 10;
    h.RA = true;
    h.ARCOUNT = 255;
    h.Opcode = 7;

    // See the byte representation to test the setter's details.
    h._payload.writeln;

    // Test the getters:
    assert(h.ID == 10);
    assert(h.RA == true);
    assert(h.ARCOUNT == 255);
    assert(h.Opcode == 7);
}
