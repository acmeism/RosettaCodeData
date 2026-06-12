class OHalloranNumbers
  def self.main
    maximum_area = 1_000
    half_maximum_area = maximum_area / 2

    ohalloran_numbers = Array.new(half_maximum_area, true)

    (1...maximum_area).each do |length|
      (1...half_maximum_area).each do |width|
        (1...half_maximum_area).each do |height|
          half_area = length * width + length * height + width * height
          ohalloran_numbers[half_area] = false if half_area < half_maximum_area
        end
      end
    end

    puts "Values larger than 6 and less than 1,000 which cannot be the surface area of a cuboid:"
    (3...half_maximum_area).each do |i|
      print "#{i * 2} " if ohalloran_numbers[i]
    end
    puts
  end
end

OHalloranNumbers.main
