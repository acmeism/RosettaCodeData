use Rat::Precise;

printf "Fractional precision: %-2s || Number: %s\n", (.split('.')[1] // '').chars, $_
    for 9, 12.345, '12.3450', 0.1234567890987654321, (1.5**63).precise;
