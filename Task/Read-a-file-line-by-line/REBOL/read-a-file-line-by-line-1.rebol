Rebol [
    title: "Rosetta code: Read a file line by line"
    file:  %Read_a_file_line_by_line.r3
    url:   https://rosettacode.org/wiki/Read_a_file_line_by_line
]

sys/make-scheme [
    name:    'lines
    purpose: "Scheme for reading a text file line by line without loading it all into memory"

    update-lines: function [
        "Read next chunk and extract complete lines into queue"
        state [object!]
    ][
        until [
            if empty? tmp: read/part state/file 4096 [ exit ] ;; EOF -> stop
            parse append state/buffer tmp [
                some [
                    copy line to LF (
                        if CR = last line [take/last line]    ;; strip CR from CRLF
                        append state/lines to string! line
                    ) skip                                    ;; skip LF
                ]
                pos: to end                                   ;; remainder after last LF
            ]
        ]
        truncate pos                    ;; drop processed data, keep tail remainder
    ]
    actor: [
        open: func [port [port!]][
            port/state: context [
                path: as file! ajoin [
                    select port/spec 'path
                    select port/spec 'target
                ]
                file: open/read path    ;; open underlying binary file
                lines: copy []          ;; queue of decoded lines
                buffer: #{}             ;; binary read-ahead buffer
            ]
            port
        ]
        open?: func[port [port!]][
            all [
                object? port/state
                open? port/state/file
            ]
        ]
        close: func[port [port!]][
            if open? port [
                close port/state/file
            ]
            port/state: none
            port
        ]
        read: func[port][
            unless open? port [return none]
            if empty? port/state/lines [
                update-lines port/state  ;; refill line queue from file
            ]
            take port/state/lines        ;; return next line or none at EOF
        ]
    ]
]

;; Usage example:

lines: open lines:Read_a_file_line_by_line.r3
while [ line: read lines ][ probe line ]
close lines
