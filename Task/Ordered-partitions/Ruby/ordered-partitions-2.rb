def part(s, args)
  return [[]] if args.empty?
  s.combination(args[0]).each_with_object([]) do |c, res|
    part(s - c, args[1..-1]).each{|r| res << ([c] + r)}
  end
end
def partitions(args)
  return [[]] if args.empty?
  part((1..args.inject(:+)).to_a, args)
end
