clear all, close all, clc,
% SOURCE (v1.0)
% Calcula los parametros de la fuente sismica mediante analisis espectral

%==========================================================================
%
%"+======================================================================+"
%"|                         SpectralSOURCE v1.0.0                        |"
%"+======================================================================+"
%"| -Parte 2: SOURCE                                                     |"
%"| -Subparte 2: SOURCE.m                                                |"
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

%%%%%%%%%%%%%%%%%%Generar imagenes finales PNG o EPS%%%%%%%%%%%%%%%%%
gen_graf = 0; %1 para generar archivos, 0 para no generar.
tipo_graf = 'eps'; %eps o png.

%%%%%%%%%%%%%%%%%%%%%Archivos de entrada y salida%%%%%%%%%%%%%%%%%%%%
subLeer('[LISTA_xy].txt','[HIPO_IRIS].txt')

cabecero = [' N ','  Red  Estacion  Comp','     M0 (N.m)',...
            '   fc (Hz)','       Mw','      E_Mw'];

fileID3 = fopen('[SALIDA_ESTACIONES].txt','w');
fprintf(fileID3,'%s\n',cabecero);

%%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
H_0 = Hipo(1,5);            %Profundidad del evento.
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
subGraficar1fc(Lista_xy{i},red{i},est{i},comp{i},f,Pyy,Pyy1,gen_graf,tipo_graf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Modelos utilizados%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Se corrige M0 por:
% 1. Superficie libre (Incidencia perpend. para dist. telesismicas) = 2.0.
% 2. Patron de radiacion promedio Rp = 0.42. Boore and Boatwright (1984).
% 3. Expansion geometrica (Tablas de Bullen - Havskov, J. (2010)).

M0 = U0*4*pi*rho_0*vp_0^3/(2.0*0.42*g); %Momento sismico escalar (N.m).
Mw = 2/3*log10(M0)-6.07; %Magnitud Momento.
E_Mw = abs((Mw-Mw_ref)/Mw_ref)*100; %Error porcentual de Mw.

%%%%%%%%%%%%%%%%%%%%%%%%%%Escribir resultados%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fileID3,'%2d %5s %9s %5s %12.4E %9.4f %8.4f %9.4f\n',...
         i,red{i},est{i},comp{i},M0,fc,Mw,E_Mw);

end
fclose(fileID3);
