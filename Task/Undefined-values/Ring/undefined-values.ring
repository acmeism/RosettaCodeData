# Project : Undefined values
# Date    : 2018/03/27
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

test()
func test
       x=10 y=20
       see islocal("x") + nl +
       islocal("y") + nl +
       islocal("z") + nl
