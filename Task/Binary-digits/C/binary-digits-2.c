#include <stdio.h>

void IntToBitString(unsigned int number)
{
    int num_bits = sizeof(unsigned int) * 8;

    bool startPrinting = false;
    for (int bit_pos=num_bits-1; bit_pos >= 0; bit_pos--)
    {
        bool isBitSet = (number & (1<<bit_pos)) != 0;

        if (!startPrinting && isBitSet)
            startPrinting = true;

        if (startPrinting || bit_pos==0)
            printf("%s", isBitSet ? "1":"0");
    }

    printf("\r\n");
}

int main()
{
    IntToBitString(0);
    IntToBitString(5);
    IntToBitString(50);
    IntToBitString(9000);

    return 0;
}
