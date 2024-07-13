base=10;

gen_pi_digits(){
    base_places=$1 yield=$2

    ((nine=base - 1));
    local nines=0 predigit=0; # first predigit is_a 0 #
    declare -a digits; # [base_places*10 over 3]#long# ; # we need 3 times the digits to calculate #
    lwb_digits=1;
    ((upb_digits=base_places*10 / 3));
    for((place=lwb_digits; place<=upb_digits; place++)); do digits[$place]=2; done; # start with 2s #
    for((place=1; place<=base_places + 1; place++)); do
        digit=0;
        for((i=upb_digits; i>=lwb_digits; i--)); do # work backwards #
            ((x=base*digits[i] + digit*i));
            ((digits[i]=x%(2*i-1)));
            ((digit=x/(2*i-1)))
        done;
        ((digits[lwb_digits]=digit % base)); ((digit/=base));
#   nines := #
            if((digit == nine)); then
                ((nines=nines + 1))
            else
                if((digit == base)); then
                    ((out=predigit+1));
                    $yield $out; predigit=0;
                    for((repeats=1; repeats<=nines; repeats++)); do $yield 0; done
                else
                    if((place != 1)); then $yield $predigit; fi; predigit=$digit;
                    for((repeats=1; repeats<=nines; repeats++)); do $yield $nine; done
                fi;
                nines=0
            fi
    done;
    $yield $predigit
};

print_digit(){
    echo -n $1
}
# feynman_point=762; # feynman_point + 4 is a good test case
# the 33rd decimal place is a shorter tricky test case #
target="3.1415926.......................502";
((test_decimal_places=${#target}-2)); # upb

# iterate throught the digits as they are being found #
gen_pi_digits $test_decimal_places print_digit
echo # (new_line)
