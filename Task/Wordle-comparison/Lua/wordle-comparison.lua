-- Rosetta Code Task - Wordle Comparison
test_pairs = {
    { "ALLOW", "LOLLY" },
    { "BULLY", "LOLLY" },
    { "ROBIN", "ALERT" },
    { "ROBIN", "SONIC" },
    -- Allow case sensitive words
    { "Allow", "Lolly" },
    { "McKay", "MCKAY" },
    { "Robin", "ROBIN" },
    -- Allow numbers
    { "12234", "23225" },
    { "67225", "12225" },
    { "83690", "14587" },
    { "83690", "13092" },
    -- Allow longer words
    { "ROSETTA", "TESTATE" },
    { "Chipmunk", "Civilize" },
    -- Allow other ASCII printing characters
    -- ! $ % & * + - . / : < = > ? @ ^ _ ~
    -- " # ' ( ) , ; [ \ ] ` { | }
    -- Words
    { "Yell!", "Feel?" },
    { "%Interest", "@The_Bank" },
    { "We're", "She's" },
    { "Let's", "Don't" },
    -- Not words
    { "!$$%&", "$%$$*" },
    { "!$%&*+-./:<=>?@^_~", "!$%&*+-./:<=>?@^_~" },
    { '"#([{', '";#,;' },
    { "\"#'(),;[\\]`{|}", "\"#'(),;[\\]`{|}" },
    -- Thus allowing all characters from "!" to "~"
    --     per Rosetta Code Task requirement
    -- Allow multiple unbalanced quotes including Lua "[[" inside strings
    { [=['foo[[bar"\x]=], [=['baz[[foo"\x]=] },
}

-- Format array as list for printing
function format_array(t)
    return "(" .. table.concat(t, " ") .. ")"
end

function string_to_char_array(str)
    local i = 0
    local result = {}
    while i < #str do
        i = i + 1
        result[i] = str:sub(i, i)
    end
    return result
end

function compare_one_letter(target, guess, index)
    local target_char_array = string_to_char_array(target)
    local guess_char_array = string_to_char_array(guess)
    local target_letter = target_char_array[index]
    local guess_letter = guess_char_array[index]
    local i = 1
    local max_i = #target
    local target_unmatched_count = 0
    local guess_unmatched_count = 0
    if guess_letter == target_letter then
        return "green"
    else
        while true do
            if
                (guess_letter == target_char_array[i])
                and (guess_letter ~= guess_char_array[i])
            then
                target_unmatched_count = target_unmatched_count + 1
            end
            if i <= index then
                if
                    (guess_letter == guess_char_array[i])
                    and (guess_letter ~= target_char_array[i])
                then
                    guess_unmatched_count = guess_unmatched_count + 1
                end
            end
            if i >= index then
                if guess_unmatched_count <= target_unmatched_count then
                    return "yellow"
                end
            end
            if i < max_i then
                i = i + 1
            else
                return "grey"
            end
        end
    end
end

function wordle_compare(target, guess)
    local result = {}
    for i = 1, #target, 1 do
        result[i] = compare_one_letter(target, guess, i)
    end
    return result
end

function wordle_compare_test(words)
    for _, v in ipairs(test_pairs) do
        print(
            v[1]
                .. " V "
                .. v[2]
                .. " => "
                .. format_array(wordle_compare(v[1], v[2]))
        )
    end
end

function main()
    print("Rosetta Code Task - Wordle Comparison\n")
    wordle_compare_test(test_pairs)
end

