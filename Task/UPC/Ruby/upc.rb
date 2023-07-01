DIGIT_F = {
    "   ## #" => 0,
    "  ##  #" => 1,
    "  #  ##" => 2,
    " #### #" => 3,
    " #   ##" => 4,
    " ##   #" => 5,
    " # ####" => 6,
    " ### ##" => 7,
    " ## ###" => 8,
    "   # ##" => 9,
}

DIGIT_R = {
    "###  # " => 0,
    "##  ## " => 1,
    "## ##  " => 2,
    "#    # " => 3,
    "# ###  " => 4,
    "#  ### " => 5,
    "# #    " => 6,
    "#   #  " => 7,
    "#  #   " => 8,
    "### #  " => 9,
}

END_SENTINEL = "# #"
MID_SENTINEL = " # # "

def decode_upc(s)
    def decode_upc_impl(input)
        upc = input.strip
        if upc.length != 95 then
            return false
        end

        pos = 0
        digits = []
        sum = 0

        # end sentinel
        if upc[pos .. pos + 2] == END_SENTINEL then
            pos += 3
        else
            return false
        end

        # 6 left hand digits
        for i in 0 .. 5
            digit = DIGIT_F[upc[pos .. pos + 6]]
            if digit == nil then
                return false
            else
                digits.push(digit)
                sum += digit * [1, 3][digits.length % 2]
                pos += 7
            end
        end

        # mid sentinel
        if upc[pos .. pos + 4] == MID_SENTINEL then
            pos += 5
        else
            return false
        end

        # 6 right hand digits
        for i in 0 .. 5
            digit = DIGIT_R[upc[pos .. pos + 6]]
            if digit == nil then
                return false
            else
                digits.push(digit)
                sum += digit * [1, 3][digits.length % 2]
                pos += 7
            end
        end

        # end sentinel
        if upc[pos .. pos + 2] == END_SENTINEL then
            pos += 3
        else
            return false
        end

        if sum % 10  == 0 then
            print digits, " "
            return true
        else
            print "Failed Checksum "
            return false
        end
    end

    if decode_upc_impl(s) then
        puts "Rightside Up"
    elsif decode_upc_impl(s.reverse) then
        puts "Upside Down"
    else
        puts "Invalid digit(s)"
    end
end

def main
    num = 0

    print "%2d: " % [num += 1]
    decode_upc("         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ")

    print "%2d: " % [num += 1]
    decode_upc("        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ")

    print "%2d: " % [num += 1]
    decode_upc("         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ")

    print "%2d: " % [num += 1]
    decode_upc("       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ")

    print "%2d: " % [num += 1]
    decode_upc("         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ")

    print "%2d: " % [num += 1]
    decode_upc("          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ")

    print "%2d: " % [num += 1]
    decode_upc("         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ")

    print "%2d: " % [num += 1]
    decode_upc("        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ")

    print "%2d: " % [num += 1]
    decode_upc("         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ")

    print "%2d: " % [num += 1]
    decode_upc("        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ")
end

main()
