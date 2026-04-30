("hi there, how are you today? I'd like to present to you the washing machine 9001. " +
 "You have been nominated to win one of these! " +
 "Just make sure you don't break it").split(/([.!?])(?:\s+|$)/).each_slice(2) do |slice|
  print slice.join, " -> ",
        { "." => "S", "!" => "E", "?" => "Q", nil => "N" }[slice[1]?],
        "\n"
end
