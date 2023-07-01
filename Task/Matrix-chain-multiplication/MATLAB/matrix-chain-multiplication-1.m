function [r,s] = optim(a)
    n = length(a)-1;
    u = zeros(n,n);
    v = ones(n,n)*inf;
    u(:,1) = -1;
    v(:,1) = 0;
    for j = 2:n
        for i = 1:n-j+1
            for k = 1:j-1
                c = v(i,k)+v(i+k,j-k)+a(i)*a(i+k)*a(i+j);
                if c<v(i,j)
                    u(i,j) = k;
                    v(i,j) = c;
                end
            end
        end
    end
    r = v(1,n);
    s = aux(u,1,n);
end

function s = aux(u,i,j)
    k = u(i,j);
    if k<0
        s = sprintf("%d",i);
    else
        s = sprintf("(%s*%s)",aux(u,i,k),aux(u,i+k,j-k));
    end
end
