function pi_str = piSpigot(N)
% Return N digits of pi using Gibbons's first spigot algorithm.
% If N is omitted, the digits are printed ad infinitum.
% Uses the expansion
%   pi = sum_{i=0} (i!)^2 2^{i+1} /(2i+1)!
%      = 2 + 1/3 * ( 2 + 2/5 * (2 + 3/7 * ( 2 + 4/9 * ( ..... )))))
%      = (2 + 1/3 *)(2 + 2/5 *)(2 + 3/7 *)...
% where the terms in the last expression represent Linear Fractional
% Transforms (LFTs).
%
% Requires the Variable Precision Integer (vpi) Toolbox
%
% Reference:
% "Unbounded Spigot Algorithms for the Digits of Pi" by J. Gibbons, 2004
% American Mathematical Monthly, vol. 113.
if nargin < 1
    N = Inf;
    lineLength = 50;
else
    pi_str = repmat(' ',1,N);
end

q = vpi(1);
r = vpi(0);
t = vpi(1);
k = 1; % If printing more than 3E15 digits, use k = vpi(1);

i = 1;
first_digit = true;
while i <= N
    threeQplusR = 3*q + r;
    n = double(threeQplusR / t);
    if q+threeQplusR < (n+1)*t
        d = num2str(n);
        if isinf(N)
            fprintf(1,'%s', d);
            if first_digit
                fprintf(1,'.');
                first_digit = false;
                i = i+1;
            end
            if i == lineLength
                fprintf(1,'\n');
                i = 0;
            end
        else
            pi_str(i) = d;
        end
        q = 10*q;
        r = 10*(r-n*t);
        i = i + 1;
    else
        t = (2*k+1)*t;
        r = (4*k+2)*q + (2*k+1)*r;
        q = k*q;
        k = k + 1;
    end
end
end
