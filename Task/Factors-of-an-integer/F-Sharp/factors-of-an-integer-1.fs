let factors number = seq {
    for divisor in 1 .. (float >> sqrt >> int) number do
    if number % divisor = 0 then
        yield divisor
        if number <> 1 then yield number / divisor //special case condition: when number=1 then divisor=(number/divisor), so don't repeat it
}
