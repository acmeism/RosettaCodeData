function iprimes_upto($limit)
{
    for ($i = 2; $i < $limit; $i++)
    {
	    $primes[$i] = true;
    }

    for ($n = 2; $n < $limit; $n++)
    {
	    if ($primes[$n])
	    {
	        for ($i = $n*$n; $i < $limit; $i += $n)
	        {
                $primes[$i] = false;
	        }
	    }
    }

    return $primes;
}

echo wordwrap(
    'Primes less or equal than 1000 are : ' . PHP_EOL .
    implode(' ', array_keys(iprimes_upto(1000), true, true)),
    100
);
