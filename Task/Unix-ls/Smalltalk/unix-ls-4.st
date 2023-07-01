dir := '.' asFilename.
dir directoryContentsAsFilenames sort do:[:fn |
    |line|
    "
     generate a line of the form of ls -l:
         drwxrwxrwx    user  group     size  date time name
     where year is printed if not current, time of day otherwise
    "
    line := String streamContents:[:s |
        |accessRights|

        s nextPut:(fn isDirectory ifTrue:[$d] ifFalse:[$-]).
        accessRights := fn symbolicAccessRights.
        #(  readUser writeUser executeUser
            readGroup writeGroup executeGroup
            readOthers writeOthers executeOthers
         )
        with:'rwxrwxrwx'
        do:[:eachRight :charToPrint |
            s nextPut:((accessRights includes:eachRight) ifTrue:[charToPrint] ifFalse:[$-])
        ].
        (OperatingSystem getUserNameFromID:fn info uid) printOn:s leftPaddedTo:10.
        (OperatingSystem getGroupNameFromID:fn info gid) printOn:s leftPaddedTo:10.
        fn fileSize printOn:s leftPaddedTo:12.
        fn modificationTime year = Date today year ifTrue:[
            fn modificationTime printOn:s format:' %(dayPadded) %(ShortMonthName) %h:%m'.
        ] ifFalse:[
            fn modificationTime asDate printOn:s format:' %(dayPadded) %(ShortMonthName)  %y'.
        ].
        s space.
        s nextPutAll:fn baseName
    ].
    line printCR
].
