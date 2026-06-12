USING: combinators.short-circuit io io.encodings.ascii io.files
kernel math sequences ;

"unixdict.txt" ascii [
    [
        readln dup
        [
            dup
            {
                [ length 5 > ]
                [ [ 3 head-slice ] [ 3 tail-slice* ] bi = ]
            } 1&&
            [ print ] [ drop ] if
        ] when*
    ] loop
] with-file-reader
