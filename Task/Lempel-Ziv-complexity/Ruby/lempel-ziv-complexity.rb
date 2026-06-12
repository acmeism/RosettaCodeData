# frozen_string_literal: true

def lempel_ziv_lz76(s)
  return [0, ''] if s.empty?

  complexity = 0
  pointer = 0
  n = s.size
  subs = +''

  while pointer < n
    complexity += 1
    k = 1
    while pointer + k <= n
      current = s[pointer...pointer + k]
      window = s[0...pointer + k - 1]

      if window.include?(current)
        k += 1
      else
        subs << current << '.'
        pointer += k
        k = 0
        break
      end
    end

    if pointer + k > n
      subs << s[pointer + 1...n]
      pointer = n
    end
  end

  [complexity, subs]
end

TESTS = {
  'AZSEDRFTGYGUJIJOKB' => 16,
  'ABCABCABCABCABCABC' => 4,
  '111011111001111011111001' => 6,
  '101001010010111110' => 5,
  '1001111011000010' => 6,
  '1010101010' => 3,
  '1010101010101010' => 3,
  '1001111011000010000010' => 7,
  '100111101100001000001010' => 8,
  '0001101001000101' => 6,
  '1111111' => 2,
  '0001' => 2,
  '010' => 3,
  '1' => 1,
  '' => 0,
  '01011010001101110010' => 7,
  'ABCDEFGHIJKLMNOPQRSTUVWXYZ' => 26,
  'HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!' => 11
}

TESTS.each do |s, want|
  complexity, subs = lempel_ziv_lz76(s)
  raise "expected #{want}, got #{complexity}" unless complexity == want

  puts "#{subs.rjust(60)}: #{complexity}"
end
