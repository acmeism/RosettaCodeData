def with_payload(template, payload, used = nil)
    template.map do |item|
      if item.is_a? Enumerable
        with_payload(item, payload, used)
      else
        used << item
        payload[item]
      end
    end
end

p = {"Payload#0", "Payload#1", "Payload#2", "Payload#3", "Payload#4", "Payload#5", "Payload#6"}
t = { { {1, 2}, {3, 4, 1}, 5}}
used = Set(Int32).new
puts with_payload(t, p, used)

unused = Set(Int32).new((0..6).to_a) - used
puts "Unused indices: #{unused}"
