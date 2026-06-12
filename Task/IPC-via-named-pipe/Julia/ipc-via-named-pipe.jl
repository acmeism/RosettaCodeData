import Random: shuffle!

const words = shuffle!(strip.(eachline("words.txt")))

mutable struct FIFO
    infifo::Channel{String}
    outfifo::Channel{Int}
    running::Bool
end
const fifos = FIFO(Channel{String}(10), Channel{Int}(1), true)

function send(wordlist = words)
    nread = 0
    for word in wordlist
        nread += 1
        put!(fifos.infifo, word)
        if !fifos.running
            close(fifos.infifo)
            break
        end
        sleep(0.005 * rand())  # Simulate some delay
    end
end

function recieve()
    put!(fifos.outfifo, 0)
    while true
        word = take!(fifos.infifo)
        total = length(word) + take!(fifos.outfifo)
        put!(fifos.outfifo, total)
        if !fifos.running
            close(fifos.outfifo)
            sleep(0.2)
            break
        end
        sleep(0.005 * rand())  # Simulate some delay
    end
end

# start the I/O routines
@async send()
@async recieve()
sleep(3)  # Let the threads run for a while

total = fetch(fifos.outfifo)
fifos.running = false  # Signal to stop processing
println("Final total letters processed: ", total)
