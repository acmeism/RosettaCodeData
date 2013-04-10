import std.math: FloatingPointControl;

void main() {
    // Enable hardware exceptions for division by zero, overflow
    // to infinity, invalid operations, and uninitialized
    // floating-point variables.
    FloatingPointControl fpc;
    fpc.enableExceptions(FloatingPointControl.severeExceptions);

    double f0 = 0.0;
    double y1 = f0 / f0; // generates hardware exception
                         // unless it's compiled with -O)
}
