include c:\cxpl\codes;  \intrinsic 'code' declarations
int     Box(16), Moved;

proc    ShiftTiles(I0, DI);     \Shift tiles, add adjacents, shift again
int     I0, DI;
int     Done, M, N, I;
[Done:= false;
loop    [for M:= 1 to 3 do      \shift all tiles in a single row or column
            [I:= I0;
            for N:= 1 to 3 do
                [if Box(I)=0 & Box(I+DI)#0 then
                        [Box(I):= Box(I+DI);  Box(I+DI):= 0;  Moved:= true];
                I:= I+DI;
                ];
            ];
        if Done then return;
        Done:= true;
        I:= I0;                 \add identical adjacent tiles into a new tile
        for N:= 1 to 3 do
                [if Box(I)=Box(I+DI) & Box(I)#0 then
                        [Box(I):= Box(I)+1;  Box(I+DI):= 0;  Moved:= true];
                I:= I+DI;
                ];
        ];                      \loop back to close any gaps that were opened
];      \ShiftTiles

int     I, J, X, Y, C;
[Clear;
for I:= 0 to 15 do Box(I):= 0;                  \empty the box of tiles
loop    [repeat I:= Ran(16) until Box(I)=0;     \in a random empty location
        Box(I):= if Ran(10) then 1 else 2;      \insert a 2^1=2 or 2^2=4
        for I:= 0 to 15 do                      \show board with its tiles
                [X:= ((I&3)+5)*6;               \get coordinates of tile
                 Y:= I>>2*3+6;
                 Attrib(((Box(I)+1)&7)<<4 + $F);\set color based on tile value
                 for J:= 0 to 2 do              \draw a square (6*8x3*16)
                        [Cursor(X, Y+J);
                        Text(6, "      ");
                        ];
                 if Box(I)#0 then               \box contains a tile
                        [J:= 1;                 \center numbers somewhat
                        if Box(I) <= 9 then J:= 2;
                        if Box(I) <= 3 then J:= 3;
                        Cursor(X+J, Y+1);
                        IntOut(6, 1<<Box(I));
                        ];
                ];
        Moved:= false;                          \a tile must move to continue
        repeat  repeat C:= ChIn(1) until C#0;   \get key scan code, or ASCII
                for I:= 3 downto 0 do           \for all rows or columns
                        [case C of
                          $4B:  ShiftTiles(I*4, 1);     \left arrow
                          $4D:  ShiftTiles(I*4+3, -1);  \right arrow
                          $50:  ShiftTiles(I+12, -4);   \down arrow
                          $48:  ShiftTiles(I, 4);       \up arrow
                          $1B:  [Clear;  exit]          \Esc
                        other   [];                     \ignore all other keys
                        ];
        until   Moved;
        ];
]
