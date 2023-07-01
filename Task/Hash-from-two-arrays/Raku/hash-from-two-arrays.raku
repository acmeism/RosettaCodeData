my @keys = <a b c d e>;
my @values = ^5;

my %hash = @keys Z=> @values;


#Alternatively, by assigning to a hash slice:
%hash{@keys} = @values;


# Or to create an anonymous hash:
%( @keys Z=> @values );


# All of these zip forms trim the result to the length of the shorter of their two input lists.
# If you wish to enforce equal lengths, you can use a strict hyperoperator instead:

quietly # suppress warnings about unused hash
{ @keys »=>« @values };  # Will fail if the lists differ in length
