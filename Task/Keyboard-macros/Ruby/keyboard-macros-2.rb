Shoes.app do
  keypress do |key|
    case key
    when "\x04"  # control-d
      delete_char
    when :backspace
      delete_previous_char
    when "\x14"  # control-t
      transpose_chars
    when :alt_t
      transpose_words
    when "\x18"  # control-x
      @ctrl_x = true
    when "\x13"  # control-s
      if @ctrl_x
        save_text
        @ctrl_x = false
      end
    when "\x11"  # control-q
      exit if @ctrl_x
    end
  end
end
