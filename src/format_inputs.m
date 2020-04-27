% Function to take previously generated and saved glacier morphology data
% and format it for later modeling use

function [glacier_data] = extract_data(input_dir)

bed_pts = readtable(fullfile(input_dir, 'bed_elev.csv'), ...
    'HeaderLines', 11);
ice_pts = readtable(fullfile(input_dir, 'ice_surf.csv'), ...
    'HeaderLines', 11);
W_pts = readtable(fullfile(input_dir, 'width.csv'), ...
    'HeaderLines', 11);

x_max = round(max([max(bed_pts.Var1) max(ice_pts.Var1) max(W_pts.Var1)]));
X_pts = 0:100:x_max;

end