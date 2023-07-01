function nonSquares(i)

    for n = (1:i)

        generatedNumber = n + floor(1/2 + sqrt(n));

        if mod(sqrt(generatedNumber),1)==0 %Check to see if the sqrt of the generated number is an integer
            fprintf('\n%d generates a square number: %d\n', [n,generatedNumber]);
            return
        else %If it isn't then the generated number is a square number
            if n<=22
                fprintf('%d ',generatedNumber);
            end
        end
    end

    fprintf('\nNo square numbers were generated for n <= %d\n',i);

end
