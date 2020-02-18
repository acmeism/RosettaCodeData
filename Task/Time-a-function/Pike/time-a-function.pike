void get_some_primes()
{
    int i;
    while(i < 10000)
        i = i->next_prime();
}

void main()
{
    float time_wasted = gauge( get_some_primes() );
    write("Wasted %f CPU seconds calculating primes\n", time_wasted);
}
