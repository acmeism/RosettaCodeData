function text = rot13(text)
    if ischar(text)

        selectedLetters = ( (text >= 'A') & (text <= 'Z') ); %Select upper case letters
        text(selectedLetters) = char( mod( text(selectedLetters)-'A'+13,26 )+'A' );

        selectedLetters = ( (text >= 'a') & (text <= 'z') ); %Select lower case letters
        text(selectedLetters) = char( mod( text(selectedLetters)-'a'+13,26 )+'a' );

    else
        error('Argument must be a string.')
    end
end
