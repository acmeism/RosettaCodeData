function answer = nthRoot(number,root)

    format long

    answer = number / root;
    guess = number;

    while not(guess == answer)
       guess = answer;
       answer = (1/root)*( ((root - 1)*guess) + ( number/(guess^(root - 1)) ) );
    end

end
