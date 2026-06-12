int power = 1;
while(power++) {
    int candidate = 2->pow(power)-1;
    if( candidate->probably_prime_p() )
        write("2 ^ %d - 1\n", power);
}
