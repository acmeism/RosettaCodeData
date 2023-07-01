def arrays: [
    [ [ 1,  2,  3],
      [ 4,  1,  6],
      [ 7,  8,  9] ],

    [ [ 2, -1,  0 ],
      [-1,  2, -1 ],
      [ 0, -1,  2 ] ],

    [ [ -1, -2, 3, 2 ],
      [ -4, -1, 6, 2 ],
      [  7, -8, 9, 1 ],
      [  1, -2, 1, 3 ] ]
];

def task:
  arrays[]
  | "Original:",
     mprint(1),
    "\nInverse:",
    (inverse|mprint(6)),
    ""
;

task
