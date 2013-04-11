eval(2*3)  # eval(2*3)  "#" and text after it aren't processed but passed along
dnl  this text completely disappears, including the new line
divert(-1)
Everything diverted to -1 is processed but the output is discarded.
A comment could take this form as long as no macro names are used.
divert
