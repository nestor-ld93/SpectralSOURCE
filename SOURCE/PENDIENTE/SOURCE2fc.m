clear all, close all, clc,
% SOURCE2fc (v1.0)
% Calcula los parametros de la fuente sismica mediante analisis espectral

%==========================================================================
%
%"+======================================================================+"
%"|                         SpectralSOURCE v1.0.0                        |"
%"+======================================================================+"
%"| -Parte 2: SOURCE                                                     |"
%"| -Subparte 2.1: SOURCE2fc.m                                           |"
%"| -Ultima actualizacion: 20/03/2020                                    |"
%"+----------------------------------------------------------------------+"
%"| -Copyright (C) 2020  Nestor Luna Diaz                                |"
%"+----------------------------------------------------------------------+"
%
%==========================================================================

%%%%%%%%%%%%%%%%%%Generar imagenes finales PNG o EPS%%%%%%%%%%%%%%%%%
gen_graf = 0; %1 para generar archivos, 0 para no generar.
tipo_graf = 'eps'; %eps o png.

%%%%%%%%%%%%%%%%%%%%%Archivos de entrada y salida%%%%%%%%%%%%%%%%%%%%
subLeer('[LISTA_xy].txt','[HIPO_IRIS].txt')

cabecero = [' N ','  Red  Estacion  Comp','     M0 (N.m)',...
            '  fc1 (Hz)','  fc2 (Hz)','       Mw','      E_Mw',...
            '   L_fc1 (km)','   W_fc2 (km)','  Area_fc (km^2)',...
            '    L_Pa (km)','    W_Pa (km)','  Area_Pa (km^2)',...
            '  D_sigma (MPa)','  Du_fc (m)','  Du_Pa (m)'];

fileID3 = fopen('[SALIDA_ESTACIONES].txt','w');
fprintf(fileID3,'%s\n',cabecero);

%%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
H_0 = Hipo(1,5);            %Profundidad del evento
Mw_ref = Hipo(1,6);         %Magnitud Momento referencial.

%%%%%%%%%%%%%%%%%%Inicio del bucle para cada archivo%%%%%%%%%%%%%%%%%
for i=1:n_archivos
B = load(Lista_xy{i});

%%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
f = B(:,1); Pyy = B(:,2);
Delta_gr = Hipo(i,1);       %Distancia epicentral en grados.
%Delta_km = Hipo(i,2);       %Distancia epicentral en km.       

%%%%%%%%%%%%%%%%%Constantes y Datos del modelo PREM%%%%%%%%%%%%%%%%%%
subPREM(H_0)
mu_0 = rho_0*vs_0^2; % Modulo de rigidez (Pa = kg.m^-1.s^-2).

%%%%%%%%%%%%Correccion por atenuacion y expasion geometrica,%%%%%%%%%%%%%%%
q = exp(-pi*f); %Atenuacion anelastica. Se aproxima T/Q=1 para ondas P.
g = 0.0048/(27.0+Delta_gr)*1.0E-03; %Expansion geometrica (se aplica al final)

Pyy1 = Pyy.*q; %Correccion por atenuacion.

%%%%%%%%%%%%%%%%%%%%%%%%%%Graficando%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subGraficar2fc(Lista_xy{i},red{i},est{i},comp{i},f,Pyy,Pyy1,gen_graf,tipo_graf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Modelos utilizados%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Se corrige M0 por:
% 1. Superficie libre (Incidencia perpend. para dist. telesismicas) = 2.0.
% 2. Patron de radiacion promedio Rp = 0.42. Boore and Boatwright (1984).
% 3. Expansion geometrica (Tablas de Bullen - Havskov, J. (2010)).

M0 = U0(1)*4*pi*rho_0*vp_0^3/(2.0*0.42*g); %Momento sismico escalar (N.m).
Mw = 2/3*log10(M0)-6.07; %Magnitud Momento.
E_Mw = abs((Mw-Mw_ref)/Mw_ref)*100; %Error porcentual de Mw.

% Modelo de Haskell (Falla rectangular).
%Area_fc = (1.7*vp_0*1.0E-03/(2*pi*fc))^2; %Falla rectangular (km^2)
L_fc1 = 1.2*vp_0*1.0E-03/(2*pi*fc(1)); %Longitud (km)
W_fc2 = 2.4*vp_0*1.0E-03/(2*pi*fc(2)); %Ancho (km)
Area_fc = L_fc1*W_fc2; %Falla rectangular (km^2)
Du_fc = M0/(mu_0*Area_fc)*1.0E-06; %Dislocacion promedio (m)

% Relaciones de Papazachos (2014), Fallas Dip-Slip en regiones de
% subduccion.
L_Pa = 10^(0.55*Mw-2.19); %Longitud (km)
W_Pa = 10^(0.31*Mw-0.63); %Ancho (km)
Area_Pa = L_Pa*W_Pa; %Falla rectangular (km^2)

% Relaciones de Papazachos (2014), Fallas Dip-Slip en regiones
% continentales (Normal Dip-Slip).
%L_Pa = 10^(0.50*Mw-1.86); %Longitud (km)
%W_Pa = 10^(0.28*Mw-0.70); %Ancho (km)
%Area_Pa = L_Pa*W_Pa; %Falla rectangular (km^2)

%Dislocacion promedio usando Area_Pa.
Du_Pa = M0/(mu_0*Area_Pa)*1.0E-06; %Dislocacion promedio (m).

% Caida de esfuerzos promedio para falla rectangular Dip-Slip (lambda = mu)
D_sigma = 8/(3*pi*W_Pa^2*L_Pa)*M0*1.0E-15; % Caida de esfuerzos promedio (MPa).

%%%%%%%%%%%%%%%%%%%%%%%%%%Escribir resultados%%%%%%%%%%%%%%%%%%%%%%%%%%
%fprintf('=============================================================\n');
%fprintf('%s\n',cabecero);
%fprintf('%2d %29s %9.2E %8.3f %8.3f %5.1f %5.1f %10.2f %10.2f %15.2f %10.2f %10.2f %15.2f %14.2f %10.2f %10.2f\n',...
%         i,Lista_xy{i},M0,fc(1),fc(2),Mw,E_Mw,L_fc1,W_fc2,Area_fc,L_Pa,W_Pa,Area_Pa,D_sigma,Du_fc,Du_Pa);

%fprintf('=============================================================\n');
fprintf(fileID3,'%2d %5s %9s %5s %12.4E %9.4f %9.4f %8.4f %9.4f %12.4f %12.4f %15.4f %12.4f %12.4f %15.4f %14.4f %10.4f %10.4f\n',...
         i,red{i},est{i},comp{i},M0,fc(1),fc(2),Mw,E_Mw,L_fc1,W_fc2,Area_fc,L_Pa,W_Pa,Area_Pa,D_sigma,Du_fc,Du_Pa);

end
fclose(fileID3);
