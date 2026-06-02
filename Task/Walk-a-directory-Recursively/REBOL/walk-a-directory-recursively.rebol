Rebol [
    title: "Rosetta code: Walk a directory/Recursively"
    file:  %Walk_a_directory-Recursively.r3
    url:   https://rosettacode.org/wiki/Walk_a_directory-Recursively
]

walk: function [
    {Walk a directory tree recursively, evaluating body for each file.
    The word is set to the absolute file path before each evaluation.
    Use the /where refinement to filter files by a parse rule.}
    'word               "receives the absolute path of each visited file"
    directory [file!]   "root directory to start from"
    body      [block!]  "block evaluated for each matched file"
    /where
        rules [block!]  "parse rules defining which filenames to include"
][
    unless exists? directory: to-real-file directory [exit]
    foreach file read directory [
        either dir? file: rejoin [directory file] [
            walk/:where 'item file body rules      ;; recurse into subdirectory
        ][
            if where [ unless parse/case file rules [ continue ] ]
            set :word file                         ;; bind word to current file path
            try body
        ]
    ]
]

walk/where item %../ [ print item ] [any [thru #"/"] "Audio" thru ".r3" end]
