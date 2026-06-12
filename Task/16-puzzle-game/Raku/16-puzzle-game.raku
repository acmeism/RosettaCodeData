# 20210914 Raku programming solution

my (\easy,\hard) = 1,4 ; my @n = ^16; my \level = $ = easy ; my \moves = $ = 0;

sub hasWon { @n eq ^16 }

sub setDiff($level) {
   say "\nTarget is ", ( moves = $level == hard ?? 12 !! 3 ).Str, " moves.";
   for ^moves {
      my \s = (^4).roll;
      @n[ ( [ s, s+4 ... s+12 ] , [ s*4 .. s*4+3 ] ).roll ] .= rotate ;
      redo if hasWon
   }
}

sub drawGrid {
   say "\n     U1   U2   U3   U4";
   say "   ╔════╦════╦════╦════╗";
   printf  "L1 ║ %2d ║ %2d ║ %2d ║ %2d ║ R1\n", @n[0..3];
   say "   ╠════╬════╬════╬════╣";
   printf  "L2 ║ %2d ║ %2d ║ %2d ║ %2d ║ R2\n", @n[4..7];
   say "   ╠════╬════╬════╬════╣";
   printf  "L3 ║ %2d ║ %2d ║ %2d ║ %2d ║ R3\n", @n[8..11];
   say "   ╠════╬════╬════╬════╣";
   printf  "L4 ║ %2d ║ %2d ║ %2d ║ %2d ║ R4\n", @n[12..15];
   say "   ╚════╩════╩════╩════╝";
   say "     D1   D2   D3   D4\n"
}

sub init {
   loop {
      print "Enter difficulty level easy or hard E/H : ";
      given $*IN.get.uc {
         when 'E'|'H' { level = $_ eq 'H' ?? hard !! easy ;  last  }
         default      { say "Invalid response, try again." }
      }
   }
   setDiff(level);
   moves = 0;
}

init;

loop {
   drawGrid;
   if hasWon() {
      say "Congratulations, you have won the game in {moves} moves.\n" and exit
   }
   say "When entering moves, you can also enter Q to quit or S to start again.";
   say "\nMoves so far = {moves}\n";
   print "Enter move : " ;
   given $*IN.get.uc {
      my \c = .substr(*-1).ord - 49 ; moves++ ;
      when 'D1'|'D2'|'D3'|'D4' { @n[ (12,8,4,0) >>+>> c   ] .= rotate }
      when 'L1'|'L2'|'L3'|'L4' { @n[ (0,1,2,3)  >>+>> 4*c ] .= rotate }
      when 'U1'|'U2'|'U3'|'U4' { @n[ (0,4,8,12) >>+>> c   ] .= rotate }
      when 'R1'|'R2'|'R3'|'R4' { @n[ (3,2,1,0)  >>+>> 4*c ] .= rotate }
      when 'Q'                 { exit }
      when 'S'                 { init }
      default                  { say "\nInvalid move, try again." and moves-- }
   }
}
