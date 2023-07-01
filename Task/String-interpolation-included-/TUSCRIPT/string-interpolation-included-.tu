$$ MODE TUSCRIPT

sentence_old="Mary had a X lamb."

values=*
DATA little
DATA big

sentence_new=SUBSTITUTE (sentence_old,":X:",0,0,values)
PRINT sentence_old
PRINT sentence_new
