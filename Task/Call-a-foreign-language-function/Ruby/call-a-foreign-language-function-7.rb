require 'rubygems'
require 'inline'

class InlineTester
  def factorial_ruby(n)
    (1..n).inject(1, :*)
  end

  inline do |builder|
    builder.c <<-'END_C'
      long factorial_c(int max) {
        long result = 1;
        int i;
        for (i = 1; i <= max; ++i)
          result *= i;
        return result;
      }
    END_C
  end

  inline do |builder|
    builder.include %q("math.h")
    builder.c <<-'END_C'
      int my_ilogb(double value) {
        return ilogb(value);
      }
    END_C
  end
end

t = InlineTester.new
11.upto(14) {|n| p [n, t.factorial_ruby(n), t.factorial_c(n)]}
p t.my_ilogb(1000)
