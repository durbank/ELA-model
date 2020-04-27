function [Hyp] = hyp(X_pts, Z_pts, vX)
f = fit(X_pts, Z_pts, 'exp2');
coeff = coeffvalues(f);
Hyp = coeff(1)*exp(coeff(2)*vX) + coeff(3)*exp(coeff(4)*vX);
Hyp(Hyp<0) = 0;
end