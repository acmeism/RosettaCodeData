my $range = rx/ '{' $<start> = <-[.]>+? '..' $<end> = <-[.]>+? ['..' $<incr> = ['-'?\d+] ]? '}' /;
my $list  = rx/ ^ $<prefix> = .*? '{' (<-[,}]>+) +%% ',' '}' $<postfix> = .* $/;

sub expand (Str $string) {
    my @return = $string;
    if $string ~~ $range {
        quietly my ($start, $end, $incr) = $/<start end incr>».Str;
        $incr ||= 1;
        ($end, $start) = $start, $end if $incr < 0;
        $incr.=abs;

        if try all( +$start, +$end ) ~~ Numeric {
            $incr = - $incr if $start > $end;

            my ($sl, $el) = 0, 0;
            $sl = $start.chars if $start.starts-with('0');
            $el = $end.chars   if   $end.starts-with('0');

            my @this = $start < $end ?? (+$start, * + $incr …^ * > +$end) !! (+$start, * + $incr …^ * < +$end);
            @return  = @this.map: { $string.subst($range, sprintf("%{'0' ~ max $sl, $el}d", $_) ) }
        }
        elsif try +$start ~~ Numeric or +$end ~~ Numeric {
            return $string #fail
        }
        else {
            my @this;
            if $start.chars + $end.chars > 2 {
                return $string if $start.succ eq $start or $end.succ eq $end; # fail
                @this = $start lt $end ?? ($start, (*.succ xx $incr).tail …^ * gt $end) !! ($start, (*.pred xx $incr).tail …^ * lt $end);
            }
            else {
                $incr = -$incr if $start gt $end;
                @this = $start lt $end ?? ($start, (*.ord + $incr).chr …^ * gt $end) !! ($start, (*.ord + $incr).chr …^ * lt $end);
            }
            @return = @this.map: { $string.subst($range, sprintf("%s", $_) ) }
        }
    }
    if $string ~~ $list {
        my $these = $/[0]».Str;
        my ($prefix, $postfix) = $/<prefix postfix>».Str;
        if ($prefix ~ $postfix).chars {
            @return = $these.map: { $string.subst($list, $prefix ~ $_ ~ $postfix) } if $these.elems > 1
        }
        else {
            @return = $these.join: ' '
        }
    }
    my $cnt = 1;
    while $cnt != +@return {
        $cnt = +@return;
        @return.=map: { |.&expand }
    }
    @return
}

for qww<
    # Required tests

    simpleNumberRising{1..3}.txt
    simpleAlphaDescending-{Z..X}.txt
    steppedDownAndPadded-{10..00..5}.txt
    minusSignFlipsSequence{030..20..-5}.txt
    combined-{Q..P}{2..1}.txt
    emoji{🌵..🌶}{🌽..🌾}etc
    li{teral
    rangeless{}empty
    rangeless{random}string

    # Test some other features

    'stop point not in sequence-{02..10..3}.txt'
    steppedAlphaRising{P..Z..2}.txt
    'simple {just,give,me,money} list'
    {thatʼs,what,I,want}
    'emoji {☃,☄}{★,🇺🇸,☆} lists'
    'alphanumeric mix{ab7..ac1}.txt'
    'alphanumeric mix{0A..0C}.txt'

    # fail by design

    'mixed terms fail {7..C}.txt'
    'multi char emoji ranges fail {🌵🌵..🌵🌶}'
  > -> $test {
     say "$test ->";
     say ('    ' xx * Z~ expand $test).join: "\n";
     say '';
}
