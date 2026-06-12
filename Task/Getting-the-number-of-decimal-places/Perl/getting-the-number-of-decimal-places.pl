use bignum;

printf "Fractional precision: %2s  Number: %s\n", length((split /\./, $_)[1]) // 0, $_
    for 9, 12.345, <12.3450>, 0.1234567890987654321, 1/3, 1.5**63;
