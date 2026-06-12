def penholodigitals (base)
  base = base.to_i64
  all_digits = (0...base-1).sum(0_i64) {|exp| base ** exp } * base  # 1111111110
  start = Math.isqrt((0...base-1).sum(0_i64) {|exp| base**exp * (base - exp - 1) }) # √123456789
  stop  = Math.isqrt((0...base-1).sum(0_i64) {|exp| base**exp * (exp + 1) })        # √987654321
  (start..stop).compact_map {|n|
    square = n*n
    digits = 0_i64
    while square > 0
      digits += base**(square % base)
      square //= base
    end
    n if digits == all_digits
  }
end

(9..15).each do |base|
  pds = penholodigitals(base)
  puts "#{pds.size} penholodigital square#{pds.size==1 ? "" : "s"} in base #{base}:"
  if base <= 12
    pds.map {|n| "#{n.to_s(base)}² = #{(n*n).to_s(base)}"}.each_slice(3) do |slice|
      puts "  " + slice.join("   ")
    end
  else
    first_last = [pds.pop?, pds.shift?].reverse
    if first_last.any?
      puts first_last.zip(["First", "Last"]).map {|n, label|
        formula = n ? "#{n.to_s(base)}² = #{(n*n).to_s(base)}" : ""
        "#{label} = #{formula}"
      }.join("  ")
    end
  end
  puts
end
