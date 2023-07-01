#======================================#
#  Sample: Base64 decode data
#  Author: Gal Zsolt, Mansour Ayouni
#======================================#

load "guilib.ring"

oQByteArray = new QByteArray()
oQByteArray.append("Rosetta Code Base64 decode data task")
oba = oQByteArray.toBase64().data()
see oba + nl

oQByteArray = new QByteArray()
oQByteArray.append(oba)
see oQByteArray.fromBase64(oQByteArray).data()
