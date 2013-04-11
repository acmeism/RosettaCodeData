# Array#select! is new to Ruby 1.9.2.
# Define it for older Ruby.
unless Array.method_defined? :select!
  class Array
    def select!
      enum_for(:select!) unless block_given?
      delete_if { |elem| not yield elem }
      self
    end
  end
end
