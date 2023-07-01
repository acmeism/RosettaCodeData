function integral = leftRectIntegration(f,a,b,n)

    format long;
    width = (b-a)/n; %calculate the width of each devision
    x = linspace(a,b,n); %define x-axis
    integral = width * sum( f(x(1:n-1)) );

end
