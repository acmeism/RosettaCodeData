identification division.
program-id. zero-power-zero-program.
data division.
working-storage section.
77  n                         pic 9.
procedure division.
    compute n = 0**0.
    display n upon console.
    stop run.
