$$ MODE TUSCRIPT
content="new text that will overwrite content of myfile"
LOOP
 path2file=FULLNAME (TUSTEP,"myfile",-std-)
 status=WRITE (path2file,content)
 IF (status=="OK") EXIT
 IF (status=="CREATE") ERROR/STOP CREATE ("myfile",seq-o,-std-)
ENDLOOP
