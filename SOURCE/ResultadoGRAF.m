% clear all, close all, clc
% ResultadoGRAF (v1.2)
% Grafica las imgs finales en PNG o EPS

%==========================================================================
%
%"+======================================================================+"
%"|                         SpectralSOURCE v1.3.0                        |"
%"+======================================================================+"
%"| -Parte 2: SOURCE                                                     |"
%"| -Subparte 4: ResultadoGRAF.m                                         |"
%"| -Ultima actualizacion: 21/09/2020                                    |"
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
n_plot = nx*ny; %Cantidad de graficos en una figura.
font_size = [titulo_size contenido_size ejes_size];   % Titulo, contenido, ejes.
linea_width = [grosor_fft grosor_curva];    % Pyy, ajuste.
nombre_ejes = {label_x, label_y};

%gen_graf = 1; %1 para generar archivos, 0 para no generar.
%tipo_graf = 'eps'; %eps o png.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%paper_size_W = 29.70; % cm.
%paper_size_L = 42.00; % cm.
%nx = 12; ny = 6;
%n_plot = nx*ny; %Cantidad de graficos en una figura.

%nombre_ejes = {'Frequency (Hz)', 'Amplitude (m/Hz)'};
%tipo_ejes = 2;              % 1=subetiquetas, 2=general.
%font_size = [9.0 7.9 12];   % Titulo, contenido, ejes.
%grilla = 0;                 % 1=activar, 0=desactivar.
%resultados_num = 1;         % 1=activar, 0=desactivar.
%show_fc = 0;                % 1=activar, 0=desactivar.
%linea_width = [1.5 1.5];    % Pyy, ajuste.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%paper_size_W = 25.65; % cm.
%paper_size_L = 25.70; % cm.
%nx = 6; ny = 6; n_plot = nx*ny; %Cantidad de graficos en una figura.

%nombre_ejes = {'Frequency (Hz)', 'Amplitude (m/Hz)'};
%tipo_ejes = 2;              % 1=subetiquetas, 2=general.
%font_size = [8.5 7.9 12];   % Titulo, contenido, ejes.
%grilla = 0;                 % 1=activar, 0=desactivar.
%resultados_num = 1;         % 1=activar, 0=desactivar.
%show_fc = 0;                % 1=activar, 0=desactivar.
%linea_width = [1.5 1.5];    % Pyy, ajuste.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%paper_size_W = 22.86; % cm.
%paper_size_L = 20.32; % cm.
%nx = 2; ny = 3; n_plot = nx*ny; %Cantidad de graficos en una figura.

%nombre_ejes = {'Frecuencia (Hz)', 'Amplitud (m/Hz)'};
%tipo_ejes = 1;              % 1=subetiquetas, 2=general.
%font_size = [11 10 15];     % Titulo, contenido, ejes.
%grilla = 1;                 % 1=activar, 0=desactivar.
%resultados_num = 1;         % 1=activar, 0=desactivar.
%show_fc = 0;                % 1=activar, 0=desactivar.
%linea_width = [1.5 1.5];    % Pyy, ajuste.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % n=12x6; WxL=29.70x42.00; } Experimental
% % n= 2x3; WxL=22.86x20.32; } Equivalente en cm.

%%%%%%%%%%%%%%%%%%%%%Archivos de entrada y salida%%%%%%%%%%%%%%%%%%%%
fileID1 = fopen('[SALIDA_ESTACIONES].txt');
A = textscan(fileID1,'%f %s %s %s %f %f %f %f','headerlines',1);
fclose(fileID1);

datos = cell2mat(A(:,5:8));
M0 = datos(:,1);
fc = datos(:,2);

%%%%%%%%%%%
subLeer('[LISTA_xy].txt','[HIPO_IRIS].txt')
Delta_gr = Hipo(:,1);       %Distancia epicentral en grados.
Azim_gr = Hipo(:,2);        %Azimuth de estacion en grados.

i_fig  = 1; %Contador de numero de figuras.
i_plot = 1; %Contador de graficos en una figura (nx*ny como max).
figure
for i=1:n_archivos
    B = load(Lista_xy{i});
    %%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
    f = B(:,1); Pyy = B(:,2);
    q = exp(-pi*f); %Atenuacion anelastica. Se aproxima T/Q=1 para ondas P.
    Pyy1 = Pyy.*q; %Correccion por atenuacion.
    if i_plot <= n_plot
        subGraficar1fcfinal(red{i},est{i},comp{i},f,Pyy1,M0(i),fc(i),...
                            Delta_gr(i),Azim_gr(i),i_plot,nx,ny,...
                            nombre_ejes,tipo_ejes,font_size,grilla,...
                            resultados_num,show_fc,linea_width)
    else
        if gen_graf == 1
            if tipo_graf == 'png'
                %%saveas(gcf,[Lista_xy,'.png'],'png')
                fig = gcf; 
                set(fig, 'PaperUnits', 'centimeters');
                set(fig, 'PaperPosition', [0 0 paper_size_W paper_size_L]); 
                print(['Figura-',num2str(i_fig),'.png'],'-dpng','-r0')
                elseif tipo_graf == 'eps'
                    %%saveas(gcf,[Lista_xy,'.png'],'png')
                    fig = gcf; 
                    set(fig,'renderer','painters');
                    set(fig, 'PaperUnits', 'centimeters');
                    set(fig, 'PaperPosition', [0 0 paper_size_W paper_size_L]); 
                    print(['Figura-',num2str(i_fig),'.eps'],'-depsc2','-r0')
            end
        end
        
        i_plot = 1;
        figure
        subGraficar1fcfinal(red{i},est{i},comp{i},f,Pyy1,M0(i),fc(i),...
                            Delta_gr(i),Azim_gr(i),i_plot,nx,ny,...
                            nombre_ejes,tipo_ejes,font_size,grilla,...
                            resultados_num,show_fc,linea_width)
        i_fig = i_fig+1;
    end
    i_plot = i_plot+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gen_graf == 1
    if tipo_graf == 'png'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        set(fig, 'PaperUnits', 'centimeters');
        set(fig, 'PaperPosition', [0 0 paper_size_W paper_size_L]); 
        print(['Figura-',num2str(i_fig),'.png'],'-dpng','-r0')
    elseif tipo_graf == 'eps'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        set(fig,'renderer','painters');
        set(fig, 'PaperUnits', 'centimeters');
        set(fig, 'PaperPosition', [0 0 paper_size_W paper_size_L]);
        print(['Figura-',num2str(i_fig),'.eps'],'-depsc2','-r0')
    end
end
