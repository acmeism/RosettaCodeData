require 'prime'

deceptives = Enumerator.new do |y|
  10.step(by: 10) do |n|
    [1,3,7,9].each do |digit|
      cand = n + digit
      next if cand % 3 == 0 || cand.prime?
      repunit = ("1"*(cand-1)).to_i
      y << cand if (repunit % cand) == 0
    end
  end
end

p deceptives.take(25).to_a
