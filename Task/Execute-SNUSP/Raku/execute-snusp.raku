class SNUSP {

    has @!inst-pointer;
    has @!call-stack;
    has @!direction;
    has @!memory;
    has $!mem-pointer;

    method run ($code) {
        init();
        my @code = pad( |$code.lines );
        for @code.kv -> $r, @l {
           my $index = @l.grep( /'$'/, :k );
           if $index {
               @!inst-pointer = $r, $index;
               last
           }
        }

        loop {
            my $instruction = @code[@!inst-pointer[0]; @!inst-pointer[1]];
            given $instruction {
                when '>'  { $!mem-pointer++ }
                when '<'  { $!mem-pointer-- }
                when '+'  { @!memory[$!mem-pointer]++ }
                when '-'  { @!memory[$!mem-pointer]-- }
                when '.'  { print @!memory[$!mem-pointer].chr }
                when ','  { @!memory[$!mem-pointer] = $*IN.getc.ord }
                when '/'  { @!direction = @!direction.reverse «*» -1 }
                when '\\' { @!direction = @!direction.reverse }
                when '!'  { nexti() }
                when '?'  { nexti() unless @!memory[$!mem-pointer] }
                when '@'  { @!call-stack.push: @!inst-pointer.Array }
                when '#'  {
                    last unless +@!call-stack;
                    @!inst-pointer = |@!call-stack.pop;
                    nexti();
                }
            }
            nexti();
            last if @!inst-pointer[0] > +@code or
                    @!inst-pointer[1] > +@code[0];
        }

        sub init () {
            @!inst-pointer = 0, 0;
            @!direction    = 0, 1;
            $!mem-pointer  = 0;
            @!memory       = ()
        }

        sub nexti () { @!inst-pointer Z+= @!direction }

        sub pad ( *@lines ) {
            my $max = max @lines».chars;
            my @pad = @lines.map: $max - *.chars;
            map -> $i { flat @lines[$i].comb, ' ' xx @pad[$i] }, ^@lines;
        }
    }
}

# TESTING
my $hw = q:to/END/;
    /++++!/===========?\>++.>+.+++++++..+++\
    \+++\ | /+>+++++++>/ /++++++++++<<.++>./
    $+++/ | \+++++++++>\ \+++++.>.+++.-----\
          \==-<<<<+>+++/ /=.>.+>.--------.-/
    END

my $snusp = SNUSP.new;
$snusp.run($hw)
