function taper(y)
% Atenua los extremos de una funcion.
% Genera una variable ytc ('y' 'taper' 'corregida').
% Necesario para la transformada de Fourier.

n=length(y);
w = tukeywin(n,0.25);
if size(y)~= size(w)
    ytc = y.*transpose(w);
else
    ytc = y.*w;
end
assignin('base','ytc',ytc);