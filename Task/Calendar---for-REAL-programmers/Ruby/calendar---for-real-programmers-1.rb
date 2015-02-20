# loadup.rb - run UPPERCASE RUBY program

class Object
  alias lowercase_method_missing method_missing

  # Allow UPPERCASE method calls.
  def method_missing(sym, *args, &block)
    str = sym.to_s
    if str == (down = str.downcase)
      lowercase_method_missing sym, *args, &block
    else
      send down, *args, &block
    end
  end

  # RESCUE an exception without the 'rescue' keyword.
  def RESCUE(_BEGIN, _CLASS, _RESCUE)
    begin _BEGIN.CALL
    rescue _CLASS
      _RESCUE.CALL; end
  end
end

_PROGRAM = ARGV.SHIFT
_PROGRAM || ABORT("USAGE: #{$0} PROGRAM.RB ARGS...")
LOAD($0 = _PROGRAM)
