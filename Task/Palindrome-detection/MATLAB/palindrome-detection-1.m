function trueFalse = isPalindrome(string)

    trueFalse = all(string == fliplr(string)); %See if flipping the string produces the original string

    if not(trueFalse) %If not a palindrome
        string = lower(string); %Lower case everything
        trueFalse = all(string == fliplr(string)); %Test again
    end

    if not(trueFalse) %If still not a palindrome
        string(isspace(string)) = []; %Strip all space characters out
        trueFalse = all(string == fliplr(string)); %Test one last time
    end

end
