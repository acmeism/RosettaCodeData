var T // global scope

var doSomethingWithT = Fn.new { [T * T, T.sqrt] }

T = 3
System.print(doSomethingWithT.call())
