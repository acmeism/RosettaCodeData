enum Chaoperation
  Encode
  Decode
end

class Array
  # useful method to work on parts of the array
  def slice (start, length)
    start = size - start if start < 0
    raise "Out of bounds" unless start >= 0 && length >= 0 && start + length <= size
    Slice.new(to_unsafe + start, length)
  end
end

def chaocipher (message : String, left : String, right : String,
                op : Chaoperation = Chaoperation::Encode)
  ct = left.chars
  pt = right.chars
  String.build do |s|
    message.each_char do |ch|
      idx = (op == Chaoperation::Encode ? pt : ct).index! ch
      s <<  (op == Chaoperation::Encode ? ct : pt)[idx]
      # permute left
      ct.rotate! idx
      ct.slice(1, 13).rotate! 1
      # permute right
      pt.rotate! idx+1
      pt.slice(2, 12).rotate! 1
    end
  end
end

left = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
right = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
message = "WELLDONEISBETTERTHANWELLSAID"

encoded = chaocipher(message, left, right)
decoded = chaocipher(encoded, left, right, Chaoperation::Decode)

print message, " -> ", encoded, " -> ", decoded, "\n"
