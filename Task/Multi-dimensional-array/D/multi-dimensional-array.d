import std.stdio;

/*
 * Using just what is built-in, D only supports single dimension arrays. Like other languages, arrays can be built up as jagged arrays.
 * Arrays can either be created with a fixed size, or dynamically with support for resizing.
 */
void nativeExample() {
    int[3] staticArray; // Statically allocated array. Will only contain three elements, accessed from 0 to 2 inclusive.
    staticArray[0] = 1;
    staticArray[1] = 2;
    staticArray[2] = 3;
    writeln("Static array: ", staticArray);

    int[] dynamicArray; // Dynamically allocated array.
    dynamicArray.length = 3; // The array can be resized at runtime. If the number elements exceeds the allocated memory, new memory will be given from the heap.
    dynamicArray[0] = 4;
    dynamicArray[1] = 5;
    dynamicArray[2] = 6;
    dynamicArray ~= 7; // New elements can be concatenated.
    writeln("Dynamic array: ", dynamicArray);
}

/*
 * Multi-dimensional arrays can be created as custom types (classes or structs). They can have as many dimensions as are written for support.
 * The indexes can either be standard 0-n, or arbitrary m-n as needed. This example shows just a two dimensional example with standard indexes.
 * As few or as many of these pieces can be implemented as desired (compile-time error is given if a feature is not supported).
 */
struct Matrix(T) {
    // A dynamic array for the actual storage.
    private:
    T[] source;
    uint rows, cols; // dimensions

    public:
    this(uint m, uint n) {
        rows = m;
        cols = n;
        source.length = m*n;
    }

    /// Allow for short access to limits, e.g. a[$-1,$-1]
    int opDollar(size_t pos : 0)() const {
        return rows;
    }
    int opDollar(size_t pos : 1)()  const {
        return cols;
    }

    /// Allow for indexing to read a value, e.g. a[0,0]
    T opIndex(int i, int j) const in {
        assert(0 <= i && i <= rows, "Row index out of bounds");
        assert(0 <= j && j <= cols, "Col index out of bounds");
    } body {
        return source[i*rows + j];
    }

    /// Allow for assigning elements, e.g. a[0,0] = c
    T opIndexAssign(T elem, int i, int j) in {
        assert(0 <= i && i <= rows, "Row index out of bounds");
        assert(0 <= j && j <= cols, "Col index out of bounds");
    } body {
        auto index = rows*i + j;
        T prev = source[index];
        source[index] = elem;
        return prev;
    }

    /// Allow for applying operations and assigning elements, e.g. a[0,0] += c
    T opIndexOpAssign(string op)(T elem, int i, int j) {
        auto index = rows*i + j;
        T prev = source[index];
        mixin("source[index] " ~ op ~ "= elem;");
        return prev;
    }

    /// Support slicing, shown below
    auto opSlice(size_t pos)(int a, int b) in {
        assert(0 <= a && a <= opDollar!pos);
        assert(0 <= b && b <= opDollar!pos);
    } body {
        if (pos == 0) {
        } else {
            assert(0 <= a && a <= cols, "Col slice out of bounds");
            assert(0 <= b && b <= cols, "Col slice out of bounds");
        }
        return [a, b];
    }

    /// Allow for getting a sub-portion of the matrix, e.g. [0..2, 2..4]
    auto opIndex(int[] a, int[] b) const {
        auto t = Matrix!T(a.length, b.length);
        foreach(i, ia; a) {
            foreach(j, jb; b) {
                t[i, j] = this[ia, jb];
            }
        }
        return t;
    }
    auto opIndex(int[] a, int b) const {
        return opIndex(a, [b,b+1]);
    }
    auto opIndex(int a, int[] b) const {
        return opIndex([a,a+1], b);
    }

    /// Assign a single value to every element
    void opAssign(T value) {
        source[0..$] = value;
    }

    /// Assign a single element to a subset of the Matrix
    void opIndexAssign(T elem, int[] a, int[] b) {
        for (int i=a[0]; i<a[1]; i++) {
            auto start = rows * i;
            source[start+b[0]..start+b[1]] = elem;
        }
    }
    void opIndexAssign(T elem, int[] a, int b) {
        opIndexAssign(elem, a, [b, b+1]);
    }
    void opIndexAssign(T elem, int a, int[] b) {
        opIndexAssign(elem, [a, a+1], b);
    }

    /// Define how to write Matrix values as a string. Only does a simple string representation
    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;

        sink("[");
        foreach (i; 0..opDollar!0) {
            sink("[");
            foreach (j; 0..opDollar!1) {
                formattedWrite(sink, "%s", opIndex(i,j));
                if (j < cols-1) sink(", ");
            }
            if (i < rows-1) sink("]\n ");
            else sink("]");
        }
        sink("]");
    }
}

void customArray() {
    auto multi = Matrix!int(3, 3);
    writeln("Create a multidimensional object:\n", multi);
    writeln("Access an element: ", multi[0,0]);
    multi[0,0] = 1;
    writeln("Assign an element: ", multi[0,0]);
    multi[0,0] += 2;
    writeln("Arithmetic on an element: ", multi[0,0]);
    writeln("Slice a matrix:\n", multi[0..2, 0..2]);
    multi = 5;
    writeln("Assign all elements:\n", multi);
    multi[0..2,1..3] = 4;
    writeln("Assign some elements:\n", multi);
}

void main() {
    nativeExample();
    customArray();
}
