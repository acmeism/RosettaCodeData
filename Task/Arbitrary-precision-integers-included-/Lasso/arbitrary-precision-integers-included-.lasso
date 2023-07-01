define integer->pow(factor::integer) => {
    #factor <= 0
        ? return 0

    local(retVal) = 1

    loop(#factor) => { #retVal *= self }

    return #retVal
}

local(bigint) = string(5->pow(4->pow(3->pow(2))))
#bigint->sub(1,20) + ` ... ` + #bigint->sub(#bigint->size - 19)
"\n"
`Number of digits: ` + #bigint->size
