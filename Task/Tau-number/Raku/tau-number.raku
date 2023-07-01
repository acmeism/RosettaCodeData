use Prime::Factor:ver<0.3.0+>;
use Lingua::EN::Numbers;

say "\nTau function - first 100:\n",        # ID
(1..*).map({ +.&divisors })[^100]\          # the task
.batch(20)».fmt("%3d").join("\n");          # display formatting

say "\nTau numbers - first 100:\n",         # ID
(1..*).grep({ $_ %% +.&divisors })[^100]\   # the task
.batch(10)».&comma».fmt("%5s").join("\n");  # display formatting

say "\nDivisor sums - first 100:\n",        # ID
(1..*).map({ [+] .&divisors })[^100]\       # the task
.batch(20)».fmt("%4d").join("\n");          # display formatting

say "\nDivisor products - first 100:\n",    # ID
(1..*).map({ [×] .&divisors })[^100]\       # the task
.batch(5)».&comma».fmt("%16s").join("\n");  # display formatting
