function sigintHandle
    k = 1;
    tic
    catchObj = onCleanup(@toc);
    while true
        pause(0.5)
        fprintf('%d\n', k)
        k = k+1;
    end
end
