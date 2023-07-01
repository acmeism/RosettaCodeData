define stat1(a) => {
	if(#a->size) => {
		local(mean = (with n in #a sum #n) / #a->size)
		local(sdev = math_pow(((with n in #a sum Math_Pow((#n - #mean),2)) / #a->size),0.5))
		return (:#sdev, #mean)
	else
		return (:0,0)
	}
}
define stat2(a) => {
	if(#a->size) => {
		local(sx = 0, sxx = 0)
		with x in #a do => {
			#sx += #x
			#sxx += #x*#x
		}
		local(sdev = math_pow((#a->size * #sxx - #sx * #sx),0.5) / #a->size)
		return (:#sdev, #sx / #a->size)
	else
		return (:0,0)
	}
}
define histogram(a) => {
	local(
		out = '\r',
		h = array(0,0,0,0,0,0,0,0,0,0,0),
		maxwidth = 50,
		sc = 0
	)
	with n in #a do => {
		#h->get(integer(#n*10)+1) += 1
	}
	local(mx = decimal(with n in #h max #n))
	with i in #h do => {
		#out->append((#sc/10.0)->asString(-precision=1)+': '+('+' * integer(#i / #mx * #maxwidth))+'\r')
		#sc++
	}
	return #out
}

with scale in array(100,1000,10000,100000) do => {^
	local(n = array)
	loop(#scale) => { #n->insert(decimal_random) }
	local(sdev1,mean1) = stat1(#n)
	local(sdev2,mean2) = stat2(#n)
	#scale' numbers:\r'
    'Naive  method: sd: '+#sdev1+', mean: '+#mean1+'\r'
    'Second  method: sd: '+#sdev2+', mean: '+#mean2+'\r'
    histogram(#n)
    '\r\r'
^}
