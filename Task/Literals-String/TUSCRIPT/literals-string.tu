$$ MODE TUSCRIPT,{}
s1=*
DATA "string"
s2=*
DATA + "double" quotes
s3=*
DATA + 'single' quotes
s4=*
DATA + "double" + 'single' quotes
show=JOIN(s1," ",s2,s3,s4)
show=JOIN(show)
PRINT show
