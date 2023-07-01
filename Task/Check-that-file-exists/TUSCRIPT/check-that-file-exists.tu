$$ MODE TUSCRIPT
file="input.txt",directory="docs"
IF (file=='file') THEN
PRINT file, " exists"
ELSE
PRINT/ERROR file," not exists"
ENDIF
IF (directory=='project') THEN
PRINT directory," exists"
ELSE
PRINT/ERROR "directory ",directory," not exists"
ENDIF
