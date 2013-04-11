#include <stdio.h>

int data[] = {  85, 88, 75, 66, 25, 29, 83, 39, 97,
                68, 41, 10, 49, 16, 65, 32, 92, 28, 98 };

int pick(int at, int remain, int accu, int treat)
{
        if (!remain) return (accu > treat) ? 1 : 0;

        return  pick(at - 1, remain - 1, accu + data[at - 1], treat) +
                ( at > remain ? pick(at - 1, remain, accu, treat) : 0 );
}

int main()
{
        int treat = 0, i;
        int le, gt;
        double total = 1;
        for (i = 0; i < 9; i++) treat += data[i];
        for (i = 19; i > 10; i--) total *= i;
        for (i = 9; i > 0; i--) total /= i;

        gt = pick(19, 9, 0, treat);
        le = total - gt;

        printf("<= : %f%%  %d\n > : %f%%  %d\n",
               100 * le / total, le, 100 * gt / total, gt);
        return 0;
}
