function [txs] = cellArch(fc,txPowerW,htx)
% INPUTS
% ->         fc         - Frequência de funcionamento das antenas dos sites
% ->         txPower    - Potência de transmissão dos sites
% ->         htx        - Altura dos transmissores
%
% OUTPUTS
% ->         txs        - Vetor de sites de transmissão


% DEFINE NETWORK LAYOUT
% Define center location site (cells 1-3)
centerSite = txsite('Name','Praça Rodrigues Lobo', ...
    'Latitude', 39.74452,                          ...
    'Longitude',-8.80805);

% Initialize arrays for distance and angle from center location to each cell site, where each site has 3 cells
numCellSites = 19;
siteDistances = zeros(1,numCellSites);
siteAngles    = zeros(1,numCellSites);

% Define distance and angle for inner ring of 6 sites (cells 4-21)
isd = 500;                          % Inter-site distance
siteDistances(2:7) = isd;
siteAngles(2:7)    = 30:60:360;

% Define distance and angle for middle ring of 6 sites (cells 22-39)
siteDistances(8:13) = 2*isd*cosd(30);
siteAngles(8:13)    = 0:60:300;

% Define distance and angle for outer ring of 6 sites (cells 40-57)
siteDistances(14:19) = 2*isd;
siteAngles(14:19)    = 30:60:360;

% Initialize arrays for cell transmitter parameters
numCells   = numCellSites*3;
cellLats   = zeros(1,numCells);
cellLons   = zeros(1,numCells);
cellNames  = strings(1,numCells);
cellAngles = zeros(1,numCells);

ld.Value = .50;
ld.Message = 'A definir parâmetros das células ...';
% DEFINE CELL PARAMETERS
cellSectorAngles = [30 150 270];  % Define cell sector angles

% For each cell site location, populate data for each cell transmitter
cellInd = 1;
for siteInd = 1:numCellSites
    % Compute site location using distance and angle from center site
    [cellLat,cellLon] = location(centerSite, siteDistances(siteInd), siteAngles(siteInd));

    % Assign values for each cell
    for cellSectorAngle = cellSectorAngles
        cellNames(cellInd)  = "Célula " + cellInd;
        cellLats(cellInd)   = cellLat;
        cellLons(cellInd)   = cellLon;
        cellAngles(cellInd) = cellSectorAngle;
        cellInd             = cellInd + 1;
    end
end

% CREATE TRANSMITTER SITES
for i = 1:numCells % Create cell transmitter sites
    txs(i) = txsite('Name',cellNames(i),   ...
        'Latitude',cellLats(i),            ...
        'Longitude',cellLons(i),           ...
        'Antenna',phasedArray(fc),         ...
        'AntennaAngle',cellAngles(i),      ...
        'AntennaHeight',htx,               ...
        'TransmitterFrequency',fc,         ...
        'TransmitterPower',txPowerW);
end

end