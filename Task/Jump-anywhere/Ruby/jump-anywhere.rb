require 'continuation' unless defined? Continuation

if a = callcc { |c| [c, 1] }
  c, i = a
  c[nil] if i > 100

  case 0
  when i % 3
    print "Fizz"
    case 0
    when i % 5
      print "Buzz"
    end
  when i % 5
    print "Buzz"
  else
    print i
  end

  puts
  c[c, i + 1]
end
