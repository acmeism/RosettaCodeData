#!/usr/bin/nu

let wday = 'fr'

def main [year: int] {
  cal -m -t --week-start $wday --full-year $year
  | group-by month
  | items {|mon cal|
    $'($year)-($mon)-($cal | last | get $wday)'
    | format date "%F\n"
  }
  | str join
}
