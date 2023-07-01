/* Check if a file already exists */
filename='file.txt'
IF ~Openfile(filename) THEN CALL Openfile(':'filename)
EXIT 0
Openfile:
IF ~Exists(filename) THEN RETURN 0
CALL Open(filehandle,filename,'APPEND')
RETURN 1
