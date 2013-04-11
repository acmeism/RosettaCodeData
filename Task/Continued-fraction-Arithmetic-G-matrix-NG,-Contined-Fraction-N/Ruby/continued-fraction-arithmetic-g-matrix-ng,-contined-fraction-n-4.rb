op = NG.new(1,0,0,4)
r2cf(22,7) {|n| if op.needterm? then op.ingress(n) else print "#{op.egress} "; op.ingress(n) end}
while not op.done? do print "#{op.egress_done} " end
