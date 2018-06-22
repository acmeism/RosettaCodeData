# Project: SHA-256
# Date   : 2018/06/09
# Author: Gal Zsolt [~ CalmoSoft ~]
# Email  : <calmosoft@gmail.com>

load "stdlib.ring"
str = "Rosetta code"
see "String: " + str + nl
see "SHA-256: "
see sha256(str) + nl
