# degrees to radians
def radians:
  (-1|acos) as $pi | (. * $pi / 180);

def task:
  (-1|acos) as $pi
  |  ($pi / 180) as $degrees
  | "Using radians:",
    "  sin(-pi / 6)     = \( (-$pi / 6)    | sin )",
    "  cos(3 * pi / 4)  = \( (3 * $pi / 4) | cos)",
    "  tan(pi / 3)      = \( ($pi / 3)     | tan)",
    "  asin(-1 / 2)     = \((-1 / 2)       | asin)",
    "  acos(-sqrt(2)/2) = \((-(2|sqrt)/2)  | acos )",
    "  atan(sqrt(3))    = \(      3 | sqrt | atan )",

    "Using degrees:",
    "  sin(-30)         = \((-30 * $degrees) | sin)",
    "  cos(135)         = \((135 * $degrees) | cos)",
    "  tan(60)          = \(( 60 * $degrees) | tan)",
    "  asin(-1 / 2)     = \(        (-1 / 2) | asin / $degrees)",
    "  acos(-sqrt(2)/2) = \( (-(2|sqrt) / 2) | acos / $degrees)",
    "  atan(sqrt(3))    = \( (3 | sqrt)      | atan / $degrees)"
;

task
