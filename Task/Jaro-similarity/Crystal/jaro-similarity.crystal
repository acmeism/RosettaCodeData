def jaro(s, t)
    return 1.0 if s == t

    s_len = s.size
    t_len = t.size
    match_distance = ({s_len, t_len}.max // 2) - 1

    s_matches = Array.new(s_len, false)
    t_matches = Array.new(t_len, false)
    matches = 0.0

    s_len.times do |i|
        j_start = {0, i - match_distance}.max
        j_end = {i + match_distance, t_len - 1}.min

        (j_start..j_end).each do |j|
            t_matches[j] && next                # -> next if t_matches[j]
            s[i] == t[j] || next                # -> next unless s[i] == t[j]
            s_matches[i] = true
            t_matches[j] = true
            matches += 1.0
            break
        end
    end

    return 0.0 if matches == 0.0

    k = 0
    transpositions = 0.0
    s_len.times do |i|
        s_matches[i] || next                    # -> next unless s_matches[i]
        while ! t_matches[k]; k += 1 end        # -> k += 1 until t_matches[k]
        s[i] == t[k] || (transpositions += 1.0) # -> (transpositions += 1.0) unless s[i] == t[k]
        k += 1
    end

    ((matches / s_len) + (matches / t_len) +
    ((matches - transpositions / 2.0) / matches)) / 3.0
end

%w( MARTHA    MARHTA
    DIXON     DICKSONX
    JELLYFISH SMELLYFISH
  ).each_slice(2) { |(s ,t)| puts "jaro(#{s}, #{t}) = #{"%.10f" % jaro(s, t)}" }
