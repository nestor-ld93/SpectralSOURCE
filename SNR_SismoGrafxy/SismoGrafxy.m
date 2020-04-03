clear all, close all, clc,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%--> Grafica la ventana de tiempo <--%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creado por: Nestor Luna Diaz - 07 de febrero de 2019 %%%%%%%%%%%%%%%
%%%%% Ultima modificacion: Nestor Luna Diaz - 08 de febrero de 2019 %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%Generar imagenes finales PNG o EPS%%%%%%%%%%%%%%%%%
gen_graf = 1; %1 para generar archivos, 0 para no generar.
tipo_graf = 'eps'; %eps o png.

%%%%%%%%%%%%%%%%%%%%%%Archivos de entrada%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileID1 = fopen('[LISTA_xy].txt');
A = textscan(fileID1,'%s');
fclose(fileID1);
Lista_xy = A{1};
n_archivos = length(Lista_xy);

fileID2 = fopen('[SALIDA_SNR].txt');
C = textscan(fileID2,'%s %f %f %f','headerlines',1);
fclose(fileID2);
tp = cell2mat(C(:,2));

fileID3 = fopen('[HIPO_IRIS].txt');
C = textscan(fileID3,'%s %s %f %f %f %f %f %f %f %s %s %s');
fclose(fileID3);
Nombre_SAC = C{1};
Hipo = cell2mat(C(:,3:9));

for i=1:n_archivos
B = load(Lista_xy{i});

%%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
t = B(:,1); y = B(:,2); Ts = t(2)-t(1); Fs = 1/Ts;
Delta_gr = Hipo(i,1);       %Distancia epicentral en grados.
%Delta_km = Hipo_SAC(i,2);       %Distancia epicentral en km.       
H_0 = Hipo(i,5);            %Profundidad del evento
Mw_ref = Hipo(i,6);         %Magnitud Momento referencial.
y=y-mean(y);

%%%%%%%%%%%%%%%% Ventana de tiempo seleccionada %%%%%%%%%%%%%%%%%%%%%
if (Fs > 20.1)
    t1 = tp(i); t2 = t1 + 8191*Ts;
    n1 = floor(t1*Fs); n2 = floor(t2*Fs);
    t1 = [t1, t1]; t2 = [t2, t2];
else
    t1 = tp(i); t2 = t1 + 4095*Ts;
    n1 = floor(t1*Fs); n2 = floor(t2*Fs);
    t1 = [t1, t1]; t2 = [t2, t2];
end

Avt = [-2E010, 2E010]; %Datos para marcar arribo P.
tc = t(n1:n2); yc = y(n1:n2); %Cortando los datos segun la ventana.

%%%%%%%%%%%%%%%%%%% Taper de la señal recortada %%%%%%%%%%%%%%%%%%%%%
taper(yc)

%%%%%%%%%%%%%%%%%%%%%%%%%%Graficando%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name',Nombre_SAC{i})
subplot(3,1,1), plot(t,y,'k'), grid on, zoom on
    axis([t(1) t(end) min(y)-1.5E4 max(y)+1.5E4]);
    hold on, plot(t1,Avt,'r'), plot(t2,Avt,'r'), hold off,
    title([Nombre_SAC{i},' (',sprintf('%.1f',Fs),' Hz)   [D = ',...
           sprintf('%.2f',Delta_gr),'° ,  H = ',num2str(H_0),' km]','  -  Original'])
    ylabel ('Velocidad (Cuentas)')%; xlabel('Tiempo (s)')

subplot(3,1,2), plot(tc,yc,'b'), grid on
    axis([tc(1)-10 tc(end)+10 min(y)-1.5E4 max(y)+1.5E4]);
    hold on, plot(t1,Avt,'r'), plot(t2,Avt,'r'), hold off,
    title([Nombre_SAC{i},'   [D = ',sprintf('%.2f',Delta_gr),'° ,  H = ',...
           num2str(H_0),' km]','  -  Seleccion'])
    ylabel ('Velocidad (Cuentas)')%; xlabel('Tiempo (s)')

subplot(3,1,3), plot(tc,ytc,'r'), grid on
    axis([tc(1)-10 tc(end)+10 min(y)-1.5E4 max(y)+1.5E4]);
    hold on, plot(t1,Avt,'b'), plot(t2,Avt,'b'), hold off,
    title([Nombre_SAC{i},'   [D = ',sprintf('%.2f',Delta_gr),'° ,  H = ',...
           num2str(H_0),' km]','  -  Corregida con Taper'])
    ylabel ('Velocidad (Cuentas)'); xlabel('Tiempo (s)')

if gen_graf == 1
    if tipo_graf == 'png'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        fig.PaperUnits = 'inches'; 
        fig.PaperPosition = [0 0 9 8]; 
        print([Nombre_SAC{i},'.png'],'-dpng','-r0')
    elseif tipo_graf == 'eps'
        %%saveas(gcf,[Lista_xy,'.png'],'png')
        fig = gcf; 
        fig.PaperUnits = 'inches'; 
        fig.PaperPosition = [0 0 9 8];
        print([Nombre_SAC{i},'.eps'],'-depsc2','-r0')
    end
end

end
