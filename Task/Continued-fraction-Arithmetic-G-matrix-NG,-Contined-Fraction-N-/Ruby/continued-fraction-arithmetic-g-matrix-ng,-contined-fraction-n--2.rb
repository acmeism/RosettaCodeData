op = NG.new(2,1,0,2)
r2cf(13,11) {|n| if op.needterm? then op.ingress(n) else print "#{op.egress} "; op.ingress(n) end}
while not op.done? do print "#{op.egress_done} " end
