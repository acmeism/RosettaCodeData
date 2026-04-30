macro convert_diagram (typename, s)
  {% lines = s.strip.split(/\r?\n/).map(&.strip) %}

  # check if it's actually a diagram
  {% for line, i in lines %}
    {% unless (i % 2 == 0 && line =~ /^\+(--\+)+$/) ||     # well formed border?
              (i % 2 != 0 && line =~ /^\|([ \w]+\|)+$/) %} # inside probably ok?
      {% raise "bad diagram format" %}
    {% end %}
  {% end %}

  # count size
  {% row_size = lines[0].split('+').size - 2 %}
  {% unless [8, 16, 32, 64, 128].includes?(row_size) %}
    {% raise "Invalid data size : " + row_size %}
  {% end %}

  # get rid of the borders now
  {% lines = lines.reject {|line| line.starts_with?("+--+") } %}

  {% element_type = "UInt" + row_size.stringify %}
  {% suffix = "_u" + row_size.stringify %}
  {% array_size = lines.size %}
  {% field_names = [] of StringLiteral %}
  {% field_sizes = [] of IntLiteral %}

  # build the type
  class {{typename.id}}
    @data = Array({{element_type.id}}).new({{array_size.id}}, 0)

    def self.from_io (io)
      o = new
      o.@data.map! { {{element_type.id}}.from_io(io, IO::ByteFormat::NetworkEndian) }
      o
    end

    def to_io (io)
      @data.each do |n| n.to_io(io, IO::ByteFormat::NetworkEndian) end
    end

    {% for line, idx in lines %}
      {% fields = line.split('|')[1...-1] %}
      {% offset = row_size %}
      {% for field in fields %}
        {% field_size = (field.size+1) // 3 %}
        {% field_sizes << field_size %}
        {% field_name = field.strip.downcase %}
        {% field_names << field_name %}
        {% offset -= field_size %}

        {% if field_size == row_size %}
          def {{field_name.id}}
            @data[{{idx.id}}]
          end

          def {{field_name.id}}= (v)
            @data[{{idx.id}}] = v.to{{suffix.id}}
          end
        {% else %}
          def {{field_name.id}}
            @data[{{idx.id}}].bits({{offset.id}} ... {{(offset + field_size).id}})
          end

          def {{field_name.id}}= (v)
            mask = (1{{suffix.id}} << {{field_size.id}}) - 1
            raise "overflow" unless 0 <= v <= mask
            @data[{{idx.id}}] = (@data[{{idx.id}}] & ~(mask << {{offset.id}})) | (v.to{{suffix.id}} << {{offset.id}})
          end
          {% if field_size == 1 %}
            def {{field_name.id}}= (v : Bool)
              self.{{field_name.id}} = v ? 1 : 0
            end

            def {{field_name.id}}?
              self.{{field_name.id}} == 1
            end
          {% end %}
        {% end %}
      {% end %}
    {% end %}
    def values
      {
        {% for field_name in field_names %}
          {{ field_name.id }}: self.{{field_name.id}},
        {% end %}
      }
    end
    def self.field_sizes
      {
        {% for field_name, i in field_names %}
          {{ field_name.id }}: {{ field_sizes[i].id }},
        {% end %}
      }
    end
  end # class
end

convert_diagram MessageHeader, <<-EOD
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
  EOD

io = IO::Memory.new "78477bbf5496e12e1bf169a4".hexbytes

h = MessageHeader.from_io(io)

sizes = MessageHeader.field_sizes

puts "   Field    Sz   Value   (binary)"
puts "   ------------------------------"
h.values.each do |name, value|
  puts "%8s:   %2d   %5d   %0*b" % {name, sizes[name], value, sizes[name], value}
end
