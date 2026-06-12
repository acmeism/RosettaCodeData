import std/strutils

type AsciiControlChar {.pure.} = enum NUL, SOH, STX, ETX, EOT, ENQ, ACK, BEL,
                                      BS,  HT,  LF,  VT,  FF,  CR,  SO,  SI,
                                      DLE, DC1, DC2, DC3, DC4, NAK, SYN, ETB,
                                      CAN, EM,  SUB, ESC, FS,  GS,  RS,  US,
                                      SP,  DEL = 0x7F

echo ' ', CR, " = ", ord(CR).toHex(2)
echo DEL, " = ", ord(DEL).toHex(2)
