int n = 1;
int sq = 0;

Console.WriteLine("Square Numbers between 100 and 1000");

do
{
    sq = (int)Math.Pow(n, 2);

    if (int.IsOddInteger(sq) && sq > 100 && sq < 1000)
    {
        Console.WriteLine(sq);
    }

    n++;
} while (sq < 1000);
</syntaxhighlight >
{{ out }}
<pre>
Square Numbers between 100 and 1000
121
169
225
289
361
441
529
625
729
841
961
</pre>

