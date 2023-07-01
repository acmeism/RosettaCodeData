List<Foo> foos = new ArrayList<Foo>();
for (int i = 0; i < n; i++)
    foos.add(new Foo());

// incorrect:
List<Foo> foos_WRONG = Collections.nCopies(n, new Foo());  // new Foo() only evaluated once
