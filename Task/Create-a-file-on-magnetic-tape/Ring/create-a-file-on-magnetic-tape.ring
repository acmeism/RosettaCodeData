# Project : Create a file on magnetic tape
# Date    : 2017/12/09
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

fn = "Tape.file"
fp = fopen(fn,"w")
str = "I am a tape file now, or hope to be soon."
fwrite(fp, str)
fclose(fp)
