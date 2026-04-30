def spiral
  next_p = [{x: 1, y: 1, hyp: 2}]
  next_interval = ->(int : Int32) {
    next_p.concat((0..int).map {|i| {x: int, y: i, hyp: int**2 + i**2 } })
    next_p.sort_by! &.[:hyp]
  }
  interval = 1
  last_p = tail = {0,1}
  [{0,0}, tail].each.chain Iterator.of {
    θ = Math.atan2 *tail.reverse
    this = [next_p.shift]
    while !next_p.empty? && next_p[0][:hyp] == this[0][:hyp]
      this << next_p.shift
    end
    candidates = this.flat_map {|n|
      i, j = n[:x], n[:y]
      next_interval.call(interval += 1) if interval == i
      [{i,j},{-i,j},{i,-j},{-i,-j},{j,i},{-j,i},{j,-i},{-j,-i}]
    }
    tail = candidates.min_by {|c| (θ - Math.atan2(*c.reverse)) % (Math::PI*2) }
    last_p = { tail[0] + last_p[0], tail[1] + last_p[1] }
  }
end

spiral.first(40).each_slice(10) do |row|
  puts row.map {|c| " %9s" % c.to_s}.join
end

# stretch:

svg = [%(<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">)]
svg << %(<rect width="100%" height="100%" style="fill:white;" />)
svg << %(<polyline points=")
spiral.first(10_000).each do |x, y|
  svg << " #{x},#{y}"
end
svg << %(" style="stroke:red; stroke-width:6; fill:white;" transform="scale (.05, -.05) translate (1000,-10000)" />)
svg << %(</svg>)

File.write("crystal_babylonian_spiral.svg", svg.join)
