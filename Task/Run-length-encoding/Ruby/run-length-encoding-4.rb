def encode(str)
    str.gsub(/(.)\1*/) {$&.length.to_s + $1}
end

def decode(str)
    str.gsub(/(\d+)(\D)/) {$2 * $1.to_i}
end
