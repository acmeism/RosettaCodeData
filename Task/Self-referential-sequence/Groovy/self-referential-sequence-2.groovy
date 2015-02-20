def max = maxSeqSize(0..<1000000)

println "\nLargest sequence size among seeds < 1,000,000\n"
println "Seeds: ${max.seeds}\n"
println "Size: ${max.seqSize}\n"
println "Sample sequence:"
max.seeds[0].selfReferentialSequence.each { println it }
