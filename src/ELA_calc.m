function [glacier_main, vX, Hyp, Hx, Width, vELA] = ELA_calc(glacier_main, nsim, varargin)
% Estimated standard deviations for different inputs
% L_STD = 50;         % STD in length estimate (m)
zSTD = 15;          % STD in elevation estimate (m)
wSTD = 50;          % STD in width estimate (m)
tau_STD = 15000;    % STD in basal shear stress estimate (Pa)

% Glacier data for main glacier trunk
X_pts = glacier_main.X_dist;
Z_pts = glacier_main.bed;
H_pts = glacier_main.ice_surf;
W_pts = glacier_main.width;

% Adds arbitrary number of glacier tributaries into main glacier for ELA
% calculations
for i = 1:length(varargin)
    % Glacier data for iterative glacier tributary
%     X_pts_trib = varargin{i}.X_dist;
    Z_pts_trib = varargin{i}.bed;
    H_pts_trib = varargin{i}.ice_surf;
    W_pts_trib = varargin{i}.width;
    
    % Creates index for the main glacier corresponding to the nearest elevation
    % points of the tributary glacier data
    index = zeros(size(H_pts_trib));
    for j=1:numel(index)
        [~, tmp_idx] = min(abs(Z_pts-Z_pts_trib(j)));
        index(j) = tmp_idx;
    end
    
    % Resizes tributary areal cross section to match main glacier thickness at
    % the corresponding elevation, and adds the tributary's resized width to
    % the main glacier width at the nearest correpsonding elevation
    W_pts_trib_new = W_pts_trib.*H_pts_trib./H_pts(index);
    W_pts(index) = W_pts(index) + W_pts_trib_new;
end

glacier_main.width = W_pts;
%%

% Adds Gaussian error to elevation measurements, and then resamples the
% data (with replacement) for each simulation run
zGauss = repmat(Z_pts, 1, nsim) + normrnd(0, zSTD, [numel(Z_pts) nsim]);
zBoot = zeros(size(zGauss));
zIDX = zeros(size(zGauss));     % Index from where the data was sampled
for i=1:nsim
    Z_temp = zGauss(:,i);
    [zBoot(:,i), zIDX(:,i)] = datasample(Z_temp, numel(Z_temp));
end

zIDX = sort(zIDX);

% Repeats previous calculations, but for width measurements
wGauss = repmat(W_pts, 1, nsim) + normrnd(0, wSTD, [numel(W_pts) nsim]);
wGauss(wGauss<0) = 0;
wBoot = zeros(size(wGauss));
wIDX = zeros(size(wGauss));
for i=1:nsim
    W_temp = wGauss(:,i);
    [wBoot(:,i), wIDX(:,i)] = datasample(W_temp, numel(W_temp));
end

wIDX = sort(wIDX);

% Preallocations for for loop
vX = (0:X_pts(end)+X_pts(1))';
Hyp = zeros(numel(vX), nsim);
Width = zeros(numel(vX), nsim);
Hx = zeros(numel(vX), nsim);
% Lgauss = normrnd(X_pts_main(end)+X_pts_main(1), L_STD, 1, nsim);
vELA = zeros(1, nsim);

for i=1:nsim
    [Hyp(:,i)] = hyp(X_pts(zIDX(:,i)), Z_pts(zIDX(:,i)), vX);
    [Width(:,i)] = width_est(X_pts(wIDX(:,i)), wBoot(:,i), vX);
    [Hx(:,i)] = ice_thick(Hyp(:,1), tau_STD, vX);
    vELA(i) = (trapz(vX, Width(:,i).*Hx(:,i)) +...
        trapz(vX, Width(:,i).*Hyp(:,i)))./trapz(vX, Width(:,i));
end
% for i=1:nsim
%     [Hyp(:,i)] = hyp(X_pts(zIDX(:,i)), zBoot(:,i), vX);
%     [Width(:,i)] = width_est(X_pts(wIDX(:,i)), wBoot(:,i), vX);
%     [Hx(:,i)] = ice_thick(Hyp(:,1), tau_STD, vX);
%     vELA(i) = (trapz(vX, Width(:,i).*Hx(:,i)) +...
%         trapz(vX, Width(:,i).*Hyp(:,i)))./trapz(vX, Width(:,i));
% end

end
