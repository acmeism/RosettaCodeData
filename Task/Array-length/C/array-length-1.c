#include <stdio.h>

int main()
{
    const char *fruit[2] = { "apples", "oranges" };

    // Acquire the length of the array by dividing the size of all elements (found
    // with sizeof(fruit)) by the size of the first element.

    // Note that since the array elements are pointers to null-terminated character
    // arrays, the size of the first element is actually the size of the pointer
    // type - not the length of the string.

    // This size, regardless of the type being pointed to, is 8 bytes, 4 bytes, or
    // 2 bytes on 64-bit, 32-bit, or 16-bit platforms respectively.
    int length = sizeof(fruit) / sizeof(fruit[0]);

    printf("%d\n", length);

    return 0;
}
