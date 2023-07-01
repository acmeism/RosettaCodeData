#!/usr/bin/env wish
# Biorhythm calculator
set today [clock format [clock seconds] -format %Y-%m-%d ]
proc main [list birthday [list target $today]] {
  set day [days-between $birthday $target]

  array set cycles {
    Physical  {23 red}
    Emotional {28 green}
    Mental    {33 blue}
  }

  set pi [expr atan2(0,-1)]

  canvas .c -width 306 -height 350 -bg black
  .c create rectangle 4 49 306 251 -outline grey
  .c create line 5 150 305 150 -fill grey
  .c create line 145 50 145 250 -fill cyan
  .c create text 145 15 -text "$target" -fill cyan
  .c create text 145 30 -text "(Day $day)" -fill cyan
  set ly 305
  foreach {name data} [array get cycles] {
    lassign $data length color
    .c create text 60 $ly -anchor nw -text $name -fill $color
    set pos [expr $day % $length]
    for {set dd -14} {$dd <= 16} {incr dd} {
      set d [expr $pos + $dd]
      set x [expr 145 + 10 * $dd]
      .c create line $x 145 $x 155 -fill grey
      set v [expr sin(2*$pi*$d/$length)]
      set y [expr 150 - 100 * $v]
      if {$dd == 0} {
        .c create text 10 $ly -anchor nw \
            -text "[format %+04.1f%% [expr $v * 100]]" -fill $color
      }
      if [info exists ox] {
        .c create line $ox $oy $x $y -fill $color
      }
      set ox $x
      set oy $y
    }
    unset ox oy
    set ly [expr $ly - 25]
  }
  pack .c
}

proc days-between {from to} {
  expr int([rd $to] - [rd $from])
}

# parse an (ISO-formatted) date into a day number
proc rd {date} {
  lassign [scan $date %d-%d-%d] year month day
  set elapsed [expr $year - 1]
  expr {$elapsed * 365 +
       floor($elapsed/4) -
       floor($elapsed/100) +
       floor($elapsed/400) +
       floor( (367*$month-362)/12 ) +
       ($month < 3 ? 0 : ([is-leap $year] ? -1 : -2)) +
       $day}
}

proc is-leap {year} {
  expr {$year % 4 == 0 && ($year % 100 || $year % 400 == 0)}
}

main {*}$argv
