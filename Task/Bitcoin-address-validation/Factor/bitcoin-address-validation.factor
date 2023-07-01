USING: byte-arrays checksums checksums.sha io.binary kernel math
math.parser sequences ;
IN: rosetta-code.bitcoin.validation

CONSTANT: ALPHABET "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

: base58>bigint ( str -- n )
  [ ALPHABET index ]
  [ [ 58 * ] [ + ] bi* ] map-reduce ;

: base58> ( str -- bytes ) base58>bigint 25 >be ;

: btc-checksum ( bytes -- checksum-bytes )
  21 head 2 [ sha-256 checksum-bytes ] times 4 head ;

: btc-valid? ( str -- ? ) base58> [ btc-checksum ] [ 4 tail* ] bi = ;
