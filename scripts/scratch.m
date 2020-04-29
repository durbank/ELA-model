% Script to generate ELA results and plots for validation glaciers

% Add /src directory to path
addpath(fullfile("../src/"))

% get the folder contents
d_files = dir('../Data/');
d_list = d_files([d_files(:).isdir]==1);
data_dirs = d_list(~ismember({d_list(:).name},{'.','..'}));

ELA_stats = zeros(length(data_dirs), 4);

for i=1:length(data_dirs)
    
    dir_i = fullfile(data_dirs(i).folder, data_dirs(i).name);
    
    elev_file = fullfile(dir_i, 'bed_elev.csv');
    width_file = fullfile(dir_i, 'width.csv');
    
    
    [glacier_data] = format_inputs(elev_file, width_file);
    
    
    [~, vX, Hyp, Hx, Width, vELA] = ELA_calc(glacier_data, 1000);
    
    
    ELA_file = fullfile(dir_i, 'ELAs.csv');
    ela_T = readtable(ELA_file, 'HeaderLines', 1);
    yrs = ela_T.Var1;
    elas = ela_T.Var2;
    yr_idx = yrs >= 1981;
    
    if length(yrs) < 5
        ELA_valid = elas;
        ELA_MoE = 50;
    else
        ELA_valid = detrend(elas(yr_idx)) + mean(elas(yr_idx));
        ELA_MoE = 1.96*std(ELA_valid)/sqrt(length(ELA_valid));
    end
        
    ELA_mu = mean(ELA_valid);
    vELA_med = median(vELA);
    vELA_err = 2*std(vELA);
    
    
    ELA_stats(i,1) = ELA_mu;
    ELA_stats(i,2) = ELA_MoE;
    ELA_stats(i,3) = vELA_med;
    ELA_stats(i,4) = vELA_err;
    
end

%% Validation plots

figure
hold on
grid on
for i=1:length({data_dirs.name})
    err_meas = errorbar(2*(i-1)-0.1, ELA_stats(i,1), ELA_stats(i,2), ...
        'blue', 'LineWidth', 2);
    pt_meas = scatter(2*(i-1)-0.1, ELA_stats(i,1), 50, 'blue', 'filled');
    err_mod = errorbar(2*(i-1)+0.1, ELA_stats(i,3), ELA_stats(i,4), ...
        'red', 'LineWidth', 2);
    pt_mod = scatter(2*(i-1)+0.1, ELA_stats(i,3), 50, 'red', 'filled');
end
legend([err_meas err_mod], {'Measured ELA', 'Modeled ELA'})
ax = gca;
ax.XTick = 0:2:2*length(data_dirs)-1;
ax.XTickLabels = {data_dirs.name};
ax.YLabel.String = "ELA (m a.s.l.)";
hold off
