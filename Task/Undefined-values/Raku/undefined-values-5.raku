my $is-defined = 1;
my $ain't-defined = Any;
my $doesn't-matter;
my Any:D $will-be-defined = $ain't-defined // $is-defined // $doesn't-matter;

my @a-mixed-list = Any, 1, Any, 'a';
$will-be-defined = [//] @a-mixed-list; # [//] will return the first defined value

my @a = Any,Any,1,1;
my @b = 2,Any,Any,2;
my @may-contain-any = @a >>//<< @b; # contains: [2, Any, 1, 1]

sub f1(){Failure.new('WELP!')};
sub f2(){ $_ ~~ Failure }; # orelse will kindly set the topic for us
my $s = (f1() orelse f2()); # Please note the parentheses, which are needed because orelse is
                            # much looser then infix:<=> .
dd $s; # this be Bool::False
