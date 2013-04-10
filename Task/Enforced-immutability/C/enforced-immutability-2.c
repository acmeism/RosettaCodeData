const char   foo     = 'a';
const double pi      = 3.14159;
const double minsize = 10;
const double maxsize = 10;

// On pointers
const int *       ptrToConst;      // The value is constant, but the pointer may change.
int const *       ptrToConst;      // The value is constant, but the pointer may change. (Identical to the above.)
int       * const constPtr;        // The pointer is constant, but the value may change.
int const * const constPtrToConst; // Both the pointer and value are constant.

// On parameters
int main(const int    argc, // note that here, the "const", applied to the integer argument itself,
                            // is kind of pointless, as arguments are passed by value, so
                            // it does not affect any code outside of the function
         const char** argv)
{
    /* ... */
}
