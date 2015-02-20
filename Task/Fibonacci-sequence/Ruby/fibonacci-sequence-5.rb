require 'generator'

def fib_gen
    Generator.new do |g|
        f0, f1 = 0, 1
        loop do
            g.yield f0
            f0, f1 = f1, f0 + f1
        end
    end
end
