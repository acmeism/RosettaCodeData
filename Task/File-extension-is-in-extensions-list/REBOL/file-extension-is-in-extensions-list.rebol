Rebol [
    title: "Rosetta code: File extension is in extensions list"
    file:  %File_extension_is_in_extensions_list.r3
    url:   https://rosettacode.org/wiki/File_extension_is_in_extensions_list
]

known-extensions: map-each ext [
    "zip" "rar" "7z" "gz" "archive" "a##" "tar.bz2"
][
    join "." ext  ;; prefix each extension with a dot
]

known-extension?: function [
    "True if the file's lowercase extension is in the known extensions list."
    file [string! file!]
][
    foreach ext known-extensions [
        if find/match/last file ext [return true]
    ]
    false
]

print [as-yellow "Known extensions:" known-extensions]

foreach file [
    %MyData.a##          %MyData.tar.Gz  %MyData.gzip
    %MyData.7z.backup    %MyData...      %MyData
    %MyData_v1.0.tar.bz2 %MyData_v1.0.bz2
][
    printf [20 "--> "] [file known-extension? file]
]
