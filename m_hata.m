%% CALC - Perdas de percurso de Hata (hata path loss model)
function pl_hata = m_hata(fc, d, htx, hrx, place)
% INPUTS:
% fc        -> carrier frequency                                   [Hz]
% d         -> distance between base station and mobile station    [m]
% htx       -> height of transmitter                               [m]
% hrx       -> height of receiver                                  [m]
% place     -> 'Urban', 'Suburban', 'Rural'
% OUTPUTS:
% pl_hata   -> hata path loss                                      [dB]
place = upper(place);
if nargin<5, place = 'URBANA'; end
fc = fc/(1e6);

if fc >= 150 && fc <= 200, CRx = 8.29*(log10(1.54*hrx))^2 - 1.1;
elseif fc > 200, CRx = 3.2*(log10(11.75*hrx))^2 - 4.97;
else   CRx = 0.8 + (1.1*log10(fc) - 0.7)*hrx - 1.56*log10(fc);
end
pl_hata = 69.55 + 26.16*log10(fc) - 13.82*log10(htx) - CRx + (44.9 - 6.55*log10(htx))*log10(d/1000);

if strcmp(place, "SUBURBANA")'  
    pl_hata = pl_hata - 2*(log10(fc/28))^2 - 5.4;
elseif strcmp(place, "RURAL")
    pl_hata = pl_hata + (18.33 - 4.78*log10(fc))*log10(fc) - 40.97;
end

end