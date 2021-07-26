function [f, df] = poly_fit(func, order)
% [f, df] = poly_fit(func, order) starting from a function 'func', computes a polynomial fitting of order 'order',
% together with its derivative.

%   func - function to fit.
%   order - order of the polynomial fitting.
%   f - polynomial fitting.
%   df - derivative of the polynomial fitting.

    x = linspace(0, length(func)-1, length(func));
    p = polyfit(x, func, order);
    q = polyder(p);
    f = polyval(p, x);
    xq = linspace(0, length(f)-1, length(f));
    df = polyval(q, xq);
end