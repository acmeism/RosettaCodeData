def addVector($B): [ .[0] + $B[0], .[1] + $B[1]];

def isPerpTo($other): dot($other) == 0;

# Input should be three points [A,B,C] where AB is perpendicular to BC
def rectangleToPolygon:
  . as [$A, $B, $C]
  # check perpendicularity
  | if ([$A,$B] | AB | isPerpTo( [$B,$C] | AB)) then .
    else "rectangleToPolygon: AB is not perpendicular to BC" | error
    end
  | . + [$A | addVector( [$B,$C]|AB ) ] ;

def poly1: [[0, 0], [0, 2], [1, 4], [2, 2], [2, 0]];

def rect1: [ [4, 0], [4, 2], [6, 2] ];
def rect2: [ [1, 0], [1, 2], [9, 2] ];

def task:
  ([rect1, rect2] | map(rectangleToPolygon)) as [$r1, $r2]
  | "poly1 = \(poly1)",
    "r1 = \($r1)",
    "r2 = \($r2)",
     "",
    "poly1 and r1 overlap? \(polygonsOverlap(poly1; $r1))",
    "poly1 and r2 overlap? \(polygonsOverlap(poly1; $r2))"
  ;

task
