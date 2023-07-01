function integral = rightRectIntegration(f,a,b,n)

    format long;
    width = (b-a)/n; %calculate the width of each devision
    x = linspace(a,b,n); %define x-axis
    integral = width * sum( f(x(2:n)) );

end
