""" rosettacode.org/wiki/Simulated_optics_experiment/Simulator """

using Pipe

"""
    Simulate an output which is randomly either [0, 90] or [90, 0].
    Log to the first integer in outputlogline.
"""
function pairedlightsource!(outputlogline)
    zeroleft = rand([false, true])
    outputlogline[begin] = zeroleft
    return zeroleft ? [0, 90] : [90, 0]
end

"""
    Given either [0, 90] or [90, 0] output a 2 X 2 matrix of outputs
    using degrees for sind and cosd functions.
    Logs output of the random choices to 2nd and 3rd integers in outputlogline.
"""
function beamsplitters!(outputlogline, lightsources, settings)
    output, choices = zeros(length(lightsources), 2), rand([0, 1], length(lightsources))
    for i in eachindex(lightsources)
        outputlogline[begin + i] = choices[i]
        ang = settings[i][choices[i] + 1]
        output[i, :] .= (cosd(ang - lightsources[i]), abs(sind(ang - lightsources[i])))
    end
    return output
end

"""
    Given a 2 X 2 matrix of reals between 0 and 1, output a vector of 4 Bool values
    depending whether the squares of each value is <= or > an individually generated
    uniform random value between 0 and 1.
    Logs output of the random choices to 4th through 7th integers in outputlogline.
"""
function lightdetectors!(outputlogline, splitsources)
    for (i, src) in enumerate(splitsources)
        outputlogline[begin + 2 + i] = src * src <= rand()
    end
    return outputlogline
end

"""
    Run the simulation. Output is in the format as quoted from task:

    (quote)
    The program must output its "raw data" results in the format shown here by example:

        3
        0 1 1 0 0 1 1
        1 1 0 1 1 0 1
        0 0 1 0 0 1 1
        The first line is how many pulses were emitted by the light source. (You should have
        this be at least 1000. The number 3 here is for the sake of depicting the format.)
        This line is followed by that many more lines, each of which contains seven "0"s and "1"s,
        separated from each other by one space character. The seven entries, left to right,
        represent the following data, one line for each light pulse pair emitted by the source:

        The log recording of the light source setting.
        The log recording of the setting of the polarizing beam splitter that is on the left.
        The log recording of the setting of the polarizing beam splitter that is on the right.
        The output of the light detector on the left that is receiving the "cosine" pulses.
        The output of the light detector on the left that is receiving the "sine" pulses.
        The output of the light detector on the right that is receiving the "cosine" pulses.
        The output of the light detector on the right that is receiving the "sine" pulses.
    (end quote)

    If `datalogfile` is provided as a named argment, write output lines to that file.
"""
function lightsimulator(npulses; settings = [[0, 45], [22.5, 67.5]], datalogfile = "")
    simulatorloglines = zeros(Bool, npulses, 7) # log line entries must be either 0 or 1

    @Threads.threads for a in eachrow(simulatorloglines)
        @pipe pairedlightsource!(a) |> beamsplitters!(a, _, settings) |> lightdetectors!(a, _)
    end

    println(npulses)
    if npulses < 50 # don't print them all if this is a large number of data points
        foreach(a -> println(join(Int.(a), " ")), eachrow(simulatorloglines))
    end

    # if we need to save output to a data file
    if datalogfile != ""
        fh = open(datalogfile, write = true)
        println(fh, npulses)
        for a in eachrow(simulatorloglines)
            println(fh, join(string.(Int.(a)), " "))
        end
        close(fh)
    end
end

lightsimulator(1_000_000, datalogfile = "datalog.log")
