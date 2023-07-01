def multipleRegression(y; x):
    (y|transpose) as $cy
    | (x|transpose) as $cx
    | multiply( multiply( multiply(x;$cx)|inverse; x); $cy)
    | transpose[0];

def ys: [
    [ [1, 2, 3, 4, 5] ],
    [ [3, 4, 5] ],
    [ [52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
                  63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46] ]
];

def a:
  [1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83];

def xs:[
    [ [2, 1, 3, 4, 5] ],
    [ [1, 2, 1], [1, 1, 2] ],
    [ [range(0;a|length) | 1], a, (a|map(.*.))]
];

range(0; ys|length) as $i
| multipleRegression(ys[$i]; xs[$i])
