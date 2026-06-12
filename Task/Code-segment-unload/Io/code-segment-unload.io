# Call anonymous block to do the initialization.

block(
    // Put initialization code here.
    writeln("Initialization complete.")
) call()

# Garbage collector is now free to recover initialization resources.

writeln("Doing real work.")
// Code to do the real work here.
