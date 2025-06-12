#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Execute_Computer/Zero
use warnings;
$SIG{__WARN__} =  sub { die @_ };

my ($pc, $acc, $op, $addr, $mem, %ops, @memory, $program);
@ops{qw( NOP LDA STA ADD SUB BRZ JMP STP )} = map $_ << 5, 0 .. 7;
my $codes = qr/(?:@{[join '|', keys %ops ]})/;
my @inst = (sub {}, map eval "sub {$_}", split /\n/, <<'END' =~ s/#.*//gr);
$acc = $memory[$addr]               # LDA
$memory[$addr] = $acc               # STA
$acc = $acc + $memory[$addr] & 0xff # ADD
$acc = $acc - $memory[$addr] & 0xff # SUB
$acc or $pc = $addr                 # BRZ
$pc = $addr                         # JMP
END

sub assemble
  {
  local $_ = join '', @_; # pass in array of lines or one multi-line string
  $program = /;(.*)/ ? " $1" : '';
  my %labels;
  @memory = (0) x 32;
  s/^([a-z]\w*):/ $labels{$1} = $` =~ tr~\n~~; '' /igem;
  $memory[$` =~ tr/\n//] = $1
    ? $ops{$1} | ($labels{$2 // ''} // $2 // 0) & 0b00011111
    : ($labels{$2 // ''} // $2 // 0) & 0xff
    while /^\h*($codes)?(?:\h*(\b\w+))?/gm;
  }

sub run
  {
  $pc = $acc = 0;
  $inst[$op]() while $mem = $memory[$pc],
    ($op, $addr, $pc) = ($mem >> 5, $mem & 0x1f, $pc + 1 & 0b00011111),
    $op < 7;
  return $acc;
  }

for ( map s/\s+\z/\n/r, do { local $/ = ''; <DATA> } )
  {
#	print;
  assemble( $_ );
  print '*' x 20," STP with acc = ", run(), "$program\n\n";
  }

__DATA__
        LDA   x ; first example program 2 + 2
        ADD   y
        STP
x:      2
y:      2

loop:   LDA   a ; second example program 7 * 8
        BRZ   end
        SUB   one
        STA   a
        LDA   prod
        ADD   b
        STA   prod
        JMP   loop
end:    LDA   prod
        STP
a:      7
b:      8
prod:   0
one:    1

loop:   LDA   count ; Fibonacci
        BRZ   end
        SUB   one
        STA   count
        LDA   a
        ADD   b
        STA   temp
        LDA   b
        STA   a
        LDA   temp
        STA   b
        JMP   loop
end:    LDA   b
        STP
one:          1
a:            1
b:            1
temp:         0
count:        8

start:  LDA   load    ; linked list
        ADD   car     ; head of list
        STA   ldcar
        ADD   one
        STA   ldcdr   ; next CONS cell
ldcar:  NOP
        STA   value
ldcdr:  NOP
        BRZ   done    ; 0 stands for NIL
        STA   car
        JMP   start
done:   LDA   value   ; CAR of last CONS
        STP
load:   LDA   0
value:        0
car:          begin
one:          1
                      ; order of CONS cells
                      ; in memory
                      ; does not matter
              6
              0       ; 0 stands for NIL
              2       ; (CADR ls)
              26      ; (CDDR ls) -- etc.
              5
              20
              3
              30
begin:        1       ; value of (CAR ls)
              22      ; points to (CDR ls)
              4
              24

p:            0       ; NOP in first round Prisoner's Dilemma
c:            0
start:  STP           ; wait for p's move
pmove:  NOP
        LDA   pmove
        SUB   cmove
        BRZ   same
        LDA   pmove
        STA   cmove   ; tit for tat
        BRZ   cdeft
        LDA   c       ; p defected, c did not
        ADD   three
        STA   c
        JMP   start
cdeft:  LDA   p
        ADD   three
        STA   p
        JMP   start
same:   LDA   pmove
        STA   cmove   ; tit for tat
        LDA   p
        ADD   one
        ADD   pmove
        STA   p
        LDA   c
        ADD   one
        ADD   pmove
        STA   c
        JMP   start
cmove:        0       ; co-operate initially
one:          1
three:        3
