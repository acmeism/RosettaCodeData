my @CODE = q:to/END/.lines;
Datasize: 3 Strings: 2
"count is: "
"\n"
    0 push  1
    5 store [0]
   10 fetch [0]
   15 push  10
   20 lt
   21 jz     (68) 65    # jump value adjusted
   26 push  0
   31 prts
   32 fetch [0]
   37 prti
   38 push  1
   43 prts
   44 fetch [0]
   49 push  1
   54 add
   55 store [0]
   60 jmp    (-87) 10   # jump value adjusted
   65 halt
END

my (@stack, @strings, @data, $memory);
my $pc = 0;

(@CODE.shift) ~~ /'Datasize:' \s+ (\d+) \s+ 'Strings:' \s+ (\d+)/ or die "bad header";
my $w = $0; # 'wordsize' of op-codes and 'width' of data values
@strings.push: (my $s = @CODE.shift) eq '"\n"' ?? "\n" !! $s.subst(/'"'/, '', :g) for 1..$1;

sub value { substr($memory, ($pc += $w) - $w, $w).trim }

my %ops = (
  'no-op' => sub { },
  'add'   => sub { @stack[*-2]  +=   @stack.pop },
  'sub'   => sub { @stack[*-2]  -=   @stack.pop },
  'mul'   => sub { @stack[*-2]  *=   @stack.pop },
  'div'   => sub { @stack[*-2]  /=   @stack.pop },
  'mod'   => sub { @stack[*-2]  %=   @stack.pop },
  'neg'   => sub { @stack[*-1]   = - @stack[*-1] },
  'and'   => sub { @stack[*-2] &&=   @stack[*-1]; @stack.pop },
  'or'    => sub { @stack[*-2] ||=   @stack[*-1]; @stack.pop },
  'not'   => sub { @stack[*-1]   =   @stack[*-1]               ?? 0 !! 1 },
  'lt'    => sub { @stack[*-1]   =   @stack[*-2] <  @stack.pop ?? 1 !! 0 },
  'gt'    => sub { @stack[*-1]   =   @stack[*-2] >  @stack.pop ?? 1 !! 0 },
  'le'    => sub { @stack[*-1]   =   @stack[*-2] <= @stack.pop ?? 1 !! 0 },
  'ge'    => sub { @stack[*-1]   =   @stack[*-2] >= @stack.pop ?? 1 !! 0 },
  'ne'    => sub { @stack[*-1]   =   @stack[*-2] != @stack.pop ?? 1 !! 0 },
  'eq'    => sub { @stack[*-1]   =   @stack[*-2] == @stack.pop ?? 1 !! 0 },
  'store' => sub { @data[&value] =   @stack.pop },
  'fetch' => sub { @stack.push:      @data[&value] // 0 },
  'push'  => sub { @stack.push:      value() },
  'jmp'   => sub { $pc += value() - $w },
  'jz'    => sub { $pc += @stack.pop ?? $w !! value() - $w },
  'prts'  => sub { print @strings[@stack.pop] },
  'prti'  => sub { print @stack.pop },
  'prtc'  => sub { print chr @stack.pop },
  'halt'  => sub { exit }
);

my %op2n = %ops.keys.sort Z=> 0..*;
my %n2op = %op2n.invert;
%n2op{''} = 'no-op';

for @CODE -> $_ {
    next unless /\w/;
    /^ \s* \d+ \s+ (\w+)/ or die "bad line $_";
    $memory ~= %op2n{$0}.fmt("%{$w}d");
    /'(' ('-'?\d+) ')' | (\d+) ']'? $/;
    $memory ~= $0 ?? $0.fmt("%{$w}d") !! ' ' x $w;
}

loop {
    my $opcode = substr($memory, $pc, $w).trim;
    $pc += $w;
    %ops{%n2op{ $opcode }}();
}
