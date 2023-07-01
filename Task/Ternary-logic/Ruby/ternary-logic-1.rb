# trit.rb - ternary logic
# http://rosettacode.org/wiki/Ternary_logic

require 'singleton'

# MAYBE, the only instance of MaybeClass, enables a system of ternary
# logic using TrueClass#trit, MaybeClass#trit and FalseClass#trit.
#
#  !a.trit      # ternary not
#  a.trit & b   # ternary and
#  a.trit | b   # ternary or
#  a.trit ^ b   # ternary exclusive or
#  a.trit == b  # ternary equal
#
# Though +true+ and +false+ are internal Ruby values, +MAYBE+ is not.
# Programs may want to assign +maybe = MAYBE+ in scopes that use
# ternary logic. Then programs can use +true+, +maybe+ and +false+.
class MaybeClass
  include Singleton

  #  maybe.to_s  # => "maybe"
  def to_s; "maybe"; end
end

MAYBE = MaybeClass.instance

class TrueClass
  TritMagic = Object.new
  class << TritMagic
    def index; 0; end
    def !; false; end
    def & other; other; end
    def | other; true; end
    def ^ other; [false, MAYBE, true][other.trit.index]; end
    def == other; other; end
  end

  # Performs ternary logic. See MaybeClass.
  #  !true.trit        # => false
  #  true.trit & obj   # => obj
  #  true.trit | obj   # => true
  #  true.trit ^ obj   # => false, maybe or true
  #  true.trit == obj  # => obj
  def trit; TritMagic; end
end

class MaybeClass
  TritMagic = Object.new
  class << TritMagic
    def index; 1; end
    def !; MAYBE; end
    def & other; [MAYBE, MAYBE, false][other.trit.index]; end
    def | other; [true, MAYBE, MAYBE][other.trit.index]; end
    def ^ other; MAYBE; end
    def == other; MAYBE; end
  end

  # Performs ternary logic. See MaybeClass.
  #  !maybe.trit        # => maybe
  #  maybe.trit & obj   # => maybe or false
  #  maybe.trit | obj   # => true or maybe
  #  maybe.trit ^ obj   # => maybe
  #  maybe.trit == obj  # => maybe
  def trit; TritMagic; end
end

class FalseClass
  TritMagic = Object.new
  class << TritMagic
    def index; 2; end
    def !; true; end
    def & other; false; end
    def | other; other; end
    def ^ other; other; end
    def == other; [false, MAYBE, true][other.trit.index]; end
  end

  # Performs ternary logic. See MaybeClass.
  #  !false.trit        # => true
  #  false.trit & obj   # => false
  #  false.trit | obj   # => obj
  #  false.trit ^ obj   # => obj
  #  false.trit == obj  # => false, maybe or true
  def trit; TritMagic; end
end
