%% CALC - Perdas em espaço-livre (free path loss model)
function pl_f = m_free(fc, d)
% INPUTS:
% fc     -> carrier frequency                                   [Hz]
% d      -> distance between base station and mobile station    [m]
% Gt     -> transmitter gain                                    
% Gr     -> receiver gain                                       
% OUTPUTS:
% pl_f   -> free path loss                                      [dB]

wvl = 3e8 / fc;                                 % wavelength
tmp = (4 * pi * d) ./ wvl;                      % holds fsl with no gains
pl_f = 20 * log10( tmp );                       % free path loss
end