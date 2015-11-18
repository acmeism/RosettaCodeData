my %hash{Any}; # same as %hash{*}
class C {};
my %cash{C};
%cash{C.new} = 1;
