=begin
irb(main):001:0> lcs('thisisatest', 'testing123testing')
=> "tsitest"
=end
def lcs(xstr, ystr)
    return "" if xstr.empty? || ystr.empty?

    x, xs, y, ys = xstr[0..0], xstr[1..-1], ystr[0..0], ystr[1..-1]
    if x == y
        x + lcs(xs, ys)
    else
        [lcs(xstr, ys), lcs(xs, ystr)].max_by {|x| x.size}
    end
end
