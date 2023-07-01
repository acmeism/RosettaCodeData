import "/fmt" for Fmt

var digitL = {
    "   ## #": 0,
    "  ##  #": 1,
    "  #  ##": 2,
    " #### #": 3,
    " #   ##": 4,
    " ##   #": 5,
    " # ####": 6,
    " ### ##": 7,
    " ## ###": 8,
    "   # ##": 9
}

var digitR = {
    "###  # ": 0,
    "##  ## ": 1,
    "## ##  ": 2,
    "#    # ": 3,
    "# ###  ": 4,
    "#  ### ": 5,
    "# #    ": 6,
    "#   #  ": 7,
    "#  #   ": 8,
    "### #  ": 9
}

var endSentinel = "# #"  //  also at start
var midSentinel = " # # "

var decodeUpc = Fn.new { |s|
    var decodeUpcImpl = Fn.new { |input|
        var upc = input.trim()
        if (upc.count != 95) return false
        var pos = 0
        var digits = []
        var sum = 0
        var oneThree = [1, 3]

        // end sentinel
        if (upc[pos..pos+2] == endSentinel) {
            pos = pos + 3
        } else {
            return false
        }

        // 6 left hand digits
        for (i in 0..5) {
            var digit = digitL[upc[pos..pos+6]]
            if (!digit) return false
            digits.add(digit)
            sum = sum + digit * oneThree[digits.count % 2]
            pos = pos + 7
        }

        // mid sentinel
        if (upc[pos..pos+4] == midSentinel) {
            pos = pos + 5
        } else {
            return false
        }

        // 6 right hand digits
        for (i in 0..5) {
            var digit = digitR[upc[pos..pos+6]]
            if (!digit) return false
            digits.add(digit)
            sum = sum + digit * oneThree[digits.count % 2]
            pos = pos + 7
        }

        // end sentinel
        if (upc[pos..pos+2] != endSentinel) return false

        if (sum%10 == 0) {
            System.write("%(digits) ")
            return true
        }
        System.write("Failed Checksum ")
        return false
    }

    if (decodeUpcImpl.call(s)) {
        System.print("Rightside Up")
    } else if (decodeUpcImpl.call(s[-1..0])) {
        System.print("Upside Down")
    } else {
        System.print("Invalid digit(s)")
    }
}

var barcodes = [
    "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
    "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
    "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
    "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
    "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
    "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
    "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
    "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
    "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
    "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         "
]
var n = 0
for (barcode in barcodes) {
    n = n + 1
    Fmt.write("$2d: ", n)
    decodeUpc.call(barcode)
}
