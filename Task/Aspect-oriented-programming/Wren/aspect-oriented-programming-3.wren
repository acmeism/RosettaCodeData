/* adderClient.wren */

import "./logAspectAdder" for LogAspectAdder, Adder

var a = LogAspectAdder.add2(3)
var m = Adder.mul2(4)
System.print("3 + 2 = %(a)")  // logged
System.print("4 * 2 = %(m)")  // not logged
