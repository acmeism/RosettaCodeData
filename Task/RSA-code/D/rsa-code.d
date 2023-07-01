void main() {
    import std.stdio, std.bigint, std.algorithm, std.string, std.range,
           modular_exponentiation;

    immutable txt = "Rosetta Code";
    writeln("Plain text:             ", txt);

    // A key set big enough to hold 16 bytes of plain text in
    // a single block (to simplify the example) and also big enough
    // to demonstrate efficiency of modular exponentiation.
    immutable BigInt n = "2463574872878749457479".BigInt *
                         "3862806018422572001483".BigInt;
    immutable BigInt e = 2 ^^ 16 + 1;
    immutable BigInt d = "5617843187844953170308463622230283376298685";

    // Convert plain text to a number.
    immutable txtN = reduce!q{ (a << 8) | uint(b) }(0.BigInt, txt);
    if (txtN >= n)
        return writeln("Plain text message too long.");
    writeln("Plain text as a number: ", txtN);

    // Encode a single number.
    immutable enc = txtN.powMod(e, n);
    writeln("Encoded:                ", enc);

    // Decode a single number.
    auto dec = enc.powMod(d, n);
    writeln("Decoded:                ", dec);

    // Convert number to text.
    char[] decTxt;
    for (; dec; dec >>= 8)
        decTxt ~= (dec & 0xff).toInt;
    writeln("Decoded number as text: ", decTxt.retro);
}
