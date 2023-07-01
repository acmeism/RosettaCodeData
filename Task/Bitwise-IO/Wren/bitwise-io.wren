import "io" for File

class BitFilter {
    construct new(name) {
        _name = name
        _accu = 0
        _bits = 0
    }

    openWriter() {
        _bw = File.create(_name)
    }

    openReader() {
        _br = File.open(_name)
        _offset = 0
    }

    write(buf, start, nBits, shift) {
        var index = start + (shift/8).floor
        shift = shift % 8
        while (nBits != 0 || _bits >= 8) {
            while (_bits >= 8) {
                _bits = _bits - 8
                _bw.writeBytes(String.fromByte((_accu >> _bits) & 255))
            }
            while (_bits < 8 && nBits != 0) {
                var b = buf[index]
                _accu = (_accu << 1) | (((128 >> shift) & b) >> (7 - shift))
                nBits = nBits - 1
                _bits = _bits + 1
                shift = shift + 1
                if (shift == 8) {
                    shift = 0
                    index = index + 1
                }
            }
        }
    }

    read(buf, start, nBits, shift) {
        var index = start + (shift/8).floor
        shift = shift % 8
        while (nBits != 0) {
            while (_bits != 0 && nBits != 0) {
                var mask = 128 >> shift
                if ((_accu & (1 << (_bits - 1))) != 0) {
                    buf[index] = (buf[index] | mask) & 255
                } else {
                    buf[index] = (buf[index] & ~mask) & 255
                }
                nBits = nBits - 1
                _bits = _bits - 1
                shift = shift + 1
                if (shift >= 8) {
                    shift = 0
                    index = index + 1
                }
            }
            if (nBits == 0) break
            var byte = _br.readBytes(1, _offset).bytes[0]
            _accu = (_accu << 8) | byte
            _bits = _bits + 8
            _offset = _offset + 1
        }
    }

    closeWriter() {
        if (_bits != 0) {
            _accu = _accu << (8 - _bits)
            _bw.writeBytes(String.fromByte(_accu & 255))
        }
        _bw.close()
        _accu = 0
        _bits = 0
    }

    closeReader() {
        _br.close()
        _accu = 0
        _bits = 0
        _offset = 0
    }
}

var s = "abcdefghijk".bytes.toList
var f = "test.bin"
var bf = BitFilter.new(f)

/* for each byte in s, write 7 bits skipping 1 */
bf.openWriter()
for (i in 0...s.count) bf.write(s, i, 7, 1)
bf.closeWriter()

/* read 7 bits and expand to each byte of s2 skipping 1 bit */
bf.openReader()
var s2 = List.filled(s.count, 0)
for (i in 0...s2.count) bf.read(s2, i, 7, 1)
bf.closeReader()
System.print(s2.map { |b| String.fromByte(b) }.join())
