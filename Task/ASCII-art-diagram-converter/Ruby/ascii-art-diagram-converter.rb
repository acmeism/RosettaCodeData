header = <<HEADER
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
HEADER

Item = Struct.new(:name, :bits, :range)
RE = /\| *\w+ */

i = 0
table = header.scan(RE).map{|m| Item.new( m.delete("^A-Za-z"), b = m.size/3, i...(i += b)) }

teststr = "78477bbf5496e12e1bf169a4"
padding = table.sum(&:bits)
binstr  = teststr.hex.to_s(2).rjust(padding, "0")

table.each{|el| p el.values}; puts
table.each{|el| puts "%7s, %2d bits: %s" % [el.name, el.bits, binstr[el.range] ]}
