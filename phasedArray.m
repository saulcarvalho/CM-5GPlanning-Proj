function antennaArray = phasedArray(fq)
% modified helperM2412PhasedArray

% Define pattern parameters
azvec = -180:180;
elvec = -90:90;
Am = 60;    % Maximum attenuation (dB)              <- (default = 30) Aumentar este valor reduz o lóbulo principal da cauda
tilt = 0;   % Tilt angle
az3dB = 35; % 3 dB bandwidth in azimuth             <- (default = 65) Baixar estes 2 valores faz com que a antena fique mais diretiva, concentra a radiação
el3dB = 35; % 3 dB bandwidth in elevation

% Define antenna pattern
[az,el] = meshgrid(azvec,elvec);
azMagPattern = -12*(az/az3dB).^2;
elMagPattern = -12*((el-tilt)/el3dB).^2;
combinedMagPattern = azMagPattern + elMagPattern;
combinedMagPattern(combinedMagPattern<-Am) = -Am;    % Saturate at max attenuation
phasepattern = zeros(size(combinedMagPattern));

% Create antenna element
antennaElement = phased.CustomAntennaElement(     ...
    'AzimuthAngles',azvec,                        ...
    'ElevationAngles',elvec,                      ...
    'MagnitudePattern',combinedMagPattern,        ...
    'PhasePattern',phasepattern);

% Define array size 
nrow = 8;                   % <- (default = 8) Diminuir o número de elementos do array faz com que o lóbulo principal expanda e reduz o número de lóbulos secundários
ncol = 2;                   % <- aumentar este valor aumenta o ganho, torna o array mais diretivo e aumenta o número de lóbulos secundários

% Define element spacing
lambda = physconst('lightspeed')/fq;
drow = lambda/2;
dcol = lambda/2;

% Create 8-by-8 antenna array
antennaArray = phased.URA('Size',[nrow ncol], ...   
    'Element',antennaElement,                 ...
    'ElementSpacing',[drow dcol]);