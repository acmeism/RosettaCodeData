link a, b, c;
a.next = &b;
a.prev = null;
a.data = 1;
b.next = null;
b.prev = &a;
b.data = 3;
c.data = 2;
