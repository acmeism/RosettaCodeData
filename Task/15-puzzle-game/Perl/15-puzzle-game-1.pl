use strict;
use warnings;

use Getopt::Long;
use List::Util 1.29 qw(shuffle pairmap first all);
use Tk;
    # 5 options                                 1 label text
my ($verbose,@fixed,$nocolor,$charsize,$extreme,$solvability);

unless (GetOptions (
                     'verbose!' => \$verbose,
                     'tiles|positions=i{16}' => \@fixed,
                     'nocolor' => \$nocolor,
                     'charsize|size|c|s=i' => \$charsize,
                     'extreme|x|perl' => \$extreme,
                    )
        ) { die "invalid arguments!";}

@fixed = &check_req_pos(@fixed) if @fixed;

my $mw = Tk::MainWindow->new(-bg=>'black',-title=>'Giuoco del 15');

if ($nocolor){ $mw->optionAdd( '*Button.background',   'ivory' );}

$mw->optionAdd('*Button.font', 'Courier '.($charsize or 16).' bold' );
$mw->bind('<Control-s>', sub{#&init_board;
                             &shuffle_board});

my $top_frame = $mw->Frame( -borderwidth => 2, -relief => 'groove',
                           )->pack(-expand => 1, -fill => 'both');

$top_frame->Label( -textvariable=>\$solvability,
                  )->pack(-expand => 1, -fill => 'both');

my $game_frame = $mw->Frame(  -background=>'saddlebrown',
                              -borderwidth => 10, -relief => 'groove',
                            )->pack(-expand => 1, -fill => 'both');

# set victory conditions in pairs of coordinates
my @vic_cond =  pairmap {
       [$a,$b]
    } qw(0 0 0 1 0 2 0 3
         1 0 1 1 1 2 1 3
         2 0 2 1 2 2 2 3
         3 0 3 1 3 2 3 3);

my $board = [];

my $victorious = 0;

&init_board;

if ( $extreme ){ &extreme_perl}

&shuffle_board;

MainLoop;

################################################################################
sub init_board{
  # tiles from 1 to 15
  for (0..14){
     $$board[$_]={
          btn=>$game_frame->Button(
                            -text => $_+1,
                            -relief => 'raised',
                            -borderwidth => 3,
                            -height => 2,
                            -width =>  4,
                                  -background=>$nocolor?'ivory':'gold1',
                                  -activebackground => $nocolor?'ivory':'gold1',
                                  -foreground=> $nocolor?'black':'DarkRed',
                                  -activeforeground=>$nocolor?'black':'DarkRed'
          ),
          name => $_+1,     # x and y set by shuffle_board
     };
     if (($_+1) =~ /^(2|4|5|7|10|12|13|15)$/ and !$nocolor){
         $$board[$_]{btn}->configure(
                                  -background=>'DarkRed',
                                  -activebackground => 'DarkRed',
                                  -foreground=> 'gold1',
                                  -activeforeground=>'gold1'
         );
     }
   }
   # empty tile
   $$board[15]={
          btn=>$game_frame->Button(
                            -relief => 'sunken',
                            -borderwidth => 3,
                            -background => 'lavender',
                            -height => 2,
                            -width =>  4,
          ),
          name => 16,      # x and y set by shuffle_board
     };
}
################################################################################
sub shuffle_board{
    if ($victorious){
        $victorious=0;
        &init_board;
    }
    if (@fixed){
          my $index = 0;

          foreach my $tile(@$board[@fixed]){
                  my $xy = $vic_cond[$index];
                  ($$tile{x},$$tile{y}) = @$xy;
                  $$tile{btn}->grid(-row=>$$xy[0], -column=> $$xy[1]);
                  $$tile{btn}->configure(-command =>[\&move,$$xy[0],$$xy[1]]);
                  $index++;
          }
          undef @fixed;
    }
    else{
        my @valid = shuffle (0..15);
        foreach my $tile ( @$board ){
            my $xy = $vic_cond[shift @valid];
            ($$tile{x},$$tile{y}) = @$xy;
            $$tile{btn}->grid(-row=>$$xy[0], -column=> $$xy[1]);
            $$tile{btn}->configure(-command => [ \&move, $$xy[0], $$xy[1] ]);
        }
    }
    my @appear =  map {$_->{name}==16?'X':$_->{name}}
                  sort{$$a{x}<=>$$b{x}||$$a{y}<=>$$b{y}}@$board;
    print "\n".('-' x 57)."\n".
          "Appearence of the board:\n[@appear]\n".
          ('-' x 57)."\n".
          "current\tfollowers\t               less than current\n".
          ('-' x 57)."\n" if $verbose;
    # remove the, from now on inutile, 'X' for the empty space
    @appear = grep{$_ ne 'X'} @appear;
    my $permutation;
    foreach my $num (0..$#appear){
        last if $num == $#appear;
         my $perm;
          $perm += grep {$_ < $appear[$num]} @appear[$num+1..$#appear];
          if ($verbose){
            print "[$appear[$num]]\t@appear[$num+1..$#appear]".
            (" " x (37 - length "@appear[$num+1..$#appear]")).
            "\t   $perm ".($num == $#appear  - 1 ? '=' : '+')."\n";
          }
          $permutation+=$perm;
    }
    print +(' ' x 50)."----\n" if $verbose;
    if ($permutation % 2){
        print "Impossible game with odd permutations!".(' ' x 13).
              "$permutation\n"if $verbose;
        $solvability = "Impossible game with odd permutations [$permutation]\n".
                        "(ctrl-s to shuffle)".
                        (($verbose or $extreme) ? '' :
                           " run with --verbose to see more info");
        return;
    }
    # 105 is the max permutation
    my $diff =  $permutation == 0 ? 'SOLVED' :
                $permutation < 35 ? 'EASY  ' :
                $permutation < 70 ? 'MEDIUM' : 'HARD  ';
    print "$diff game with even permutations".(' ' x 17).
          "$permutation\n" if $verbose;
    $solvability = "$diff game with permutation parity of [$permutation]\n".
                    "(ctrl-s to shuffle)";
}
################################################################################
sub move{
    # original x and y
    my ($ox, $oy) = @_;
    my $self = first{$_->{x} == $ox and $_->{y} == $oy} @$board;
    return if $$self{name}==16;
    # check if one in n,s,e,o is the empty one
    my $empty = first {$_->{name} == 16 and
                          ( ($_->{x}==$ox-1 and $_->{y}==$oy) or
                            ($_->{x}==$ox+1 and $_->{y}==$oy) or
                            ($_->{x}==$ox and $_->{y}==$oy-1) or
                            ($_->{x}==$ox and $_->{y}==$oy+1)
                           )
                      } @$board;
    return unless $empty;
    # empty x and y
    my ($ex,$ey) = ($$empty{x},$$empty{y});
    # reconfigure emtpy tile
    $$empty{btn}->grid(-row => $ox, -column => $oy);
    $$empty{x}=$ox;    $$empty{y}=$oy;
    # reconfigure pressed tile
    $$self{btn}->grid(-row => $ex, -column => $ey);
    $$self{btn}->configure(-command => [ \&move, $ex, $ey ]);
    $$self{x}=$ex;    $$self{y}=$ey;
    # check for victory if the empty one is at the bottom rigth tile (3,3)
    &check_win if $$empty{x} == 3 and $$empty{y} == 3;
}
################################################################################
sub check_win{
     foreach my $pos (0..$#$board){
        return unless ( $$board[$pos]->{'x'} == $vic_cond[$pos]->[0] and
                        $$board[$pos]->{'y'} == $vic_cond[$pos]->[1]);
     }
     # victory!
     $victorious = 1;
     my @text =  ('Dis','ci','pu','lus','15th','','','at',
                  'P','e','r','l','M','o','n','ks*');
     foreach my $tile(@$board){
            $$tile{btn}->configure( -text=> shift @text,
                                    -command=>sub{return});
            $mw->update;
            sleep 1;
     }
}
################################################################################
sub check_req_pos{
    my @wanted = @_;
    # fix @wanted: seems GetOptions does not die if more elements are passed
    @wanted = @wanted[0..15];
    my @check = (1..16);
    unless ( all {$_ == shift @check} sort {$a<=>$b} @wanted ){
        die "tiles must be from 1 to 16 (empty tile)\nyou passed [@wanted]\n";
    }
    return map {$_-1} @wanted;
}
################################################################################
sub extreme_perl {
  $verbose = 0;
  $mw->optionAdd('*font', 'Courier 20 bold');
  my @extreme = (
    'if $0',                               #1
    "\$_=\n()=\n\"foo\"=~/o/g",            #2
    "use warnings;\n\$^W ?\nint((length\n'Discipulus')/3)\n:'15'",   #3
    "length \$1\nif \$^X=~\n\/(?:\\W)(\\w*)\n(?:\\.exe)\$\/", #4
    "use Config;\n\$Config{baserev}",                   #5.
    "(split '',\nvec('JAPH'\n,1,8))[0]",       #6
    "scalar map\n{ord(\$_)=~/1/g}\nqw(p e r l)", #7
    "\$_ = () =\n'J A P H'\n=~\/\\b\/g",   # 8
    "eval join '+',\nsplit '',\n(substr\n'12345',3,2)",  #9
    'printf \'%b\',2',                     #10
    "int(((1+sqrt(5))\n/ 2)** 7 /\nsqrt(5)+0.5)-2",    #11
    "split '',\nunpack('V',\n01234567))\n[6,4]",  # 12
    'J','A','P','H'                               # 13..16
  );
  foreach (0..15){
      $$board[$_]{btn}->configure(-text=> $extreme[$_],
                                 -height => 8,
                                  -width =>  16, ) if $extreme[$_];

  }
  @fixed = qw(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15);
  $mw->after(5000,\&shuffle_board);#
}
