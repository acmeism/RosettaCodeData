def jaro(s, t)
    return 1.0 if s == t

    s_len = s.size
    t_len = t.size
    match_distance = ([s_len, t_len].max / 2) - 1

    s_matches = []
    t_matches = []
    matches = 0.0

    s_len.times do |i|
        j_start = [0, i-match_distance].max
        j_end = [i+match_distance, t_len-1].min

        (j_start..j_end).each do |j|
            t_matches[j] && next
            s[i] == t[j] || next
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
        s_matches[i] || next
        k += 1 until t_matches[k]
        s[i] == t[k] || (transpositions += 1.0)
        k += 1
    end

    ((matches / s_len) +
     (matches / t_len) +
     ((matches - transpositions/2.0) / matches)) / 3.0
end

%w(
    MARTHA    MARHTA
    DIXON     DICKSONX
    JELLYFISH SMELLYFISH
).each_slice(2) do |s,t|
    puts "jaro(#{s.inspect}, #{t.inspect}) = #{'%.10f' % jaro(s, t)}"
end
