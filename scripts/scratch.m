% Script to generate ELA results and plots for validation glaciers

% Add /src directory to path
addpath(fullfile("../src/"))

input_dir = fullfile("../Data/silvretta");

elev_file = fullfile(input_dir, 'bed_elev.csv');
width_file = fullfile(input_dir, 'width.csv');


[glacier_data] = format_inputs(elev_file, width_file);


[glacier_main, vX, Hyp, Hx, Width, vELA] = ELA_calc(glacier_data, 1000);