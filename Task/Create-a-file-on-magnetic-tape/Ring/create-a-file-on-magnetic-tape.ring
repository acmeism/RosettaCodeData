# Project : Create a file on magnetic tape

fn = "Tape.file"
fp = fopen(fn,"w")
str = "I am a tape file now, or hope to be soon."
fwrite(fp, str)
fclose(fp)
