const queries = [("Printer does not print",  0b11110000),
                 ("A red light is flashing", 0b11001100),
                 ("Printer is unrecognised", 0b10101010)]

const answers = Dict(0b00100000 => "Check the power cable",
                     0b10100000 => "Check the printer-computer cable",
                     0b10101010 => "Ensure printer software is installed",
                     0b11001100 => "Check/replace ink",
                     0b01010000 => "Check for paper jam",
                     0b00000001 => "Cannot diagnose any problem.")

function ynprompt(prompt)
    while true
        print(prompt, "?: ")
        if (ans = strip(uppercase(readline()))[1]) in ['Y', 'N']
            return ans
        end
    end
end

function decide(queries, answers)
    cond = 0b11111111
    for (prompt, value) in queries
        cond &= (ynprompt(prompt) == 'Y' ? value : UInt8(~value))
    end
    for (bitpat, diagnosis) in answers
        if cond & bitpat != 0
            println(diagnosis)
        end
    end
end

decide(queries, answers)
