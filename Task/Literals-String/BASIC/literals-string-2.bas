DIM c AS STRING * 1, s AS STRING

c = "char" 'everything after the first character is silently discarded
s = "string"
PRINT CHR$(34); s; " data "; c; CHR$(34)
