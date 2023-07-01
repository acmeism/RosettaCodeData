import std.base64;
import std.stdio;

void main() {
    auto data = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g=";
    writeln(data);
    writeln;

    auto decoded = cast(char[])Base64.decode(data);
    writeln(decoded);
}
