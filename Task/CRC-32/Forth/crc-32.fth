: crc/ ( n -- n ) 8 0 do dup 1 rshift swap 1 and if $edb88320 xor then loop ;

: crcfill   256 0 do i crc/ , loop ;

create crctbl crcfill

: crc+ ( crc n -- crc' ) over xor $ff and  cells crctbl + @  swap 8 rshift xor ;

: crcbuf ( crc str len -- crc ) bounds ?do i c@ crc+ loop ;

$ffffffff s" The quick brown fox jumps over the lazy dog" crcbuf $ffffffff xor hex.  bye   \ $414FA339
