def next_row(row) ([0] + row).zip(row + [0]).collect {|l,r| l + r } end

def pascal(n) n.times.inject([1]) {|x,_| next_row x } end

8.times{|i| p pascal(i)}
