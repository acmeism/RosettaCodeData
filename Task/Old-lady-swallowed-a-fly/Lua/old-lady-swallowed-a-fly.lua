animals = {"fly", "spider", "bird", "cat","dog", "goat", "cow", "horse"}
phrases = {
    "",
    "That wriggled and jiggled and tickled inside her",
    "How absurd to swallow a bird",
    "Fancy that to swallow a cat",
    "What a hog, to swallow a dog",
    "She just opened her throat and swallowed a goat",
    "I don't know how she swallowed a cow",
    "  ...She's dead of course"
}

for i=0,7 do
    io.write(string.format("There was an old lady who swallowed a %s\n", animals[i+1]))
    if i>0 then io.write(phrases[i+1]) end
    if i==7 then break end
    if i>0 then
        io.write("\n")
        for j=i,1,-1 do
            io.write(string.format("She swallowed the %s to catch the %s", animals[j+1], animals[j]))
            -- if j<4 then p='.' else p=',' end
            -- io.write(string.format("%s\n", p))
            io.write("\n")
            if j==2 then
                io.write(string.format("%s!\n", phrases[2]))
            end
        end
    end
    io.write("I don't know why she swallowed a fly - Perhaps she'll die!\n\n")
end
