#include <stdio.h>
#include <stdlib.h>

struct Generator
{
    public:
        Generator(int s, int v)
            : cSlots(s)
            , cValues(v)
        {
            a = new int[s];

            for (int i = 0; i < cSlots - 1; i++) {
                a[i] = 1;
            }
            a[cSlots - 1] = 0;

            nextInd = cSlots;
        }

        ~Generator()
        {
            delete a;
        }

        bool doNext()
        {
            for (;;)
            {
                if (a[nextInd - 1] == cValues) {
                    nextInd--;
                    if (nextInd == 0)
                        return false;
                }
                else {
                    a[nextInd - 1]++;
                    while (nextInd < cSlots) {
                        nextInd++;
                        a[nextInd - 1] = 1;
                    }

                    return true;
                }
            }
        }

        void doPrint()
        {
            printf("(");
            for (int i = 0; i < cSlots; i++) {
                printf("%d", a[i]);
            }
            printf(")");
        }

    private:
        int *a;
        int cSlots;
        int cValues;
        int nextInd;
};


int main()
{
    Generator g(3, 4);

    while (g.doNext()) {
        g.doPrint();
    }

    return 0;
}

