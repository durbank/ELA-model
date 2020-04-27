function [Width] = width_est(X_pts, W_pts, vX)

func = @(inputs,x) inputs(1)+((inputs(2)-inputs(1))./inputs(3)).*x.*exp(1-x./inputs(3));
[~, W_idx] = max(W_pts);
[~, X_idx] = max(X_pts);
guess = [W_pts(X_idx) max(W_pts) X_pts(W_idx)];
opts = optimset('Display','off');
[inputs,~,residuals,~,~] = lsqcurvefit(func, guess, X_pts, W_pts, [], [], opts);

w0 = inputs(1);
Wmax = inputs(2);
Lwmax = inputs(3);

Width = w0 + ((Wmax - w0)/Lwmax)*vX.*exp(1-vX./Lwmax);
Width(Width<0) = 0;
end