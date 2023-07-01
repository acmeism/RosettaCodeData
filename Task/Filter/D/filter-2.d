import tango.core.Array, tango.io.Stdout;

void main() {
    auto array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // removeIf places even elements at the beginnig of the array and returns number of found evens
    auto evens = array.removeIf( ( typeof(array[0]) i ) { return (i % 2) == 1; } );
    Stdout("Evens - ")( array[0 .. evens] ).newline; // The order of even elements is preserved
    Stdout("Odds - ")( array[evens .. $].sort ).newline; // Unlike odd elements
}
