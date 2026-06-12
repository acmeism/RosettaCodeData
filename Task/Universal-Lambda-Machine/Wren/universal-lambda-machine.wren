import "os" for Process
import "io" for Stdin

var inp = []
var progchar = 0
var nbit = 0
var bytemode = Process.arguments.count == 0

var bit2lam = Fn.new { |bit| Fn.new { |x0| Fn.new { |x1| bit == 0 ? x0 : x1 } } }

var byte2lam // recursive
byte2lam = Fn.new { |bits, n|
    return n == 0 ?
        Fn.new { Fn.new { |y| y } } :
        Fn.new { |z| z.call(bit2lam.call(bits>>(n-1) & 1)).call(byte2lam.call(bits, n-1)) }
}

// input from 'n'th character onward
var input // recursive
input = Fn.new { |n|
    if (n >= inp.count) {
        var c = Stdin.readByte()
        inp.add(c == 10 ?
            Fn.new { Fn.new { |y| y } } :
            Fn.new { |z| z.call(bytemode ?
                byte2lam.call(c, 8) : bit2lam.call(c&1)).call(input.call(n+1)) }
        )
    }
    return inp[n]
}

// force suspension
var lam2bit = Fn.new { |lambit| lambit.call(Fn.new { 0 }).call(Fn.new { 1 }).call(0) }

var lam2byte // recursive
lam2byte = Fn.new { |lambits, x|
    return lambits.call(
        Fn.new { |lambit| Fn.new { |lamtail| Fn.new { lam2byte.call(lamtail, 2*x+lam2bit.call(lambit)) } } }).call(x)
}

var output // recursive
output = Fn.new { |prog|
    return prog.call(Fn.new { |c|
        System.write(bytemode ? String.fromByte(lam2byte.call(c, 0)) : (lam2bit.call(c) == 0 ? "0" : "1"))
        return Fn.new { |tail| Fn.new { output.call(tail) } }
    }).call(0)
}

var getbit = Fn.new {
    if (nbit == 0) {
        progchar = Stdin.readByte()
        nbit = bytemode ? 8 : 1
    }
    nbit = nbit - 1
    return (progchar >> nbit) & 1
}

var program // recursive
program = Fn.new {
    if (getbit.call() != 0) { // variable
        var i = 0
        while (getbit.call() == 1) i = i + 1
        return Fn.new { |args| args[i] }
    } else if (getbit.call() != 0) { // application
        var p = program.call()
        var q = program.call()
        // suspend argument
        return Fn.new { |args|
            return p.call(args).call(Fn.new { |arg| q.call(args).call(arg) })
        }
    } else {
        // extend environment with one more argument
        var p = program.call()
        return Fn.new { |args| Fn.new { |arg| p.call([arg] + args) } }
    }
}

System.print("Input:")
var prog = program.call().call([0])
System.print("\nOutput:")
// run program with empty environment on input
output.call(prog.call(input.call(0)))
System.print()
