function testRK4Programs
    figure
    hold on
    t = 0:0.1:10;
    y = 0.0625.*(t.^2+4).^2;
    plot(t, y, '-k')
    [tode4, yode4] = testODE4(t);
    plot(tode4, yode4, '--b')
    [trk4, yrk4] = testRK4(t);
    plot(trk4, yrk4, ':r')
    legend('Exact', 'ODE4', 'RK4')
    hold off
    fprintf('Time\tExactVal\tODE4Val\tODE4Error\tRK4Val\tRK4Error\n')
    for k = 1:10:length(t)
        fprintf('%.f\t\t%7.3f\t\t%7.3f\t%7.3g\t%7.3f\t%7.3g\n', t(k), y(k), ...
            yode4(k), abs(y(k)-yode4(k)), yrk4(k), abs(y(k)-yrk4(k)))
    end
end

function [t, y] = testODE4(t)
    y0 = 1;
    y = ode4(@(tVal,yVal)tVal*sqrt(yVal), t, y0);
end

function [t, y] = testRK4(t)
    dydt = @(tVal,yVal)tVal*sqrt(yVal);
    y = zeros(size(t));
    y(1) = 1;
    for k = 1:length(t)-1
        dt = t(k+1)-t(k);
        dy1 = dt*dydt(t(k), y(k));
        dy2 = dt*dydt(t(k)+0.5*dt, y(k)+0.5*dy1);
        dy3 = dt*dydt(t(k)+0.5*dt, y(k)+0.5*dy2);
        dy4 = dt*dydt(t(k)+dt, y(k)+dy3);
        y(k+1) = y(k)+(dy1+2*dy2+2*dy3+dy4)/6;
    end
end
