% Script to generate ELA results and plots for validation glaciers

% Add /src directory to path
addpath(genpath(fullfile("../src/")))

% get the folder contents
d_files = dir('../Data/');
d_list = d_files([d_files(:).isdir]==1);
data_dirs = d_list(~ismember({d_list(:).name},{'.','..'}));

ELA_stats = table('Size', [length(data_dirs) 9], 'VariableTypes', ...
    repmat({'double'}, 1,9), ...
    'VariableNames', {'AAR_50', 'AAR_67', 'AMA', 'MEG', ...
    'THAR_35', 'ELA_meas', 'MoE_meas', 'ELA_mod', 'MoE_mod'}, ...
    'RowNames', {data_dirs.name});

% Set seed (for reproducibility)
rng(0)

for i=1:length(data_dirs)
    
    dir_i = fullfile(data_dirs(i).folder, data_dirs(i).name);
    
    elev_file = fullfile(dir_i, 'bed_elev.csv');
    width_file = fullfile(dir_i, 'width.csv');
    
    
    [glacier_data] = format_inputs(elev_file, width_file);
    
    
    [~, vX, Hyp, Width, Hx, vELA] = ELA_calc(glacier_data, 1000);
    
    
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
    
    MEG = median(mean(Hyp,2)+mean(Hx,2));
    wid_i = mean(Width,2);
    ice_surf = mean(Hyp,2) + mean(Hx,2);
    AAR_idx = find(cumsum(wid_i) >= 0.50*sum(wid_i),1,'first');
    ELA_aar50 = ice_surf(AAR_idx);
    AAR_idx = find(cumsum(wid_i) >= 0.67*sum(wid_i),1,'first');
    ELA_aar67 = ice_surf(AAR_idx);
    weights = ((1/wid_i)/sum(1/wid_i))';
    AMA = sum(weights.*ice_surf);
    bed_topo = mean(Hyp,2);
    thar_35 = bed_topo(end-1) + 0.35*(bed_topo(2)-bed_topo(end-1));
    ELA_mu = mean(ELA_valid);
    vELA_mod = median(vELA);
    vELA_err = 2*std(vELA);
    
    stats_i = {ELA_aar50 ELA_aar67 AMA MEG thar_35 ...
        ELA_mu ELA_MoE vELA_mod vELA_err};
    ELA_stats(i,:) = stats_i;
    
end

%% Validation plots

figure
hold on
for i=1:length({data_dirs.name})
    aar_67 = scatter(2*(i-1)-0.2, ELA_stats.AAR_67(i), 150, ...
        [0.9290 0.6940 0.1250], 'filled', 'diamond');
    aar_50 = scatter(2*(i-1)-0.1, ELA_stats.AAR_50(i), 200, ...
        [0.9290 0.6940 0.1250], '*');
    ama = scatter(2*(i-1), ELA_stats.AMA(i), 150, ...
        [0.4940 0.1840 0.5560], 'filled');
    meg = scatter(2*(i-1)+0.1, ELA_stats.MEG(i), 150, ...
        [0.3010 0.7450 0.9330], 'filled', 'diamond');
    thar_35 = scatter(2*(i-1)+0.2, ELA_stats.THAR_35(i), 200, ...
        [0.3010 0.7450 0.9330], '*');
    err_meas = errorbar(2*(i-1)-0.25, ELA_stats.ELA_meas(i), ...
        ELA_stats.MoE_meas(i), ...
        'Color', [0 0.4470 0.7410], 'LineWidth', 5);
    pt_meas = scatter(2*(i-1)-0.25, ELA_stats.ELA_meas(i), ...
        150, [0 0.4470 0.7410], 'filled');
    err_mod = errorbar(2*(i-1)+0.25, ELA_stats.ELA_mod(i), ...
        ELA_stats.MoE_mod(i), ...
        'Color', [0.8500 0.3250 0.0980], 'LineWidth', 5);
    pt_mod = scatter(2*(i-1)+0.25, ELA_stats.ELA_mod(i), ...
        150, [0.8500 0.3250 0.0980], 'filled');
end
[~,hobj] = legend([aar_67 aar_50 ama meg thar_35 err_meas err_mod], ...
    {'AAR=0.67', 'AAR=0.50', 'AMA', 'MEG', ...
    'THAR=0.35', 'Observed ELA', 'Modeled ELA'}, 'FontSize', 25);
M = findobj(hobj,'type','patch');
set(M,'MarkerSize', sqrt(150))
ax = gca;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ax.GridAlpha = 0.8;
ax.XTick = 0:2:2*length(data_dirs)-1;
ax.XTickLabels = {data_dirs.name};
ax.YLabel.String = "ELA (m a.s.l.)";
ax.FontSize = 20;
hold off

aar50_bias = mean(ELA_stats.AAR_50 - ELA_stats.ELA_meas);
aar67_bias = mean(ELA_stats.AAR_67 - ELA_stats.ELA_meas);
ama_bias = mean(ELA_stats.AMA - ELA_stats.ELA_meas);
meg_bias = mean(ELA_stats.MEG - ELA_stats.ELA_meas);
THAR_bias = mean(ELA_stats.THAR_35 - ELA_stats.ELA_meas);
mod_bias = mean(ELA_stats.ELA_mod - ELA_stats.ELA_meas);

% figure
% hold on
% plot([0 7], [0 0], 'k--')
% scatter(1, aar50_bias, 200, [0.9290 0.6940 0.1250], '*')
% scatter(2, aar67_bias, 150, [0.9290 0.6940 0.1250], 'filled', 'diamond')
% scatter(3, ama_bias, 150, [0.4940 0.1840 0.5560], 'filled')
% scatter(4, meg_bias, 150, [0.3010 0.7450 0.9330], 'filled', 'diamond')
% scatter(5, THAR_bias, 200, [0.3010 0.7450 0.9330], '*')
% scatter(6, mod_bias, 150, [0.8500 0.3250 0.0980], 'filled')
% ax = gca;
% ax.XTick = 0:7;
% ax.XTickLabels = {'', 'AAR=0.50', 'AAR=0.67', 'AMA', ...
%     'MEG', 'THAR=0.35', 'Modeled', ''};
% ax.YLabel.String = "ELA mean bias (m)";
% ax.FontSize = 20;
% hold off

bias_tbl = table(...
    [aar50_bias aar67_bias ama_bias meg_bias THAR_bias mod_bias]', ...
    'VariableNames', {'ELA mean bias (m)'}, 'RowNames', ...
    {'AAR=0.50', 'AAR=0.67', 'AMA','MEG', 'THAR=0.35', 'Modeled'});

% gries_outERR = (ELA_stats(2,2)-ELA_stats(2,3)) - ...
%     (ELA_stats(2,4) + ELA_stats(2,5));
