import std.stdio;
import std.string;
import std.traits;

string text =
`Here we have to do is there will be a input/source
 file in which we are going to Encrypt the file by replacing every
 upper/lower case alphabets of the source file with another
 predetermined upper/lower case alphabets or symbols and save
 it into another output/encrypted file and then again convert
 that output/encrypted file into original/decrypted file. This
 type of Encryption/Decryption scheme is often called a
 Substitution Cipher.`;

void main() {
    auto enc = encode(text);
    writeln("Encoded: ", enc);
    writeln;
    writeln("Decoded: ", decode(enc));
}

enum FORWARD = "A~B!C@D#E$F%G^H&I*J(K)L+M=N[O]P{Q}R<S>T/U?V:W;X.Y,Z a\tbcdefghijkl\nmnopqrstuvwxyz";
auto encode(string input) {
    return tr(input, FORWARD, REVERSE);
}

enum REVERSE = "VsciBjedgrzy\nHalvXZKtUP um\tGf?I/w>J<x.q,OC:F;R{A]p}n[D+h=Q)W(o*b&L^k%E$S#Y@M!T~N";
auto decode(string input) {
    return tr(input, REVERSE, FORWARD);
}
