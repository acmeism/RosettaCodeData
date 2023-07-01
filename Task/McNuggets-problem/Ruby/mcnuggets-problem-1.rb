def mcnugget(limit)
  sv = (0..limit).to_a

  (0..limit).step(6) do |s|
    (0..limit).step(9) do |n|
      (0..limit).step(20) do |t|
        sv.delete(s + n + t)
      end
    end
  end

  sv.max
end

puts(mcnugget 100)
