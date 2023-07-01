say '    type         n      n**n  exp(n,n)';
say '--------  --------  --------  --------';

for 0, 0.0, FatRat.new(0), 0e0, 0+0i {
    printf "%8s  %8s  %8s  %8s\n", .^name, $_, $_**$_, exp($_,$_);
}
