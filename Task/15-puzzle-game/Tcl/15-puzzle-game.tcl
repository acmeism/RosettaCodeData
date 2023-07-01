 # 15puzzle_21.tcl - HaJo Gurt -  2016-02-16
 # http://wiki.tcl.tk/14403

 #: 15-Puzzle - with grid, buttons and colors

  package require Tk

  set progVersion "15-Puzzle v0.21";        # 2016-02-20

  global Msg Moves PuzzNr GoalNr
  set Msg    " "
  set Moves  -1
  set PuzzNr  0
  set GoalNr  0

  set Keys   { 11 12 13 14  21 22 23 24  31 32 33 34  41 42 43 44 }

  set Puzz_T {  T  h  e  F   i  f  t  e   e  n  P  u   z  z  l  e }; # Title
  set Goal_T {  x  x  x  F   i  f  t  e   e  n  x  x   x  x  x  x }; # Title-highlight

  set Puzz_0 {  E  G  P  N   C  A  F  B   D  L  H  I   O  K  M  _ }; # -  / 116
  set Puzz_1 {  C  A  F  B   E  G  P  N   D  L  H  I   O  K  M  _ }; # E  / 156 from Tk-demo
  set Puzz_2 {  E  O  N  K   M  I  _  G   B  H  L  P   C  F  A  D }; # L  / 139
  set Puzz_3 {  P  G  M  _   E  L  N  D   O  K  H  I   B  C  F  A }; # EK / 146

  set Goal_0 {  A  B  C  D   E  F  G  H   I  K  L  M   N  O  P  _ }; # Rows LTR   / 1:E : 108
  set Goal_1 {  A  E  I  N   B  F  K  O   C  G  L  P   D  H  M  _ }; # Cols forw. / 1:M : 114

  set Puzz $Puzz_T
  set Goal $Goal_T

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---

  proc Move {k} {
  # find the key with the empty tile:
    set e -1
    foreach p $::Keys  {
      set t [.key$p cget -text]
      if { $t eq "_" } { set e $p }
    }
    if {$e  <  0} {return 0};   # no key with empty tile found
    if {$k == $e} {return 0};   # click was on the empty tile

    set t [.key$k cget -text]
    .key$e config -text $t
    .key$k config -text "_";
    return 1
  }

  proc Check {} {
    set ok 0
    set i  0
    foreach k $::Keys {
      set t [.key$k cget -text]
      set g [lindex $::Goal $i]
      incr i

      .key$k config -background white
      if { $t eq $g  } { .key$k config -background lightgreen; incr ok }
      if { $t eq "_" } { .key$k config -background gray }
    }

    # Solved:
    update
    if { $ok > 15 && $::Moves > 0} {
      foreach k $::Keys  {
        .key$k flash; bell;
      }
    }
  }

  proc Click {k} {
    set ::Msg ""
    set val [.key$k cget -text]
    set ok [Move $k]

    incr ::Moves $ok
    wm title . "$::Moves moves"
    Check
  }

  proc ShowKeys {} {
    set i 0
    foreach k $::Keys  {
      set t [lindex $::Puzz $i]
      incr i
      .key$k config -text $t -background white;
    }
    Check
  }

  proc NewGame {N} {
    global Msg Moves PuzzNr GoalNr

    incr  PuzzNr $N
    if { $PuzzNr > 3} { set PuzzNr 0 }

                         set ::Goal $::Goal_0;
    if { $GoalNr == 1} { set ::Goal $::Goal_1; }

    if { $PuzzNr == 0} { set ::Puzz $::Puzz_0; }
    if { $PuzzNr == 1} { set ::Puzz $::Puzz_1; }
    if { $PuzzNr == 2} { set ::Puzz $::Puzz_2; }
    if { $PuzzNr == 3} { set ::Puzz $::Puzz_3; }

                  set Msg "Try again"
    if { $N>0 } { set Msg "New game" }

    set Moves 0
    ShowKeys
    wm title . "$Msg "
  }

#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---

  button .reset   -text "Restart"  -fg blue -command {NewGame  0}
  button .newGame -text "New Game" -fg red  -command {NewGame +1}

  foreach k $::Keys {
    button .key$k -text "$k" -width 4 -command "Click $k"
  }

  grid .newGame x .reset x -sticky nsew

  grid .key11 .key12 .key13 .key14  -sticky nsew  -padx 2 -pady 2
  grid .key21 .key22 .key23 .key24  -sticky nsew  -padx 2 -pady 2
  grid .key31 .key32 .key33 .key34  -sticky nsew  -padx 2 -pady 2
  grid .key41 .key42 .key43 .key44  -sticky nsew  -padx 2 -pady 2

  grid configure .newGame .reset  -columnspan 2 -padx 4

  ShowKeys; Check
  wm title . $progVersion
  focus -force .
  wm resizable . 0 0

# For some more versions, see:  http://wiki.tcl.tk/15067 : Classic 15 Puzzle and http://wiki.tcl.tk/15085 : N-Puzzle
