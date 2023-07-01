function v = fibonacci(n)
assert(n >= 0)
v = fibonacci(n,0,1);

    % nested function
    function a = fibonacci(n,a,b)
        if n ~= 0
            a = fibonacci(n-1,b,a+b);
        end
    end
end
