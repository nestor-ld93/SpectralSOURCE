function subPREM(H_0)
% Modelo PREM: Dziewonski y Anderson (1981)
% Obtiene densidad y velocidad de la onda P/S a la profundidad deseada.
% Variables de salida en unidades del SI.
%%%%% Creado por: Nestor Luna Diaz - 03 de febrero de 2019 %%%%%%%%%%%%%%%%

PREM = load('[PREM]_1s_IDV.txt');
%(radius depth density Vpv Vph Vsv Vsh eta Q-mu Q-kappa))
%"km" "km" "g/cm^3" "km/s" "km/s" "km/s" "km/s" "" "" ""

prof_PREM = PREM(:,2);
rho_PREM = PREM(:,3);
vp_PREM = PREM(:,4);
vs_PREM = PREM(:,6);
%RT = PREM(1,1);

i = 1;
while prof_PREM(i) < H_0
    i = i + 1;
end

rho_0 = rho_PREM(i-1);
vp_0 = vp_PREM(i-1);
vs_0 = vs_PREM(i-1);

assignin('base','rho_0',rho_0*1.0E03);
assignin('base','vp_0',vp_0*1.0E03);
assignin('base','vs_0',vs_0*1.0E03);
%assignin('base','RT',RT*1.0E03);
end
