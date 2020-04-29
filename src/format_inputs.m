% Function to take previously generated and saved glacier morphology data
% and format it for later modeling use

function [glacier_data] = format_inputs(elev_file, width_file)

% Imports and configures slope data
data = readtable(elev_file, 'HeaderLines', 1);
X_pts = round(data.Var1)+1;
Z_pts = data.Var2;

% Import and configure width data
w_raw = readtable(width_file, 'HeaderLines', 1);
wX = round(w_raw.Var1)+1;
w_pts = w_raw.Var2;

% Find max length of glacier and generate 
L_max = max([max(X_pts) max(wX)]);
vX = (0:L_max)';

% Calculate ice thickness along the glacier
[Hyp] = hyp(X_pts, Z_pts, vX);
[Hx] = ice_thick(Hyp, 1.5*10^4, vX);

% Extract ice thickness as measured points
ICE_pts = Z_pts + Hx(X_pts);

% if length(wX) > length (X_pts)
%     
%     Z_pts = interp1(X_pts,Z_pts,wX);
%     ICE_pts = interp1(X_pts, ICE_pts, wX);
%     X_pts = wX;
% else 
%     
%     w_pts = interp1(wX, w_pts, X_pts);

% Create structure of glacier measurements
glacier_data = struct('X_dist', vX, 'Bed_pts', [X_pts Z_pts], ...
    'Ice_surf', [X_pts ICE_pts], 'Width_pts', [wX w_pts]);

end