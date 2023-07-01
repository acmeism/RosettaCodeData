function integral = trapezoidalIntegration(f,a,b,n)

    format long;
    x = linspace(a,b,n); %define x-axis
    integral = trapz( x,f(x) );

end
