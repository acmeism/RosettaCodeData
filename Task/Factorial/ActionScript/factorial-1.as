public static function factorial(n:int):int
{
    if (n < 0)
        return 0;

    var fact:int = 1;
    for (var i:int = 1; i <= n; i++)
        fact *= i;

    return fact;
}
