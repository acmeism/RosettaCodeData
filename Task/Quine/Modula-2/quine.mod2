MODULE Quine;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

CONST src = "MODULE Quine;\nFROM FormatString IMPORT FormatString;\nFROM Terminal IMPORT WriteString,ReadChar;\n\nCONST src = \x022%s\x022;\nVAR buf : ARRAY[0..2048] OF CHAR;\nBEGIN\n    FormatString(src, buf, src);\n    WriteString(buf);\n    ReadChar\nEND Quine.\n";
VAR buf : ARRAY[0..2048] OF CHAR;
BEGIN
    FormatString(src, buf, src);
    WriteString(buf);
    ReadChar
END Quine.
