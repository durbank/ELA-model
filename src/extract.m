%% Script to extract glacier bed elevations from ArcMap exported text files and then calculate glacier ice thickness
function [data] = extract(input_filename, output_filename)
% function [data] = extract(input_filename)

% Imports and configures data
% data = readtable(input_filename, 'HeaderLines', 11);
% X_pts = round(data.Var1)+1;
% Z_pts = data.Var2;
data = xlsread(input_filename);
X_pts = round(data(:,2));
Z_pts = data(:,4);
vX = (0:max(X_pts)+50)';

% Estimates bed topography based on two-term exponential
f = fit(X_pts, Z_pts, 'exp2');

coeff = coeffvalues(f);
Hyp = coeff(1)*exp(coeff(2)*vX) + coeff(3)*exp(coeff(4)*vX);
Hyp(Hyp<0) = 0;

% Estimates ice thickness at the measurement locations
L = vX(end);
deltaH = (max(Hyp)-min(Hyp))/1000;
if deltaH > 1.6
    tau_0 = 1.5*10^5;
elseif deltaH < 0.5
    tau_0 = 3*deltaH*10^5;
else
    tau_0 = (0.005+1.598*deltaH-0.435*deltaH^2)*10^5; 
end
    % Mean ice thickness calculation (equation modified from Oerlemanns, 2011)
rho = 917;      %Ice density (kg/m^3)
g = 9.81;        %Acceleration due to gravity (m/s^2)
theta = atan(gradient(Hyp));  %Expression for the bed angle along profile
Hm_i = (2/3)*sqrt(tau_0*L/(rho*g.*(1+abs(sin(mean(theta))))));
fun = @(Hmax_f)(mean(Hmax_f.*(1-(4/L.^2).*(vX-(1/2).*L).^2))-Hm_i);
Hmax = fzero(fun,2*Hm_i);
Hx = Hmax-(4*Hmax/L^2)*(vX-L/2).^2;
ICE_pts = Z_pts + Hx(X_pts);

% Exports calculated data to .csv for use in arcGIS width calculations
DIST = X_pts;
ICE_surf = ICE_pts;
T = table(DIST, ICE_surf);
writetable(T, output_filename)

data = [X_pts Z_pts ICE_pts];
end