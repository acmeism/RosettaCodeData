Foo[] foos = new Foo[n]; // all elements initialized to null
for (int i = 0; i < foos.length; i++)
    foos[i] = new Foo();

// incorrect version:
Foo[] foos_WRONG = new Foo[n];
Arrays.fill(foos, new Foo());  // new Foo() only evaluated once
