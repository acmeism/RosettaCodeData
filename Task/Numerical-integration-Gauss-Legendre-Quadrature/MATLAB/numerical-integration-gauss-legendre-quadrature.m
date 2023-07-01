%Print the result.
disp(GLGD_int(@(x) exp(x), -3, 3, 5));

%Integration using Gauss-Legendre quad
%Does almost the same as 'integral' in MATLAB
function y=GLGD_int(fun,xmin,xmax,n)
%fun: the intergrand as a function handle
%xmin: lower boundary of integration
%xmax: upper boundary of integration
%n: order of polynomials used (number of integration ponts)
[x_IP,weight]=GLGD_para(n);
%assign global coordinates to the integraton points
x_eval=x_IP*(xmax-xmin)/2+(xmax+xmin)/2;
y=0;
for aa=1:n
    y=y+feval(fun,x_eval(aa))*weight(aa)*(xmax-xmin)/2;
end
end

function [x_IP,weight]=GLGD_para(n)
%n: the order of the polynomial
x_IP=legendreRoot(n,10^(-16));
weight=2./(1-x_IP.^2)./diff_legendrePoly(x_IP,n).^2;
end

%roots of the Legendre Polynomial using Newton-Raphson
function x_IP=legendreRoot(n,tol)
%n: order of the polynomial
%tol: tolerence of the error
if n<2
    disp('No root can be found');
else
    root=zeros(1,floor(n/2));
    for aa=1:floor(n/2) %iterate to find half of the roots
        x=cos(pi*(aa-0.25)/(n+0.5));
        err=10*tol;
        iter=0;
        while (err>tol)&&(iter<1000)
            dx=-legendrePoly(x,n)/diff_legendrePoly(x,n);
            x=x+dx;
            iter=iter+1;
            err=abs(legendrePoly(x,n));
        end
        root(aa)=x;
    end
    if mod(n,2)==0
        x_IP=[-1*root,root];
    else
        x_IP=[-1*root,0,root];
    end
    x_IP=sort(x_IP);
end
end

%derivative of the Legendre Polynomial
function y=diff_legendrePoly(x_IP,n)
%n: order of the polynomial
%x_IP: coordinates of the integration points
if n==0
    y=0;
else
    y=n./(x_IP.^2-1).*(x_IP.*legendrePoly(x_IP,n)-legendrePoly(x_IP,n-1));
end
end

%Produces Legendre Polynomials
function y=legendrePoly(x,n)
%n: order of polynomial
%x: input x
if n==0
    y=1;
elseif n==1
    y=x;
else
    y=((2*n-1).*x.*legendrePoly(x,n-1)-(n-1)*legendrePoly(x,n-2))/n;
end
end
