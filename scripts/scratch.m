% Script to generate ELA results and plots for validation glaciers

% Add /src directory to path
addpath(fullfile("../src/"))

input_dir = fullfile("../Data/silvretta");


[topo_pts] = extract(fullfile(input_dir, 'bed_elev.csv'));