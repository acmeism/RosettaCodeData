data = [["[1;5,2] + 1/2",      [2,1,0,2], [13,11]],
        ["[3;7] + 1/2",        [2,1,0,2], [22, 7]],
        ["[3;7] divided by 4", [1,0,0,4], [22, 7]]]

data.each do |str, ng, r|
  printf "%-20s->", str
  op = NG.new(*ng)
  r2cf(*r) do |n|
    print " #{op.egress}" unless op.needterm?
    op.ingress(n)
  end
  print " #{op.egress_done}" until op.done?
  puts
end
