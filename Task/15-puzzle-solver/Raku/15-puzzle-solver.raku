# 20210623 Raku programming solution vCSMt9hkak0

constant \Nr = <3 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3>;
constant \Nc = <3 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2>;

my ($n,$m) = 0,0 ;
my @N0 is default(0);
my @N3 is default(0);
my @N4 is default(0);
my @N2 is default(0);

sub fY() {
   if @N2[$n] == 0x123456789abcdef0 {
      say "Solution found in ", $n, " moves: ", [~] @N3[1..$n] and exit();
   }
   return @N4[$n] ≤ $m ?? fN() !! False ;
}

sub fN() {
   sub common { ++$n; return True if fY(); --$n }
   if (@N3[$n] ne 'u' && @N0[$n] div 4 < 3) { fI() and common }
   if (@N3[$n] ne 'd' && @N0[$n] div 4 > 0) { fG() and common }
   if (@N3[$n] ne 'l' && @N0[$n]  %  4 < 3) { fE() and common }
   if (@N3[$n] ne 'r' && @N0[$n]  %  4 > 0) { fL() and common }
   return False;
}

sub fI() {
   my \g = (11-@N0[$n])*4;
   my \a = @N2[$n] +& (15 +< g);
   @N0[$n+1]=@N0[$n]+4;
   @N2[$n+1]=@N2[$n]-a+(a+<16);
   @N3[$n+1]='d';
   @N4[$n+1]=@N4[$n]+(Nr[a+>g] ≤ @N0[$n] div 4 ?? 0 !! 1);
}

sub fG() {
   my \g = (19-@N0[$n])*4;
   my \a = @N2[$n] +& (15 +< g);
   @N0[$n+1]=@N0[$n]-4;
   @N2[$n+1]=@N2[$n]-a+(a+>16);
   @N3[$n+1]='u';
   @N4[$n+1]=@N4[$n]+(Nr[a+>g] ≥ @N0[$n] div 4 ?? 0 !! 1);
}

sub fE() {
   my \g = (14-@N0[$n])*4;
   my \a = @N2[$n] +& (15 +< g);
   @N0[$n+1]=@N0[$n]+1;
   @N2[$n+1]=@N2[$n]-a+(a+<4);
   @N3[$n+1]='r';
   @N4[$n+1]=@N4[$n]+(Nc[a+>g] ≤ @N0[$n]%4 ?? 0 !! 1);
}

sub fL(){
   my \g = (16-@N0[$n])*4;
   my \a = @N2[$n] +& (15 +< g);
   @N0[$n+1]=@N0[$n]-1;
   @N2[$n+1]=@N2[$n]-a+(a+>4);
   @N3[$n+1]='l';
   @N4[$n+1]=@N4[$n]+(Nc[a+>g] ≥ @N0[$n]%4 ?? 0 !! 1);
}

sub fifteenSolver(\n, \g){@N0[0]=n; @N2[0]=g}


fifteenSolver(8,0xfe169b4c0a73d852);
loop { fY() or ++$m }
