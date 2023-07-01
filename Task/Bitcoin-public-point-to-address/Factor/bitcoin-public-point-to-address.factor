USING: checksums checksums.ripemd checksums.sha io.binary kernel
math sequences ;
IN: rosetta-code.bitcoin.point-address

CONSTANT: ALPHABET "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

: btc-checksum ( bytes -- checksum-bytes )
    2 [ sha-256 checksum-bytes ] times 4 head ;

: bigint>base58 ( n -- str )
    33 [ 58 /mod ALPHABET nth ] "" replicate-as reverse nip ;

: >base58 ( bytes -- str )
    be> bigint>base58 ;

: point>address ( X Y -- address )
    [ 32 >be ] bi@ append
    0x4 prefix
    sha-256 checksum-bytes
    ripemd-160 checksum-bytes
    dup 0 prefix btc-checksum
    append 0 prefix >base58 ;
