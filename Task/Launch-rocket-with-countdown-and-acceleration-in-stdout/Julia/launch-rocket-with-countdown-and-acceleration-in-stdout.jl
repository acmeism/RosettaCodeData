rocket() = println("        /..\\\n        |==|\n        |  |\n        |  |\n",
    "        |  |\n       /____\\\n       |    |\n       |SATU|\n       |    |\n",
    "       |    |\n      /| |  |\\\n     / | |  | \\\n    /__|_|__|__\\\n       /_\\/_\\\n")

exhaust() = println("       *****")
cls() = print("\x1B[2J")
curup(n) = print("\e[$(n)A")
curdown(n) = print("\e[$(n)B")

function countdown(secs)
    print("Countdown...T minus ")
    for i in secs:-1:1
        print(i, "... ")
        sleep(1)
    end
    print("LIFTOFF!")
end

engineburn(rows) = (println("\n"); for i in 1:rows exhaust(); sleep(0.9^i); end)

testrocket() = (cls(); rocket(); curup(16); countdown(5); curdown(13); engineburn(30))

testrocket()
