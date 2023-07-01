function fizzBuzz()
    for i = (1:100)
        if mod(i,15) == 0
           fprintf('FizzBuzz ')
        elseif mod(i,3) == 0
           fprintf('Fizz ')
        elseif mod(i,5) == 0
           fprintf('Buzz ')
        else
           fprintf('%i ',i))
        end
    end
    fprintf('\n');
end
