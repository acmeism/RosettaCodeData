>>> for n in (254, 255, 256, 257, -2+(1<<16), -1+(1<<16), 1<<16, 1+(1<<16), 0x200000, 0x1fffff ):
    print('int: %7i bin: %26s vlq: %35s vlq->int: %7i' % (n, tobits(n,_pad=True), tovlq(n), toint(tovlq(n))))


int:     254 bin:                   11111110 vlq:                   00000001_11111110 vlq->int:     254
int:     255 bin:                   11111111 vlq:                   00000001_11111111 vlq->int:     255
int:     256 bin:          00000001_00000000 vlq:                   00000010_10000000 vlq->int:     256
int:     257 bin:          00000001_00000001 vlq:                   00000010_10000001 vlq->int:     257
int:   65534 bin:          11111111_11111110 vlq:          00000011_11111111_11111110 vlq->int:   65534
int:   65535 bin:          11111111_11111111 vlq:          00000011_11111111_11111111 vlq->int:   65535
int:   65536 bin: 00000001_00000000_00000000 vlq:          00000100_10000000_10000000 vlq->int:   65536
int:   65537 bin: 00000001_00000000_00000001 vlq:          00000100_10000000_10000001 vlq->int:   65537
int: 2097152 bin: 00100000_00000000_00000000 vlq: 00000001_10000000_10000000_10000000 vlq->int: 2097152
int: 2097151 bin: 00011111_11111111_11111111 vlq:          01111111_11111111_11111111 vlq->int: 2097151
>>> vlqsend(tovlq(0x200000))
Sent byte   0: 0x80
Sent byte   1: 0x80
Sent byte   2: 0x80
Sent byte   3: 0x01
>>> vlqsend(tovlq(0x1fffff))
Sent byte   0: 0xff
Sent byte   1: 0xff
Sent byte   2: 0x7f
>>>
