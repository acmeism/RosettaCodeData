function z = rootsOfUnity(n)

    assert(n >= 1,'n >= 1');
    z = roots([1 zeros(1,n-1) -1]);

end
