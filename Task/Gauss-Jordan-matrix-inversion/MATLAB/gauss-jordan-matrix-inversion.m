function GaussInverse(M)
    original = M;
    [n,~] = size(M);
    I = eye(n);
    for j = 1:n
        for i = j:n
            if ~(M(i,j) == 0)
                for k = 1:n
                    q = M(j,k); M(j,k) = M(i,k); M(i,k) = q;
                    q = I(j,k); I(j,k) = I(i,k); I(i,k) = q;
                end
                p = 1/M(j,j);
                for k = 1:n
                    M(j,k) = p*M(j,k);
                    I(j,k) = p*I(j,k);
                end
                for L = 1:n
                    if ~(L == j)
                        p = -M(L,j);
                        for k = 1:n
                            M(L,k) = M(L,k) + p*M(j,k);
                            I(L,k) = I(L,k) + p*I(j,k);
                        end
                    end
                end
            end
        end
        inverted = I;
    end
    fprintf("Matrix:\n")
    disp(original)
    fprintf("Inverted matrix:\n")
    disp(inverted)
    fprintf("Inverted matrix calculated by built-in function:\n")
    disp(inv(original))
    fprintf("Product of matrix and inverse:\n")
    disp(original*inverted)
end

A = [ 2, -1,  0;
    -1,  2, -1;
    0, -1,  2 ];

GaussInverse(A)
