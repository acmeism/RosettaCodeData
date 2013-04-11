# Integer#even? is new to Ruby 1.8.7.
# Define it for older Ruby.
unless Integer.method_defined? :even?
  class Integer
    def even?
      self % 2 == 0
    end
  end
end
