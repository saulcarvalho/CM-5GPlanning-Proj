%% CALC - Perdas em espaço-livre generalizado (log-distance path loss model)
function pl_logdistance = m_logdist(fc, d, d0, n)
% INPUTS:
% fc     -> carrier frequency                                   [Hz]
% d      -> distance between base station and mobile station    [m]
% d0     -> reference distance                                  [m]
% n      -> path loss exponent                                  n = [2:6]
% OUTPUTS:
% pl_ld   -> log-distance path loss                             [dB]

%pl_free = m_free(fc, d0);                                       % free path loss 
ld      = 10 * n * log10(d / d0);                               % log-distance
%pl_logdistance = pl_free  + ld;                                 % log-distance path loss
pl_logdistance = ld;                                 % log-distance path loss
end