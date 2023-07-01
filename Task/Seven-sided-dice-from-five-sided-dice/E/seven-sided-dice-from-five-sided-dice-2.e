def bins := ([0] * 7).diverge()
for x in 1..1000 {
  bins[dice7() - 1] += 1
}
println(bins.snapshot())
