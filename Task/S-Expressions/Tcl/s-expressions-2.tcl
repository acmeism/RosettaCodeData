set sample {((data "quoted data" 123 4.5)
 (data (!@# (4.5) "(more" "data)")))}
set parsed [fromSexp $sample]
puts "sample: $sample"
puts "parsed: $parsed"
puts "regen: [toSexp $parsed]"
