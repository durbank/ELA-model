% Function to take previously generated and saved glacier morphology data
% and format it for later modeling use

function [glacier_data] = format_inputs(elev_file, width_file)

% Imports and configures data
data = readtable(elev_file, 'HeaderLines', 11);
X_pts = round(data.Var1)+1;
Z_pts = data.Var2;
vX = (0:max(X_pts)+50)';

[Hyp] = hyp(X_pts, Z_pts, vX);

[Hx] = ice_thick(Hyp, 1.5*10^4, vX);

ICE_pts = Z_pts + Hx(X_pts);


w_raw = readtable(width_file, 'HeaderLines', 11);
wX = round(w_raw.Var1)+1;
w_pts = w_raw.Var2;

if length(wX) > length (X_pts)
    
    Z_pts = interp1(X_pts,Z_pts,wX);
    ICE_pts = interp1(X_pts, ICE_pts, wX);
    X_pts = wX;
else 
    
    w_pts = interp1(wX, w_pts, X_pts);


glacier_data = struct('X_dist', X_pts, 'bed', Z_pts, ...
    'ice_surf', ICE_pts, 'width', w_pts);
% glacier_data = struct('bed', [X_pts Z_pts], ...
%     'ice_surf', [X_pts ICE_pts], 'width', [X_pts, w_pts]);

end