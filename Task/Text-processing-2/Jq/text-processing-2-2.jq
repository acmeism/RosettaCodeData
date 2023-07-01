# Given any array, produce an array of [item, count] pairs for each run.
def runs:
  reduce .[] as $item
    ( [];
      if . == [] then [ [ $item, 1] ]
      else  .[length-1] as $last
            | if $last[0] == $item then (.[0:length-1] + [ [$item, $last[1] + 1] ] )
              else . + [[$item, 1]]
              end
      end ) ;

def is_float: test("^[-+]?[0-9]*[.][0-9]*([eE][-+]?[0-9]+)?$");

def is_integral: test("^[-+]?[0-9]+$");

def is_date: test("[12][0-9]{3}-[0-9][0-9]-[0-9][0-9]");
