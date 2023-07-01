function A = ackermannFunction(m,n)
    if m == 0
        A = n+1;
    elseif (m > 0) && (n == 0)
        A = ackermannFunction(m-1,1);
    else
        A = ackermannFunction( m-1,ackermannFunction(m,n-1) );
    end
end
