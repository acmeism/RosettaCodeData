USING: checksums checksums.sha fry grouping io
io.encodings.binary io.files kernel make math math.parser
namespaces sequences ;

: each-block ( ... size quot: ( ... block -- ... ) -- ... )
    input-stream get spin (each-stream-block) ; inline

: >sha-256 ( seq -- newseq ) sha-256 checksum-bytes ;

: (hash-read) ( path encoding chunk-size -- )
    '[ _ [ >sha-256 , ] each-block ] with-file-reader ;

! Read a file in chunks as a sequence of sha-256 hashes, so as
! not to store a potentially large file in memory all at once.

: hash-read ( path chunk-size -- seq )
    binary swap [ (hash-read) ] { } make ;

: hash-combine ( seq -- newseq )
    2 <groups>
    [ dup length 1 > [ concat >sha-256 ] [ first ] if ] map ;

: merkle-hash ( path chunk-size -- str )
    hash-read [ dup length 1 = ] [ hash-combine ] until first
    bytes>hex-string ;

"title.png" 1024 merkle-hash print
