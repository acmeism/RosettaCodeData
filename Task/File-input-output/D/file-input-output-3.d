import std.stdio;

int main() {
    auto from = File("input.txt", "rb");
    scope(exit) from.close();

    auto to = File("output.txt", "wb");
    scope(exit) to.close();

    foreach(buffer; from.byChunk(new ubyte[4096*1024])) {
        to.rawWrite(buffer);
    }

    return 0;
}
