use v5.36;
use experimental 'for_list';
use utf8;
binmode(STDOUT, ':utf8');

sub to_Greek ($string) {
    my %pre  = qw<Ph F ck k ee h J I rh r oo w ph f ch χ th θ ps ψ Ch Χ Th Θ Ps Ψ kh χ 's ' 'ς '>;
    my %post = split '', 'aαbβdδeεfφgγhηiιjιkκlλmμnνoοpπqκrρsσtτuυvβwωxξyυzζAΑBΒDΔEΕFΦGΓHΗIΙLΛMΜNΝOΟPΠQΚRΡSΣTΤUΥWΩXΞZΖ';
    for my ($k,$v) (%pre, %post) { $string =~ s/$k/$v/g }
    $string
}

say "$_\n" . to_Greek $_ . "\n" for
    'The quick brown fox jumped over the lazy dog.',
    'I was looking at some rhododendrons in my back garden, dressed in my khaki shorts, when the telephone rang.',
    'As I answered it, I cheerfully glimpsed that the July sun caused a fragment of black pine wax to ooze on the velvet quilt laying in my patio.';
