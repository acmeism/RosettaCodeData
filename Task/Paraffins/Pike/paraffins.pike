int MAX_N = 300;
int BRANCH = 4;

array ra = allocate(MAX_N);
array unrooted = allocate(MAX_N);

void tree(int br, int n, int l, int sum, int cnt)
{
    int c;
    for (int b = br + 1; b < BRANCH + 1; b++)
    {
        sum += n;
        if (sum >= MAX_N)
            return;

        // prevent unneeded long math
        if (l * 2 >= sum && b >= BRANCH)
            return;

        if (b == br + 1)
        {
            c = ra[n] * cnt;
        }
        else
        {
            c = c * (ra[n] + (b - br - 1)) / (b - br);
        }

        if (l * 2 < sum)
            unrooted[sum] += c;

        if (b < BRANCH)
        {
            ra[sum] += c;
            for (int m=1; m < n; m++)
            {
                tree(b, m, l, sum, c);
            }
        }
    }
}

void bicenter(int s)
{
    if (!(s & 1))
    {
        int aux = ra[s / 2];
        unrooted[s] += aux * (aux + 1) / 2;
    }
}


void main()
{
    ra[0] = ra[1] = unrooted[0] = unrooted[1] = 1;

    for (int n = 1; n < MAX_N; n++)
    {
        tree(0, n, n, 1, 1);
        bicenter(n);
        write("%d: %d\n", n, unrooted[n]);
    }
}
