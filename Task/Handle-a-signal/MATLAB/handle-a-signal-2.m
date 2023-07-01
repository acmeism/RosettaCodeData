function sigintHandle
    k = 1;
    tic
    try
        while true
            pause(0.5)
            fprintf('%d\n', k)
            k = k+1;
        end
    catch me
        toc
        rethrow me
    end
end
