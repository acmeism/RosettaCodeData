def toBern2(a):
 [a[0], a[0] + a[1] / 2,
  a[0] + a[1] + a[2]];

# uses de Casteljau's algorithm
def evalBern2($b; $t):
  (1 - $t) as $s
  | ($s * $b[0] + $t * $b[1]) as $b01
  | ($s * $b[1] + $t * $b[2]) as $b12
  | $s * $b01 + $t * $b12;

def toBern3(a):
  [a[0],
   a[0] + a[1] / 3,
   a[0] + a[1] * 2/3 + a[2] / 3,
   a[0] + a[1] + a[2] + a[3] ];

# uses de Casteljau's algorithm
def evalBern3($b; $t):
  (1 - $t) as $s
  | ($s * $b[0] + $t * $b[1]) as $b01
  | ($s * $b[1] + $t * $b[2]) as $b12
  | ($s * $b[2] + $t * $b[3]) as $b23
  | ($s * $b01  + $t * $b12) as $b012
  | ($s * $b12  + $t * $b23) as $b123
  | $s * $b012 + $t * $b123;

def bern2to3(q):
  [q[0],
   q[0] / 3   + q[1] * 2/3,
   q[1] * 2/3 + q[2] / 3,
   q[2]] ;

def pm: [1, 0, 0];
def qm: [1, 2, 3];
def rm: [1, 2, 3, 4];

def pb2: toBern2(pm);
def qb2: toBern2(qm);

"Subprogram(1) examples:",

"mono\(pm) --> bern\(pb2)",
"mono\(qm) --> bern\(qb2)",

"\nSubprogram(2) examples:",
({x: 0.25}
 | .y = evalBern2(pb2; .x)
 | "p(\(.x)) = \(.y)" ),

({x: 7.5}
 | .y = evalBern2(pb2; .x)
 | "p(\(.x)) = \(.y)" ),

({x: 0.25}
 | .y = evalBern2(qb2; .x)
 | "q(\(.x)) = \(.y)" ),

({x: 7.5}
 | .y = evalBern2(qb2; .x)
 | "q(\(.x)) = \(.y)" ),

"\nSubprogram(3) examples:",
({}
 | .pm0 = pm + [0]
 | .qm0 = qm + [0]
 | .pb3 = toBern3(.pm0)
 | .qb3 = toBern3(.qm0)
 | .rb3 = toBern3(rm)
 | "mono\(.pm0) --> bern\(.pb3)",
   "mono\(.qm0) --> bern\(.qb3)",
   "mono\(rm) --> bern\(.rb3)",

   "\nSubprogram(4) examples:",
   ( .x = 0.25
     | .y = evalBern3(.pb3; .x)
     | "p(\(.x)) = \(.y)" ),
   ( .x = 7.5
     | .y = evalBern3(.pb3; .x)
     | "p(\(.x)) = \(.y)" ),
   ( .x = 0.25
     | .y = evalBern3(.qb3; .x)
     | "q(\(.x)) = \(.y)" ),
   ( .x = 7.5
     | .y = evalBern3(.qb3; .x)
     | "q(\(.x)) = \(.y)" ),
   ( .x = 0.25
     | .y = evalBern3(.rb3; .x)
     | "r(\(.x)) = \(.y)" ),
   ( .x = 7.5
     | .y = evalBern3(.rb3; .x)
     | "r(\(.x)) = \(.y)" ),

   "\nSubprogram(5) examples:",
    "mono\(pb2) --> bern\( bern2to3(pb2))",
    "mono\(qb2) --> bern\( bern2to3(qb2) )"
)
