MCSKIP "WITH" NL
"" CSV to HTML
"" assumes macros on input stream 1, terminal on stream 2
MCSKIP MT,[]
MCSKIP SL WITH ~
MCINS %.
"" C1=th before header output, td afterwards
MCCVAR 1,2
MCSET C1=[th]
"" HTML escapes
MCDEF < AS [[&lt;]]
MCDEF > AS [[&gt;]]
MCDEF & AS [[&amp;]]
"" Main line processing
MCDEF SL N1 OPT , N1 OR NL ALL
AS [[   <tr>]
MCSET T2=1
%L1.MCGO L2 IF T2 GR T1
      [<]%C1.[>]%AT2.[</]%C1.[>]
MCSET T2=T2+1
MCGO L1
%L2.[   </tr>]
MCSET C1=[td]
]
[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
<title>HTML converted from CSV</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css"><!--
th {
        font-weight:bold;
        text-align:left
}
table,td,th {
        border:1px solid;
        border-collapse:collapse
}
td,th {
        padding:10px
}
//-->
</style>
</head>

<body>
<table>]
MCSET S1=1
~MCSET S10=2
~MCSET S1=0
[</table>
</body>
</html>
]
