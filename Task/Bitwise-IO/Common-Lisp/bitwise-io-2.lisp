BITWISE-I/O> (bitwise-i/o-demo)

Writing string to /tmp/demo.bin in packed 7→8 bits…
“Hello, World.”
String read back matches:
“Hello, World.”
NIL
BITWISE-I/O> (bitwise-i/o-demo :string "It doesn't, however, do UTF-7. So, no ☠ or 🙋")
Writing string to /tmp/demo.bin in packed 7→8 bits…
“It doesn't, however, do UTF-7. So, no ☠ or 🙋”

STRING must contain only ASCII (7-bit) characters;
“It doesn't, however, do UTF-7. So, no ☠ or 🙋”
…contains non-ASCII characters:
 • ☠ — #\SKULL_AND_CROSSBONES
 • 🙋 — #\HAPPY_PERSON_RAISING_ONE_HAND
   [Condition of type SIMPLE-ERROR]


Restarts:
 0: [CONTINUE] Retry assertion with new value for STRING.
 1: [RETRY] Retry SLIME REPL evaluation request.
 2: [*ABORT] Return to SLIME's top level.
 3: [ABORT] abort thread (#<THREAD "repl-thread" RUNNING {10152E8033}>)

⇒ ABORT
