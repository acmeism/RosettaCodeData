use Test;
plan *;

for lines() {
    is tan(.eval), /INCORRECT/ ?? none(1) !! 1 given
    .subst(/'pi/4 = '/, '')\
    .subst(/arctan/, 'atan', :g)\
    .subst(/'[INCORRECT]'/, '# INCORRECT')
}
