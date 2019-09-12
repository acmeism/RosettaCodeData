mutable struct Printer
    inputpath::Channel{String}
    errorpath::Channel{String}
    inkremaining::Int32
    reserve::Printer
    name::String
    function Printer(ch1, ch2, ink, name)
        this = new()
        this.inputpath = ch1
        this.errorpath = ch2
        this.inkremaining = ink
        this.name = name
        this.reserve = this
        this
    end
end

function lineprintertask(printer)
    while true
        line = take!(printer.inputpath)
        linesprinted = 0
        if(printer.inkremaining < 1)
            if(printer.reserve == printer)
                put!(printer.errorpath, "Error: printer $(printer.name) out of ink")
            else
                put!(printer.reserve.inputpath, line)
            end
        else
            println(line)
            printer.inkremaining -= 1
        end
    end
end

function schedulework(poems)
    printerclose(printer) = (close(printer.inputpath); close(printer.errorpath))
    reserveprinter = Printer(Channel{String}(1), Channel{String}(10), 5, "Reserve")
    mainprinter = Printer(Channel{String}(1), Channel{String}(10), 5, "Main")
    mainprinter.reserve = reserveprinter
    @async(lineprintertask(mainprinter))
    @async(lineprintertask(reserveprinter))
    printers = [mainprinter, reserveprinter]
    activeprinter = 1
    @sync(
    for poem in poems
        activeprinter = (activeprinter % length(printers)) + 1
        @async(
        for line in poem
            put!(printers[activeprinter].inputpath, line)
        end)
    end)
    for p in printers
        while isready(p.errorpath)
            println(take!(p.errorpath))
        end
        printerclose(p)
    end
end

const humptydumpty = ["Humpty Dumpty sat on a wall.",
                      "Humpty Dumpty had a great fall.",
                      "All the king's horses and all the king's men,",
                      "Couldn't put Humpty together again."]

const oldmothergoose = ["Old Mother Goose,",
                        "When she wanted to wander,",
                        "Would ride through the air,",
                        "On a very fine gander.",
                        "Jack's mother came in,",
                        "And caught the goose soon,",
                        "And mounting its back,",
                        "Flew up to the moon."]

schedulework([humptydumpty, oldmothergoose])
