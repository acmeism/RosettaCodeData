import "io" for Stdin

class Brainf__k {
    construct new(prog, memSize) {
        _prog = prog
        _memSize = memSize
        _mem = List.filled(memSize, 0)
        _ip = 0
        _dp = 0
    }

    memVal_ { (_dp >= 0 && _dp < _memSize) ? _mem[_dp] : 0 }

    execute() {
        while (_ip < _prog.count) {
            var cmd = _prog[_ip]
            _ip = _ip + 1
            if (cmd == ">") {
                _dp = _dp + 1
            } else if (cmd == "<") {
                _dp = _dp - 1
            } else if (cmd == "+") {
                _mem[_dp] = memVal_ + 1
            } else if (cmd == "-") {
                _mem[_dp] = memVal_ - 1
            } else if (cmd == ",") {
                _mem[_dp] = Stdin.readByte()
            } else if (cmd == ".") {
                System.write(String.fromByte(memVal_))
            } else if (cmd == "[") {
                handleLoopStart_()
            } else if (cmd == "]") {
                handleLoopEnd_()
            }
        }
    }

    handleLoopStart_() {
        if (memVal_ != 0) return
        var depth = 1
        while (_ip < _prog.count) {
            var cmd = _prog[_ip]
            _ip = _ip + 1
            if (cmd == "[") {
                depth = depth + 1
            } else if (cmd == "]") {
                depth = depth - 1
                if (depth == 0) return
            }
        }
        Fiber.abort("Could not find matching end bracket.")
    }

    handleLoopEnd_() {
        var depth = 0
        while (_ip >= 0) {
            _ip = _ip - 1
            var cmd = _prog[_ip]
            if (cmd == "]") {
                depth = depth + 1
            } else if (cmd == "[") {
                depth = depth - 1
                if (depth == 0) return
            }
        }
        Fiber.abort("Could not find matching start bracket.")
    }
}

var prog = "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
Brainf__k.new(prog, 10).execute()
