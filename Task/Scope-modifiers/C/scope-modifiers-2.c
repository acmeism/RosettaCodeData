float v;         // a global to be used from file1.c too
static int p;    // a file-scoped p; nothing to share with static p
                 // in file1.c

int code(int);   // this is enough to be able to use global code defined in file1.c
                 // normally these things go into a header.h

// ...
