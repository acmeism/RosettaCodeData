program wordsContainingTheSubstring(input, output);
var
    word: string(22);
begin
    while not EOF do
    begin
        readLn(word);

        if (length(word) > 11) and_then (index(word, 'the') > 0) then
        begin
            writeLn(word)
        end
    end
end.
