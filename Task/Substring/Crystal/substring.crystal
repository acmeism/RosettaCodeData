def substring_demo(string, n, m, known_character, known_substring)
    n -= 1

    puts string[n...n+m]

    puts string[n...]

    puts string.rchop

    known_character_index = string.index(known_character).not_nil!
    puts string[known_character_index...known_character_index+m]

    known_substring_index = string.index(known_substring).not_nil!
    puts string[known_substring_index...known_substring_index+m]
end

substring_demo("crystalline", 3, 5, 't', "st")
