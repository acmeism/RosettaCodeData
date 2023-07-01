void bitwise(int a, int b)
{
    write("a and b: %d\n", a & b);
    write("a or b:  %d\n", a | b);
    write("a xor b: %d\n", a ^ b);
    write("not a:   %d\n", ~a);
    write("a << b:  0x%x\n", a << b);
    write("a >> b:  %d\n", a >> b);
    // ints in Pike do not overflow, if a particular size of the int
    // is desired then cap it with an AND operation
    write("a << b & 0xffffffff (32bit cap):  0x%x\n",
          a << b & 0xffffffff);
}

void main()
{
    bitwise(255, 30);
}
