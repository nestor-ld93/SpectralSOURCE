function subLeer(LISTA,HIPO)
% Lee los archivos principales de entrada (Lista y catalogo)
%
% El archivo HIPO (Catalogo) tiene la siguiente secuencia:
%%[Archivo SAC] [Fecha] [Dist. epi. (grados)] [Dist. epi. (km)]...
%%[Lat. evento] [Lon. evento] [Prof. evento] [Mag. evento]
%%[Red] [estacion] [componente]
%
%%%%% Creado por: Nestor Luna Diaz - 20 de febrero de 2019 %%%%%%%%%%%%%%%%

fileID1 = fopen(LISTA);
A = textscan(fileID1,'%s');
fclose(fileID1);
Lista_xy = A{1};
n_archivos = length(Lista_xy);

fileID2 = fopen(HIPO);
C = textscan(fileID2,'%s %s %f %f %f %f %f %f %f %s %s %s');
fclose(fileID2);
Hipo = cell2mat(C(:,3:8));
red = C{:,10};
est = C{:,11};
comp = C{:,12};

assignin('base','Lista_xy',Lista_xy);
assignin('base','n_archivos',n_archivos);
assignin('base','Hipo',Hipo);
assignin('base','red',red);
assignin('base','est',est);
assignin('base','comp',comp);
end