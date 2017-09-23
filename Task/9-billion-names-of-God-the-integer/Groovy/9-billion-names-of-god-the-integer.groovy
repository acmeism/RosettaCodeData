def partitions(c)
{

    def p=[];
    int k = 0;
     p[k] = c;
    int counter=0;
    def counts=[];
	for (i in 0..c-1)
	{counts[i]=0;}
    while (true)
    {

        counter++;
		counts[p[0]-1]=counts[p[0]-1]+1;
		int rem_val = 0;
        while (k >= 0 && p[k] == 1)
        { rem_val += p[k];
            k--;}
        if (k < 0)  { break;}
        p[k]--;
        rem_val++;
        while (rem_val > p[k])
        {
            p[k+1] = p[k];
            rem_val = rem_val - p[k];
            k++;
        }
        p[k+1] = rem_val;
        k++;
    }
	println counts;
	return counter;
}


static void  main(String[] args)
{
for( i in 1..25 )
{partitions(i);}
}
