LOWASCMIN
    set lowstr = ""
    for i = 97:1:122 set delim = $select(i=97:"",1:",") set lowstr = lowstr_delim_$char(i)
    write lowstr
    quit
