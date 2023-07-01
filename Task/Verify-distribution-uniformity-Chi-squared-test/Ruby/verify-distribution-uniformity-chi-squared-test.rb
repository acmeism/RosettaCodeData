def gammaInc_Q(a, x)
  a1, a2 = a-1, a-2
  f0  = lambda {|t| t**a1 * Math.exp(-t)}
  df0 = lambda {|t| (a1-t) * t**a2 * Math.exp(-t)}

  y = a1
  y += 0.3  while f0[y]*(x-y) > 2.0e-8 and y < x
  y = x  if y > x

  h = 3.0e-4
  n = (y/h).to_i
  h = y/n
  hh = 0.5 * h
  sum = 0
  (n-1).step(0, -1) do |j|
    t = h * j
    sum += f0[t] + hh * df0[t]
  end
  h * sum / gamma_spounge(a)
end

A = 12
k1_factrl = 1.0
coef = [Math.sqrt(2.0*Math::PI)]
COEF = (1...A).each_with_object(coef) do |k,c|
  c << Math.exp(A-k) * (A-k)**(k-0.5) / k1_factrl
  k1_factrl *= -k
end

def gamma_spounge(z)
  accm = (1...A).inject(COEF[0]){|res,k| res += COEF[k] / (z+k)}
  accm * Math.exp(-(z+A)) * (z+A)**(z+0.5) / z
end

def chi2UniformDistance(dataSet)
  expected = dataSet.inject(:+).to_f / dataSet.size
  dataSet.map{|d|(d-expected)**2}.inject(:+) / expected
end

def chi2Probability(dof, distance)
  1.0 - gammaInc_Q(0.5*dof, 0.5*distance)
end

def chi2IsUniform(dataSet, significance=0.05)
  dof = dataSet.size - 1
  dist = chi2UniformDistance(dataSet)
  chi2Probability(dof, dist) > significance
end

dsets = [ [ 199809, 200665, 199607, 200270, 199649 ],
          [ 522573, 244456, 139979,  71531,  21461 ] ]

for ds in dsets
  puts "Data set:#{ds}"
  dof = ds.size - 1
  puts "  degrees of freedom: %d" % dof
  distance = chi2UniformDistance(ds)
  puts "  distance:           %.4f" % distance
  puts "  probability:        %.4f" % chi2Probability(dof, distance)
  puts "  uniform?            %s" % (chi2IsUniform(ds) ? "Yes" : "No")
end
