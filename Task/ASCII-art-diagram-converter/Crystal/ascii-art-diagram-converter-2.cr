   class MessageHeader
     @data = Array(UInt16).new(6, 0)

     def self.from_io(io)
       o = new
       (o.@data).map! do UInt16.from_io(io, IO::ByteFormat::NetworkEndian) end
       o
     end

     def to_io(io)
       @data.each do |n| n.to_io(io, IO::ByteFormat::NetworkEndian) end
     end

     def id
       @data[0]
     end

     def id=(v)
       @data[0] = v.to_u16
     end

     def qr
       @data[1].bits(15...16)
     end

     def qr=(v)
       mask = (1_u16 << 1) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 15))) | (v.to_u16 << 15)
     end

     def qr=(v : Bool)
       self.qr = v ? 1 : 0
     end

     def qr?
       self.qr == 1
     end

     def opcode
       @data[1].bits(11...15)
     end

     def opcode=(v)
       mask = (1_u16 << 4) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 11))) | (v.to_u16 << 11)
     end

     def aa
       @data[1].bits(10...11)
     end

     def aa=(v)
       mask = (1_u16 << 1) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 10))) | (v.to_u16 << 10)
     end

     def aa=(v : Bool)
       self.aa = v ? 1 : 0
     end

     def aa?
       self.aa == 1
     end

     def tc
       @data[1].bits(9...10)
     end

     def tc=(v)
       mask = (1_u16 << 1) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 9))) | (v.to_u16 << 9)
     end

     def tc=(v : Bool)
       self.tc = v ? 1 : 0
     end

     def tc?
       self.tc == 1
     end

     def rd
       @data[1].bits(8...9)
     end

     def rd=(v)
       mask = (1_u16 << 1) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 8))) | (v.to_u16 << 8)
     end

     def rd=(v : Bool)
       self.rd = v ? 1 : 0
     end

     def rd?
       self.rd == 1
     end

     def ra
       @data[1].bits(7...8)
     end

     def ra=(v)
       mask = (1_u16 << 1) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 7))) | (v.to_u16 << 7)
     end

     def ra=(v : Bool)
       self.ra = v ? 1 : 0
     end

     def ra?
       self.ra == 1
     end

     def z
       @data[1].bits(4...7)
     end

     def z=(v)
       mask = (1_u16 << 3) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 4))) | (v.to_u16 << 4)
     end

     def rcode
       @data[1].bits(0...4)
     end

     def rcode=(v)
       mask = (1_u16 << 4) - 1
       if 0 <= v && v <= mask
       else
         raise("overflow")
       end
       @data[1] = (@data[1] & (~(mask << 0))) | (v.to_u16 << 0)
     end

     def qdcount
       @data[2]
     end

     def qdcount=(v)
       @data[2] = v.to_u16
     end

     def ancount
       @data[3]
     end

     def ancount=(v)
       @data[3] = v.to_u16
     end

     def nscount
       @data[4]
     end

     def nscount=(v)
       @data[4] = v.to_u16
     end

     def arcount
       @data[5]
     end

     def arcount=(v)
       @data[5] = v.to_u16
     end

     def values
       { id: self.id,
         qr: self.qr,
         opcode: self.opcode,
         aa: self.aa,
         tc: self.tc,
         rd: self.rd,
         ra: self.ra,
         z: self.z,
         rcode: self.rcode,
         qdcount: self.qdcount,
         ancount: self.ancount,
         nscount: self.nscount,
         arcount: self.arcount,
       }
     end

     def self.field_sizes
       { id: 16,
         qr: 1,
         opcode: 4,
         aa: 1,
         tc: 1,
         rd: 1,
         ra: 1,
         z: 3,
         rcode: 4,
         qdcount: 16,
         ancount: 16,
         nscount: 16,
         arcount: 16,
       }
     end
   end
