def next_row row ; ([0] + row).zip(row + [0]).collect {|l,r| l + r }; end

def pascal n ; ([nil] * n).inject([1]) {|x,y| y = next_row x } ; end
