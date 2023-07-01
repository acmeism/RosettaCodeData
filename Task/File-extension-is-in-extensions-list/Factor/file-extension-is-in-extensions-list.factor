USING: formatting kernel qw sequences splitting unicode ;
IN: rosetta-code.file-extension-list

CONSTANT: extensions qw{ zip rar 7z gz archive A## tar.bz2 }
CONSTANT: filenames qw{
    MyData.a## MyData.tar.Gz MyData.gzip MyData.7z.backup
    MyData... MyData MyData_v1.0.tar.bz2 MyData_v1.0.bz2
}

: ext-in-list? ( filename list -- ? )
    [ >lower "." split ] dup [ map ] curry bi*
    [ tail? t = ] with find nip >boolean ;

extensions "List of file extensions: %[%s, %]\n\n" printf
"File extension in extensions list?\n" printf
filenames [
    dup extensions ext-in-list? "%19s  %u\n" printf
] each
