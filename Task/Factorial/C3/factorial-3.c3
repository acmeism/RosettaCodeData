macro int factorial($n)
{
    $if ($n == 0):
        return 1;
    $else:
        return $n * @factorial($n - 1);
    $endif;
}

fn void test()
{
    int x = @factorial(10);
}
