clear all, close all, clc
% ResultadoGRAF (v1.0)
% Grafica las imgs finales en PNG o EPS

%==========================================================================
%
%"+======================================================================+"
%"|                         SpectralSOURCE v1.0.0                        |"
%"+======================================================================+"
%"| -Parte 2: SOURCE                                                     |"
%"| -Subparte 4: ResultadoGRAF.m                                         |"
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
gen_graf = 1; %1 para generar archivos, 0 para no generar.
tipo_graf = 'eps'; %eps o png.

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

i_fig = 1; %Contador de numero de figuras.
i_plot = 1; %Contador de graficos en una figura (nx*ny como max).
nx = 2; ny = 3; n_plot = nx*ny; %Cantidad de graficos en una figura.
figure
for i=1:n_archivos
    B = load(Lista_xy{i});
    %%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
    f = B(:,1); Pyy = B(:,2);
    q = exp(-pi*f); %Atenuacion anelastica. Se aproxima T/Q=1 para ondas P.
    Pyy1 = Pyy.*q; %Correccion por atenuacion.
    if i_plot <= n_plot
        subGraficar1fcfinal(red{i},est{i},comp{i},f,Pyy1,M0(i),fc(i),...
                            Delta_gr(i),i_plot,nx,ny)
    else
        if gen_graf == 1
            if tipo_graf == 'png'
                %%saveas(gcf,[Lista_xy,'.png'],'png')
                fig = gcf; 
                fig.PaperUnits = 'inches'; 
                fig.PaperPosition = [0 0 9 8]; 
                print(['Figura-',num2str(i_fig),'.png'],'-dpng','-r0')
                elseif tipo_graf == 'eps'
                    %%saveas(gcf,[Lista_xy,'.png'],'png')
                    fig = gcf; 
                    fig.PaperUnits = 'inches'; 
                    fig.PaperPosition = [0 0 9 8];
                    print(['Figura-',num2str(i_fig),'.eps'],'-depsc2','-r0')
            end
        end
        
        i_plot = 1;
        figure
        subGraficar1fcfinal(red{i},est{i},comp{i},f,Pyy1,M0(i),fc(i),...
                            Delta_gr(i),i_plot,nx,ny)
        i_fig = i_fig+1;
    end
    i_plot = i_plot+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gen_graf == 1
    if tipo_graf == 'png'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        fig.PaperUnits = 'inches'; 
        fig.PaperPosition = [0 0 9 8]; 
        print(['Figura-',num2str(i_fig),'.png'],'-dpng','-r0')
    elseif tipo_graf == 'eps'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        fig.PaperUnits = 'inches'; 
        fig.PaperPosition = [0 0 9 8];
        print(['Figura-',num2str(i_fig),'.eps'],'-depsc2','-r0')
    end
end
