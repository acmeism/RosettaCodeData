const pat1 = ("   ## #", "  ##  #", "  #  ##", " #### #", " #   ##",
              " ##   #", " # ####", " ### ##", " ## ###", "   # ##")
const pat2 = [replace(x, r"[# ]" => (x) -> x == " " ? "#" : " ") for x in pat1]
const ptod1 = Dict((b => a - 1) for (a, b) in enumerate(pat1))
const ptod2 = Dict((b => a - 1) for (a, b) in enumerate(pat2))
const reg = Regex("^\\s*# #\\s*((?:" * join(pat1, "|") *
                  "){6})\\s*# #\\s*((?:" * join(pat2, "|") * "){6})\\s*# #\\s*")
const lines = [
 "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
  "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #      ",
 "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #       ",
   "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
 "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #       ",
"          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #    ",
 "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #     ",
  "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #      ",
 "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
  "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #      ",
]

function decodeUPC(line)
    if (m = match(reg, line)) != nothing
        mats, dig = filter(!isempty, m.captures), Int[]
        for mat in mats
            append!(dig, [ptod1[x.match] for x in eachmatch(r"(.......)", mat)
                if haskey(ptod1, x.match)])
            append!(dig, [ptod2[x.match] for x in eachmatch(r"(.......)", mat)
                if haskey(ptod2, x.match)])
        end
        dsum = sum([(isodd(i) ? 3 : 1) * n for (i, n) in enumerate(dig)])
        (dsum % 10 == 0) && return prod(string.(dig))
    end
    return ""
end

for line in lines
    println((s = decodeUPC(line)) != "" ? s :
            (s = decodeUPC(reverse(line))) != "" ? s : "Invalid")
end
