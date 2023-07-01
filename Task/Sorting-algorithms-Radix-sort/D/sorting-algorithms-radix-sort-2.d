import std.array, std.traits;

// considered pure for this program
extern(C) void* alloca(in size_t length) pure nothrow;

void radixSort(size_t MAX_ALLOCA=5_000, U)(U[] data)
pure nothrow if (isUnsigned!U) {
    static void radix(in uint byteIndex, in U[] source, U[] dest)
    pure nothrow {
        immutable size_t sourceSize = source.length;
        ubyte* curByte = (cast(ubyte*)source.ptr) + byteIndex;
        uint[ubyte.max + 1] byteCounter;
        for (size_t i = 0; i < sourceSize; i++, curByte += U.sizeof)
            byteCounter[*curByte]++;

        {
            uint indexStart;
            foreach (uint i; 0 .. byteCounter.length) {
                immutable size_t tempCount = byteCounter[i];
                byteCounter[i] = indexStart;
                indexStart += tempCount;
            }
        }

        curByte = (cast(ubyte*)source.ptr) + byteIndex;
        for (size_t i = 0; i < sourceSize; i++, curByte += U.sizeof) {
            uint* countPtr = byteCounter.ptr + *curByte;
            dest[*countPtr] = source[i];
            (*countPtr)++;
        }
    }

    U[] tempData;
    if (U.sizeof * data.length <= MAX_ALLOCA) {
        U* ptr = cast(U*)alloca(data.length * U.sizeof);
        if (ptr != null)
            tempData = ptr[0 .. data.length];
    }
    if (tempData.empty)
        tempData = uninitializedArray!(U[])(data.length);

    static if (U.sizeof == 1) {
        radix(0, data, tempData);
        data[] = tempData[];
    } else {
        for (uint i = 0; i < U.sizeof; i += 2) {
            radix(i + 0, data, tempData);
            radix(i + 1, tempData, data);
        }
    }
}

void main() {
    import std.stdio;
    uint[] items = [170, 45, 75, 4294967206, 2, 24, 4294966494, 66];
    items.radixSort();
    writeln(items);
}
