TOROMAN(n)
    ;return empty string if input parameter 'n' is not in 1-3999
    Quit:(n'?1.4N)!(n'<4000)!'n ""
    New r  Set r=""
    New p  Set p=$Length(n)
    New j,x
    For j=1:1:p  Do
    . Set x=$Piece("~I~II~III~IV~V~VI~VII~VIII~IX","~",$Extract(n,j)+1)
    . Set x=$Translate(x,"IVX",$Piece("IVX~XLC~CDM~M","~",p-j+1))
    . Set r=r_x
    Quit r
