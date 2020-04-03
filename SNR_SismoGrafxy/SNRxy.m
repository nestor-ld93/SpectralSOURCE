clear all, close all, clc,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%--> Calcula la relacion Señal-Ruido <--%%%%%%%%%%%%%%%%%%
% Contenido de "[SALIDA].txt": "Archivo" "Arribo de P" "Fs" "SNR" %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creado por: Nestor Luna Diaz - 07 de febrero de 2019 %%%%%%%%%%%%%%%
%%%%% Ultima modificacion: Nestor Luna Diaz - 08 de febrero de 2019 %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Archivos de entrada%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileID1 = fopen('[LISTA_xy].txt');
A = textscan(fileID1,'%s');
fclose(fileID1);
Lista_xy = A{1};
n_archivos = length(Lista_xy);

fileID4 = fopen('[SALIDA_SNR].txt','w');

cabecero = '                 Archivo   tp (s)  Fs (Hz)      SNR';
fprintf(fileID4,'%s\n',cabecero);

for i=1:n_archivos
B = load(Lista_xy{i});

%%%%%%%%%%%%%%%%%%%Extraccion de datos de interes%%%%%%%%%%%%%%%%%%%%
t = B(:,1); y = B(:,2); Ts = t(2)-t(1); Fs = 1/Ts;
y=y-mean(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%Graficando%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name',Lista_xy{i})
plot(t,y), grid on, zoom on
title([Lista_xy{i},'     Fs = ',num2str(Fs)])
ylabel ('Velocidad (Cuentas)'); xlabel('Tiempo (s)')

%%%%%%%%%%%%%%%%%%%%%Seleccion manual de tp%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Presione una tecla para continuar...\n'); pause
[tp, A0] = ginput(1); %Arribo de P.

% Calcular SNR
%Ip = floor((tp-ss)/Ts);
Ip = floor(tp/Ts);
Np = floor(10/Ts);
despues = max(y(Ip:Ip+Np));
antes = mean(abs(y(Ip-Np:Ip)));
SNR = round(despues/antes);
% Fin SNR

title([Lista_xy{i},'     Fs = ',num2str(Fs), '     SNR = ',num2str(SNR)])

fprintf('==================================================\n');
fprintf('Señal utilizada: %24s\n',Lista_xy{i});
fprintf('tp = %f, Ip = %8f, Fs = %8.1f, SNR = %8.4f\n',tp,Ip,Fs,SNR);
fprintf('==================================================\n');

fprintf(fileID4,'%24s %8.2f %8.1f %8.1f\n',Lista_xy{i},tp,Fs,SNR);
% Contenido de "[SALIDA].txt": "Archivo" "Arribo de P" "Fs" "SNR" %%%%%%%
end
fclose(fileID4);
