function speak(sentence, cmd = "/utl/espeak.bat")
    for word in split(sentence)
        s = replace(lowercase(word), r"[^a-z]" => "")
        if length(s) > 0
            print(uppercase(s))
            run(`$cmd $s`)
            sleep(1)
            print("\b"^length(s))
        end
        print(word, " ")
    end
end

speak("Are those 144 shy Eurasian footwear, cowboy chaps, or jolly earthmoving headgear?")
