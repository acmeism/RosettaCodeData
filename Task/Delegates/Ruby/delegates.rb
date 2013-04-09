class Delegator
   attr_accessor :delegate
   def operation
      if @delegate.respond_to?(:thing)
         @delegate.thing
      else
         'default implementation'
      end
   end
end

class Delegate
   def thing
      'delegate implementation'
   end
end

if __FILE__ == $PROGRAM_NAME

   # No delegate
   a = Delegator.new
   puts a.operation # prints "default implementation"

   # With a delegate that does not implement "thing"
   a.delegate = 'A delegate may be any object'
   puts a.operation # prints "default implementation"

   # With delegate that implements "thing"
   a.delegate = Delegate.new
   puts a.operation # prints "delegate implementation"
end
