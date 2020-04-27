function [Hx] = ice_thick(Hyp, tau_STD, vX)

L = vX(end);

deltaH = (max(Hyp)-min(Hyp))/1000;
if deltaH > 1.6
    tau_0 = 1.5*10^5;
elseif deltaH < 0.5
    tau_0 = 3*deltaH*10^5;
else
    tau_0 = (0.005 + 1.598*deltaH - 0.435*deltaH^2)*10^5; 
end

vTau_gauss = normrnd(tau_0, tau_STD, 1, 100);
Tau_i = vTau_gauss(randi(numel(vTau_gauss)));

% Mean ice thickness calculation (equation modified from Oerlemanns, 2011)
rho = 917;      %Ice density (kg/m^3)
g = 9.81;        %Acceleration due to gravity (m/s^2)
theta = atan(gradient(Hyp));  %Expression for the bed angle along profile
Hm_i = (2/3)*sqrt(Tau_i*L/(rho*g.*(1+abs(sin(mean(theta))))));

fun = @(Hmax_f)(mean(Hmax_f.*(1-(4/L.^2).*(vX-(1/2).*L).^2))-Hm_i);
Hmax = fzero(fun,2*Hm_i);
Hx = Hmax-(4*Hmax/L^2)*(vX-L/2).^2;
end