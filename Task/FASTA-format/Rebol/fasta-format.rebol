Rebol [
    title: "Rosetta code: FASTA format"
    file:  %FASTA_format.r3
    url:   https://rosettacode.org/wiki/FASTA_format
]
;; Parses a FASTA-format file in chunks, returning a flat block of [header sequence] pairs.
;; FASTA format alternates between header lines (starting with ">") and sequence data lines.
decode-fasta: function [
    source     [file! url!]  "Source file or URL to read from"
    chunk-size [integer!]    "Number of bytes to read per iteration"
][
    out:  copy []
    port: open/read source  ;; open the source as a streaming read port

    ;; Stream through the file chunk by chunk to avoid loading it all into memory
    while [not empty? data: read/string/part port chunk-size][

        ;; If the previous iteration had an incomplete (trailing) line, prepend it
        ;; to the current chunk so it is parsed as a whole line this time
        if rest [insert data rest]

        parse data [
            any [
                ;; Match everything up to the next newline as one line, then skip the LF
                copy line: to LF skip (
                    either line/1 == #">" [
                        ;; Header line - strip the leading ">" and add a new entry to out;
                        ;; also capture the new 'val' reference for subsequent sequence appends
                        repend out [remove line  val: copy ""]
                    ][
                        ;; Sequence line - append its content to the current entry's value
                        append val line
                    ]
                )
            ]
            ;; Capture any trailing bytes that did not end with LF (incomplete line);
            ;; 'rest' will be prepended to the next chunk at the top of the loop
            copy rest: to end
        ]
    ]
    close port ;; Be nice and close the port when done reading

    ;; The final trailing bytes are part of the last value
    if all [val rest] [append val rest]

    ;; Insert a new-line marker before every other element (i.e. before each header),
    ;; making the flat block easier to read when printed with 'probe'
    new-line/skip out true 2
]

;; Prepare a test file
write %data.fasta
{>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED}

;; Run the decoder on a local FASTA file, reading 10 bytes at a time, and print the result
probe decode-fasta %data.fasta 10
