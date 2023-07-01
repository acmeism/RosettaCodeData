shared void run() {
    value a = set {1, 2, 3};
    value b = set {3, 4, 5};
    value union = a | b;
    value intersection = a & b;
    value difference = a ~ b;
    value subset = a.subset(b);
    value equality = a == b;

    print("set a:         ``a``
           set b:         ``b``
           1 in a?        ``1 in a``
           a | b:         ``union``
           a & b:         ``intersection``
           a ~ b:         ``difference``
           a subset of b? ``subset``
           a == b?        ``equality``");
}
