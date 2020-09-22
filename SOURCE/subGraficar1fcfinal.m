function subGraficar1fcfinal(red,est,comp,f,Pyy1,M0,fc,Delta_gr,Azim_gr,n,nx,ny,...
nombre_ejes,tipo_ejes,font_size,grilla,resultados_num,show_fc,linea_width)
% Graficador FFT final (1 fc) de ResultadoGRAF
% Plotea 06 graficos en una ventana.
%%%%% Creado por: Nestor Luna Diaz - 20 de febrero de 2019 %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%Graficando%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure('Name',num2mstr(6))
subplot(nx,ny,n), loglog(f,Pyy1,'r','linewidth',linea_width(1))
    if resultados_num == 1
        if show_fc == 0
            txt = {strcat('Dist=',' ',sprintf('%.2f',Delta_gr),'°'),...
                   strcat('Azim=',' ',sprintf('%.2f',Azim_gr),'°'),...
                   strcat('M0=',' ',sprintf('%.2E',M0),' N.m')};
        end
        if show_fc == 1
           txt = {strcat('Dist=',' ',sprintf('%.2f',Delta_gr),'°'),...
                  strcat('Azim=',' ',sprintf('%.2f',Azim_gr),'°'),...
                  strcat('fc=',' ',sprintf('%.2f',fc),' Hz'),...
                  strcat('M0=',' ',sprintf('%.2E',M0),' N.m')};
        end
        text(min(f)+1.5E-03,min(Pyy1)+1.0E-15,txt,'fontsize',font_size(2))
    end
    title({strcat(red,'.',est,'.',comp,' - P')},'fontsize',font_size(1))
    xlim([1.0E-03 5])
    set(gca,'xtick',[1.0E-03,1.0E-02,1.0E-01,1.0])
    if tipo_ejes == 1
        ylabel (nombre_ejes(2)); xlabel(nombre_ejes(1))
    end
    if grilla == 1
        grid on
    end

%%%%%%%%%%%%%%%%%%Graficando rectas del modelo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Df = f(2)-f(1); %Intervalo de frecuencia.
nfc = floor(fc/Df)+1; %Ubicacion de la fc.
U0 = mean(Pyy1(1:nfc)); %Valor promedio de la parte plana del espectro.
if resultados_num == 1
    if show_fc == 1
       text(fc,U0,'<--fc')
    end
end

nlim = 512; %Ubicacion limite de f a considerar para graficar.
maxlimPyy1 = max(Pyy1(nlim-5:nlim)); %Amplitud max de 5 muestras antes.
    hold on
        loglog([f(2), fc],[U0, U0],'--','color','b','linewidth',linea_width(2)) %Graficando la recta promedio.
        loglog([fc, f(nlim)],[U0, maxlimPyy1],'--','color','b','linewidth',linea_width(2)) %Graficando caida f^-2.
    hold off
    
    if tipo_ejes == 2
        han=axes('visible','off'); 
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel(han,{nombre_ejes{2};''},'fontsize',font_size(3));
        xlabel(han,{'';nombre_ejes{1}},'fontsize',font_size(3));
    end
end
