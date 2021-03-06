function subGraficar1fc(Lista_xy,red,est,comp,f,Pyy,Pyy1,gen_graf,tipo_graf)
% Graficador FFT (1 fc) de SOURCE
% Plotea 02 graficos, uno sin corregir y otro corregido por atenuacion.
%%%%% Creado por: Nestor Luna Diaz - 20 de febrero de 2019 %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%Graficando%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name',Lista_xy)
subplot(2,1,1), loglog(f,Pyy), grid, zoom xon
    title({strcat(red,'.',est,'.',comp),'Espectro de potencias (Ondas P) deconvolucionado'})
    ylabel ('Amplitud (m/Hz)'); xlabel('Frecuencia (Hz)')
    xlim([1.0E-03 5])

subplot(2,1,2), loglog(f,Pyy1,'r'), grid on
    title('Espectro de potencias (Ondas P) corregido por atenuación')
    ylabel ('Amplitud (m/Hz)'); xlabel('Frecuencia (Hz)')
    xlim([1.0E-03 5])

%%%%%%%%%%%%%%%%%%%%%Seleccion manual de U0 y fc%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Presione una tecla para continuar...\n'); pause
[fc, U0] = ginput(1); %Frecuencia esquina y parte plana del espectro.

%%%%%%%%%%%%%%%%%%Graficando rectas del modelo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Df = f(2)-f(1); %Intervalo de frecuencia.
nfc = floor(fc/Df)+1; %Ubicacion de la fc.
U0 = mean(Pyy1(1:nfc)); %Valor promedio de la parte plana del espectro.

nlim = 512; %Ubicacion limite de f a considerar para graficar.
maxlimPyy1 = max(Pyy1(nlim-5:nlim)); %Amplitud max de 5 muestras antes.

    hold on
        loglog([f(2), fc],[U0, U0],'--','color','b','linewidth',1.2) %Graficando la recta promedio.
        loglog([fc, f(nlim)],[U0, maxlimPyy1],'--','color','b','linewidth',1.2) %Graficando caida f^-2.
    hold off

assignin('base','fc',fc);
assignin('base','U0',U0);

if gen_graf == 1
    if tipo_graf == 'png'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        fig.PaperUnits = 'inches'; 
        fig.PaperPosition = [0 0 9 8]; 
        print([Lista_xy,'.png'],'-dpng','-r0')
    elseif tipo_graf == 'eps'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        fig.PaperUnits = 'inches'; 
        fig.PaperPosition = [0 0 9 8];
        print([Lista_xy,'.eps'],'-depsc2','-r0')
    end
end

end
