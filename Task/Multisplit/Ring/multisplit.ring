# Project : Multisplit
# Date    : 2017/12/26
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

str = "a!===b=!=c"
sep = "=== != =! b =!="
sep = str2list(substr(sep, " ", nl))
for n = 1 to len(sep)
      pos = substr(str, sep[n])
      see "" + n + ": " + substr(str, 1, pos-1) + " Sep By: " + sep[n] + nl
next
