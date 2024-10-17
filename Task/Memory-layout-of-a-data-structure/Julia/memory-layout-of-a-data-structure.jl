mutable struct NinePinSerialPort
    pins::BitArray
    function NinePinSerialPort()
        this = new()
        this.pins = BitArray(9)
    end
end

const CD = 1
const RD = 2
const TD = 3
const SG = 5
const DSR = 6
const RTS = 7
const CTS = 8

# Here we test the type's code.
port = NinePinSerialPort()
println("Port is now at defaults, which are $port")
port[CTS] = true
println("CD pin of port, which is pin $CD, is now $(port[CD])")
println("CTS pin of port, which is pin $CTS, is now $(port[CTS])")
println("port is now: $port")
