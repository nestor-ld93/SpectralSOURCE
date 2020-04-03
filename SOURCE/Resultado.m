clear all, close all, clc
% Resultado (v1.0)
% Realiza el Post-Procesamiento (Resultado final) de SpectralSOURCE.

%==========================================================================
%
%"+======================================================================+"
%"|                         SpectralSOURCE v1.0.0                        |"
%"+======================================================================+"
%"| -Parte 2: SOURCE                                                     |"
%"| -Subparte 3: Resultado.m                                             |"
%"| -Ultima actualizacion: 20/03/2020                                    |"
%"+----------------------------------------------------------------------+"
%"| -Copyright (C) 2020  Nestor Luna Diaz                                |"
%"+----------------------------------------------------------------------+"
%
%==========================================================================

%This program is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
%==========================================================================

%%%%%%%%Seleccionar tipo de falla (Solo para Papazachos)%%%%%%%%%%%%%
%1 : Dip-Slip (Subduccion)
%2 : Normal Dip-Slip (Continental)
%3 : Strike-Slip
tipo_falla = 1;

%%%%%%%%%%%%%%%%%%%%%Archivos de entrada y salida%%%%%%%%%%%%%%%%%%%%
fileID1 = fopen('[SALIDA_ESTACIONES].txt');
A = textscan(fileID1,'%f %s %s %s %f %f %f %f','headerlines',1);
fclose(fileID1);
datos = cell2mat(A(:,5:8));

fileID2 = fopen('[HIPO_IRIS].txt');
C = textscan(fileID2,'%s %s %f %f %f %f %f %f %f %s %s %s');
fclose(fileID2);
Hipo = cell2mat(C(:,3:8));

fileID3 = fopen('[SALIDA_FINAL].txt','w');

cabecero_b1 = ['======================================================',...
               '============='];
cabecero_01 = ['   M0 (N.m)','  Std M0 (N.m)','   fc (Hz)',...
               '  Std fc (Hz)','       Mw','      E_Mw'];
cabecero_02 = ['       Modelo','       r (km)','       L (km)',...
               '       W (km)','      Area (km^2)','  Dsig. (MPa)','     Du (m)'];
cabecero_b2 = ['======================================================',...
               '========================================'];

%%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
H_0 = Hipo(1,5);            %Profundidad del evento
Mw_ref = Hipo(1,6);         %Magnitud Momento referencial.

%%%%%%%%%%%%%%%%%Constantes y Datos del modelo PREM%%%%%%%%%%%%%%%%%%
subPREM(H_0)
mu_0 = rho_0*vs_0^2; % Modulo de rigidez (Pa = kg.m^-1.s^-2).

%%%%%%%%%%%%%%%%%%%%%%%%Procesando los datos%%%%%%%%%%%%%%%%%%%%%%%%%
M0 = mean(datos(:,1));
fc = mean(datos(:,2));
Mw = 2/3*log10(M0)-6.07; %Magnitud Momento.
E_Mw = abs((Mw-Mw_ref)/Mw_ref)*100; %Error porcentual de Mw.

desv_M0 = std(datos(:,1)); %Desviacion estandar de M0.
desv_fc = std(datos(:,2)); %Desviacion estandar de fc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Modelos utilizados%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modelo de Brune (1970, 1971) [Falla circular].
kp_B = 3.36;
r_B = kp_B*vs_0*1.0E-03/(2*pi*fc);
Area_B = pi*r_B^2;
Du_B = M0/(mu_0*Area_B)*1.0E-06; %Dislocacion promedio (m).
D_sigma_B = 7*M0/(16*r_B^3)*1.0E-15; % Caida de esfuerzos promedio (MPa).

% Modelo de Madariaga I (1976) [Falla circular].
kp_MI = 1.88;
r_MI = kp_MI*vs_0*1.0E-03/(2*pi*fc);
Area_MI = pi*r_MI^2;
Du_MI = M0/(mu_0*Area_MI)*1.0E-06; %Dislocacion promedio (m).
D_sigma_MI = 7*M0/(16*r_MI^3)*1.0E-15; % Caida de esfuerzos promedio (MPa).

% Modelo de Madariaga II (1976) [Falla circular].
kp_MII = 2.07;
r_MII = kp_MII*vs_0*1.0E-03/(2*pi*fc);
Area_MII = pi*r_MII^2;
Du_MII = M0/(mu_0*Area_MII)*1.0E-06; %Dislocacion promedio (m).
D_sigma_MII = 7*M0/(16*r_MII^3)*1.0E-15; % Caida de esfuerzos promedio (MPa).

% Modelo de Haskell (Savage 1972) [Falla rectangular].
kp_Hk = 1.7;
Area_Hk = (kp_Hk*vp_0*1.0E-03/(2*pi*fc))^2; %Falla rectangular (km^2).
Du_Hk = M0/(mu_0*Area_Hk)*1.0E-06; %Dislocacion promedio (m).
W_Hk = (Area_Hk/2)^0.5;
L_Hk = 2*W_Hk; %Se asume una razon de L/W=2.
D_sigma_Hk = 8/(3*pi*W_Hk^2*L_Hk)*M0*1.0E-15; % Caida de esfuerzos promedio (MPa).
                                   % para falla rectangular Dip-Slip (lambda = mu)

% Relaciones de Papazachos (2014) [Falla Dip-Slip en regiones de subduccion].
if tipo_falla == 1
    L_Pa = 10^(0.55*Mw-2.19); %Longitud (km)
    W_Pa = 10^(0.31*Mw-0.63); %Ancho (km)
    Area_Pa = L_Pa*W_Pa; %Falla rectangular (km^2)
end

% Relaciones de Papazachos (2014), [Fallas Dip-Slip en regiones
% continentales (Normal Dip-Slip)].
if tipo_falla == 2
    L_Pa = 10^(0.50*Mw-1.86); %Longitud (km)
    W_Pa = 10^(0.28*Mw-0.70); %Ancho (km)
    Area_Pa = L_Pa*W_Pa; %Falla rectangular (km^2)
end

% Relaciones de Papazachos (2014), [Fallas Strike-Slip].
if tipo_falla == 3
    L_Pa = 10^(0.59*Mw-2.30); %Longitud (km)
    W_Pa = 10^(0.23*Mw-0.49); %Ancho (km)
    Area_Pa = L_Pa*W_Pa; %Falla rectangular (km^2)
end

Du_Pa = M0/(mu_0*Area_Pa)*1.0E-06; %Dislocacion promedio (m).
D_sigma_Pa = 8/(3*pi*W_Pa^2*L_Pa)*M0*1.0E-15; % Caida de esfuerzos promedio (MPa).
                                   % para falla rectangular Dip-Slip (lambda = mu)

%%%%%%%%%%%%%%%%%%%%%%%%%%Escribir resultados%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s\n%s\n%s\n',cabecero_b1,cabecero_01,cabecero_b1);
fprintf('%11.4E %13.4E %9.4f %12.4f %8.4f %9.4f\n',M0,desv_M0,fc,desv_fc,Mw,E_Mw);
fprintf('%s\n\n',cabecero_b1);
fprintf('%s\n%s\n%s\n',cabecero_b2,cabecero_02,cabecero_b2);
fprintf('%13s %12.4f %12s %12s %16.4f %12.4f %10.4f\n',...
        'Brune',r_B,'-','-',Area_B,D_sigma_B,Du_B);
fprintf('%13s %12.4f %12s %12s %16.4f %12.4f %10.4f\n',...
        'Madariaga I',r_MI,'-','-',Area_MI,D_sigma_MI,Du_MI);
fprintf('%13s %12.4f %12s %12s %16.4f %12.4f %10.4f\n',...
        'Madariaga II',r_MII,'-','-',Area_MII,D_sigma_MII,Du_MII);
fprintf('%13s %12s %12.4f %12.4f %16.4f %12.4f %10.4f\n',...
        'Haskell','-',L_Hk,W_Hk,Area_Hk,D_sigma_Hk,Du_Hk);
fprintf('%13s %12s %12.4f %12.4f %16.4f %12.4f %10.4f\n',...
        'Papazachos','-',L_Pa,W_Pa,Area_Pa,D_sigma_Pa,Du_Pa);
fprintf('%s\n',cabecero_b2);

fprintf(fileID3,'%s\n%s\n%s\n',cabecero_b1,cabecero_01,cabecero_b1);
fprintf(fileID3,'%11.4E %13.4E %9.4f %12.4f %8.4f %9.4f\n',M0,desv_M0,fc,desv_fc,Mw,E_Mw);
fprintf(fileID3,'%s\n\n',cabecero_b1);
fprintf(fileID3,'%s\n%s\n%s\n',cabecero_b2,cabecero_02,cabecero_b2);
fprintf(fileID3,'%13s %12.4f %12s %12s %16.4f %12.4f %10.4f\n',...
        'Brune',r_B,'-','-',Area_B,D_sigma_B,Du_B);
fprintf(fileID3,'%13s %12.4f %12s %12s %16.4f %12.4f %10.4f\n',...
        'Madariaga I',r_MI,'-','-',Area_MI,D_sigma_MI,Du_MI);
fprintf(fileID3,'%13s %12.4f %12s %12s %16.4f %12.4f %10.4f\n',...
        'Madariaga II',r_MII,'-','-',Area_MII,D_sigma_MII,Du_MII);
fprintf(fileID3,'%13s %12s %12.4f %12.4f %16.4f %12.4f %10.4f\n',...
        'Haskell','-',L_Hk,W_Hk,Area_Hk,D_sigma_Hk,Du_Hk);
fprintf(fileID3,'%13s %12s %12.4f %12.4f %16.4f %12.4f %10.4f\n',...
        'Papazachos','-',L_Pa,W_Pa,Area_Pa,D_sigma_Pa,Du_Pa);
fprintf(fileID3,'%s\n',cabecero_b2);

fclose(fileID3);
