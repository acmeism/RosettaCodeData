sub moser (\n) { 1/24 * (n⁴ - 6*n³ +23*n² - 18*n + 24) }

sub binomial { [×] ($^n … 0) Z/ 1 .. $^p }

sub binomial-transform (*@seq) {
    @seq.keys.map: -> \n { sum (0..n).map: -> \k { binomial(n,k) × @seq[k] } }
}

sub pascals-triangle { [1], {[0, |$_ Z+ |$_, 0]} … * }

sub bernoullis-triangle { [1], {[0, |$_ Z+ |$_, 2 ** $++]} … * }


put "The first 20 values of Moser's circle problem calculated in different ways:\n
Direct calculation of a 4th order equation:\n", (1..20).map: &moser;

put "\nUsing binomial sums:\n", (1..Inf).map({binomial($_,4) + binomial($_,2) + 1})[^20];

put "\nUsing a binomial transform:\n", binomial-transform(1, 1, 1, 1, 1, 0 xx *)[^20];

put "\nPartial sums of Pascal's triangle:\n", pascals-triangle[^20].map: { quietly sum .[^5] };

put "\nFifth column of Bernoulli's triangle:\n", bernoullis-triangle[^20].map: {.[4] // .tail};
