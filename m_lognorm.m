%% CALC - Perdas de percurso com sombreamento log-normal (log-normal shadowing path loss model)
function pl_lognormal = m_lognorm(fc, d, d0, n, sigma)
% INPUTS:
% fc     -> carrier frequency                                   [Hz]
% d      -> distance between base station and mobile station    [m]
% d0     -> reference distance                                  [m]
% n      -> path loss exponent                                  n = [2:6]
% sigma  -> variance                                            [dB]
% OUTPUTS:
% pl_f   -> log-normal path loss                                [dB]

pl_logdistance = m_logdist(fc, d, d0, n);                       % log-distance path loss
pl_lognormal  = pl_logdistance + sigma*randn(size(d));         % log-normal path loss
end