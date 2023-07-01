#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <string.h>

int RomanNumerals_parseInt(const char* string)
{
    int value;
    return scanf("%u", &value) == 1 && value > 0 ? value : 0;
}

const char* RomanNumerals_toString(int value)
{
#define ROMAN_NUMERALS_MAX_OUTPUT_STRING_SIZE 64
    static buffer[ROMAN_NUMERALS_MAX_OUTPUT_STRING_SIZE];

    const static int maxValue = 5000;
    const static int minValue = 1;

    const static struct Digit {
        char string[4]; // It's better to use 4 than 3 (aligment).
        int  value;
    } digits[] = {
        {"M", 1000}, {"CM", 900}, {"D", 500 }, {"CD", 400 },
        {"C", 100 }, {"XC", 90 }, {"L",  50 }, {"XL", 40},
        {"X", 10}, {"IX", 9}, {"V", 5}, {"IV", 4}, {"I", 1 },
        {"?", 0}
    };

    *buffer = '\0'; // faster than memset(buffer, 0, sizeof(buffer));
    if (minValue <= value && value <= maxValue)
    {
        struct Digit* digit = &digits[0];

        while (digit->value)
        {
            while (value >= digit->value)
            {
                value -= digit->value;
                // It is not necessary - total length would not be exceeded...
                // if (strlen(buffer) + strlen(digit->string) < sizeof(buffer))
                strcat(buffer, digit->string);
            }
            digit++;
        }
    }
    return buffer;
}


int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        // Blanks are needed for a consistient blackground on some systems.
        // BTW, puts append an extra newline at the end.
        //
        puts("Write given numbers as Roman numerals. \n"
             "                                       \n"
             "Usage:                                 \n"
             "    roman n1 n2 n3 ...                 \n"
             "                                       \n"
             "where n1 n2 n3 etc. are Arabic numerals\n");

        int numbers[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1498, 2022 };
        for (int i = 0; i < sizeof(numbers) / sizeof(int); i++)
        {
            printf("%4d = %s\n",
                numbers[i], RomanNumerals_toString(numbers[i]));
        }
    }
    else
    {
        for (int i = 1; i < argc; i++)
        {
            int number = RomanNumerals_parseInt(argv[i]);
            if (number)
            {
                puts(RomanNumerals_toString(number));
            }
            else
            {
                puts("???");
            }
        }
    }

    return 0;
}
