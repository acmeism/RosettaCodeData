type
  rs232Data = enum
    carrierDetect,
    receivedData,
    transmittedData,
    dataTerminalReady,
    signalGround,
    dataSetReady,
    requestToSend,
    clearToSend,
    ringIndicator

# Bit vector of 9 bits
var bv = {carrierDetect, signalGround, ringIndicator}
echo cast[uint16](bv) # Conversion of bitvector to 2 bytes for writing

let readValue: uint16 = 123
bv = cast[set[rs232Data]](readValue) # Conversion of a read value to bitvector
echo bv
