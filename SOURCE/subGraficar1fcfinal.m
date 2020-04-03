function subGraficar1fcfinal(red,est,comp,f,Pyy1,M0,fc,Delta_gr,n,nx,ny)
% Graficador FFT final (1 fc) de ResultadoGRAF
% Plotea 06 graficos en una ventana.
%%%%% Creado por: Nestor Luna Diaz - 20 de febrero de 2019 %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%Graficando%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure('Name',num2mstr(6))
txt = {strcat('M0=',' ',sprintf('%.2E',M0),' N.m'),...
       strcat('fc=',' ',sprintf('%.2f',fc),' Hz'),...
       strcat('Dist=',' ',sprintf('%.2f',Delta_gr),'°')};
subplot(nx,ny,n), loglog(f,Pyy1,'r'), grid on
    text(min(f)+1.5E-03,min(Pyy1)+1.0E-15,txt)
    title({strcat(red,'.',est,'.',comp,' - P')})
    ylabel ('Amplitud (m/Hz)'); xlabel('Frecuencia (Hz)')
    xlim([1.0E-03 5])

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

end
