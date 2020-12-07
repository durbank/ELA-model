% Example script for using the ELA model on glacier geomorphic data

% Define project ROOT directory
ROOT_DIR = fileparts(pwd());

% Add /src directory to path
addpath(fullfile(ROOT_DIR, 'src/'))

% Define Data directory
DATA_DIR = fullfile(ROOT_DIR, 'Data/Rhone');

% Define data files within data directory
elev_file = fullfile(DATA_DIR, 'bed_elev.csv');
width_file = fullfile(DATA_DIR, 'width.csv');

% Properly format input data for processing
[glacier_data] = format_inputs(elev_file, width_file);
    
% Estimate glacier ELA    
[~, vX, Hyp, Width, Hx, vELA] = ELA_calc(glacier_data, 1000);

%% Plot results


% Plot the modeled bed topography
figure
hold on
shadedErrorBar(vX, median(Hyp,2), std(Hyp,[],2), 'black')
scatter(glacier_data.Bed_pts(:,1), glacier_data.Bed_pts(:,2), 25, ...
    'filled', 'k')

% Plot the modeled glacier plan profile
figure
hold on
shadedErrorBar(vX, (1/2)*median(Width,2), std(Width,[],2), 'red')
shadedErrorBar(vX, -(1/2)*median(Width,2), std(Width,[],2), 'red')
scatter(glacier_data.Width_pts(:,1), (1/2)*glacier_data.Width_pts(:,2), ...
    25, 'filled', 'r')
scatter(glacier_data.Width_pts(:,1), -(1/2)*glacier_data.Width_pts(:,2), ...
    25, 'filled', 'r')

% Plot the modeled ice surface
figure
hold on
plot(vX, median(Hyp,2), 'black')
shadedErrorBar(vX, median(Hyp,2) + median(Hx,2), std(Hx,[],2), 'blue')
scatter(glacier_data.Ice_surf(:,1), glacier_data.Ice_surf(:,2), ...
    25, 'filled', 'blue')

figure
hold on
ksdensity(vELA)
