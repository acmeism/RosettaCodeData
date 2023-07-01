parseDirs       =: = <;.2 ]
getCommonPrefix =: {. ;@{.~ 0 i.~ *./@(="1 {.)

getCommonDirPath=: [: getCommonPrefix parseDirs&>
