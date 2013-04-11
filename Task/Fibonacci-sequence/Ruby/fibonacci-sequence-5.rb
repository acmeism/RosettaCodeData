require 'generator'

def fibGen
    Generator.new do |g|
        f0, f1 = 0, 1
        loop do
            g.yield f0
            f0, f1 = f1, f0+f1
        end
    end
end
