include c:\cxpl\codes;          \intrinsic 'code' declarations
int     Door(100);              \You have 100 doors in a row
define  Open, Closed;
int     D, Pass, Step;

[for D:= 0 to 100-1 do          \that are all initially closed
        Door(D):= Closed;

Step:= 1;                       \The first time through, you visit every door
for Pass:= 1 to 100 do          \You make 100 passes by the doors
        [D:= Step-1;
        repeat  \if the door is closed, you open it; if it is open, you close it
                if Door(D)=Closed then Door(D):= Open else Door(D):= Closed;
                D:= D+Step;
        until   D>=100;
        Step:= Step+1;          \The second time you only visit every 2nd door
        ];                      \The third time, every 3rd door
                                \until you only visit the 100th door
\What state are the doors in after the last pass?
Text(0, "Open: ");              \Which are open?
for D:= 0 to 100-1 do
        if Door(D)=Open then [IntOut(0, D+1); ChOut(0,^ )];
CrLf(0);

Text(0, "Closed: ");            \Which are closed?
for D:= 0 to 100-1 do
        if Door(D)=Closed then [IntOut(0, D+1); ChOut(0,^ )];
CrLf(0);

\Optimized: The only doors that remain open are those that are perfect squares
Text(0, "Open: ");
D:= 1;
repeat  IntOut(0, D*D); ChOut(0,^ );
        D:= D+1;
until   D*D>100;
CrLf(0);
]
