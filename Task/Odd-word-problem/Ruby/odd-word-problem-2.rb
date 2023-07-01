require 'continuation' unless defined? Continuation
require 'stringio'

# Save current continuation.
def savecc(*data)
  # With MRI 1.8 (but not 1.9), the array literal
  #   [callcc {|cc| cc}, *data]
  # used the wrong return value from callcc. The workaround is to
  # put callcc outside the array literal.
  continuation = callcc {|cc| cc}
  [continuation, *data]
end

# Jump back to continuation, where savecc will return [nil, *data].
def jump_back(continuation)
  continuation[nil]
end

def read_odd_word(input, output)
  first_continuation, last_continuation = nil
  reverse = false
  # Read characters. Loop until end of stream.
  while c = input.getc
    c = c.chr   # For Ruby 1.8, convert Integer to String.
    if c =~ /[[:alpha:]]/
      # This character is a letter.
      if reverse
        # Odd word: Write letters in reverse order.
        saving, last_continuation, c = savecc(last_continuation, c)
        if saving
          last_continuation = saving
        else
          # After jump: print letters in reverse.
          output.print c
          jump_back last_continuation
        end
      else
        # Even word: Write letters immediately.
        output.print c
      end
    else
      # This character is punctuation.
      if reverse
        # End odd word. Fix trampoline, follow chain of continuations
        # (to print letters in reverse), then bounce off trampoline.
        first_continuation, c = savecc(c)
        if first_continuation
          jump_back last_continuation
        end
        output.print c      # Write punctuation.
        reverse = false     # Begin even word.
      else
        output.print c      # Write punctuation.
        reverse = true      # Begin odd word.
        # Create trampoline to bounce to (future) first_continuation.
        last_continuation, = savecc
        unless last_continuation
          jump_back first_continuation
        end
      end
    end
  end
  output.puts   # Print a cosmetic newline.
end

def odd_word(string)
  read_odd_word StringIO.new(string), $stdout
end

odd_word "what,is,the;meaning,of:life."
odd_word "we,are;not,in,kansas;any,more."
