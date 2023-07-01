my $text = '36-0.txt'.IO.slurp.subst(/.+ '*** START OF THIS' .+? \n (.*?) 'End of the Project Gutenberg EBook' .*/, {$0} );

$text.=subst(/ <+punct-[.!?\’,]> /, ' ', :g);
$text.=subst(/ (\s) '’' (\s)  /, '', :g);
$text.=subst(/ (\w) '’' (\s)  /, {$0~$1}, :g);
$text.=subst(/ (\s) '’' (\w)  /, {$0~$1}, :g);

my (%one, %two);

for $text.comb(/[\w+(\’\w+)?]','?|<punct>/).rotor(3 => -2) {
    %two{.[0]}{.[1]}{.[2]}++;
    %one{.[0]}{.[1]}++;
}

sub weightedpick (%hash) { %hash.keys.map( { $_ xx %hash{$_} } ).pick }

sub sentence {
    my @sentence = <. ! ?>.roll;
    @sentence.push: weightedpick( %one{ @sentence[0] } );
    @sentence.push: weightedpick( %two{ @sentence[*-2] }{ @sentence[*-1] } // %('.' => 1) )[0]
      until @sentence[*-1] ∈ <. ! ?>;
    @sentence.=squish;
    shift @sentence;
    redo if @sentence < 7;
    @sentence.join(' ').tc.subst(/\s(<:punct>)/, {$0}, :g);
}

say sentence() ~ "\n" for ^10;
