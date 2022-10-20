function [txs] = cellArch(fc,txPowerW,htx)
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
cellLocs   = [
    [39.74470,-8.80825];  % #1
    [39.74684,-8.80337];  % #2
    [39.74909,-8.80831];  % #3
    [39.74688,-8.81319];  % #4
    [39.74237,-8.81295];  % #5
    [39.73991,-8.80831];  % #6
    [39.74227,-8.80300];  % #7
    [39.74453,-8.79796];  % #8
    [39.75133,-8.80283];  % #9
    [39.75189,-8.81256];  % #10
    [39.74454,-8.81853];  % #11
    [39.73801,-8.81293];  % #12
    [39.73771,-8.80298];  % #13
    [39.74869,-8.79909];  % #14
    [39.75351,-8.80828];  % #15
    [39.74901,-8.81761];  % #16
    [39.74014,-8.81798];  % #17
    [39.73556,-8.80804];  % #18
    [39.74055,-8.79838];  % #19
    ];
cellNames  = strings(1,numCells);
cellAngles = zeros(1,numCells);

ld.Value = .50;
ld.Message = 'A definir parâmetros das células ...';
% DEFINE CELL PARAMETERS
cellSectorAngles = [30 150 270];  % Define cell sector angles

scs = [             % SubCarrier Spacing
    15e3;
    30e3;
    60e3;
    120e3;
    240e3;
    ];
ch_size = [         % Channel bandwidth
    10e6;
    15e6;
    20e6;
    25e6;
    30e6;
    40e6;
    50e6;
    60e6;
    70e6;
    80e6;
    90e6;
    100e6;
    ];
nRB = 25; % number of RB for ch size of 5M and scs of 15k
BW_guard = ( (ch_size(1)-5e6)*1e-6 * 1000 - nRB * scs(1)*1e-3 * 12 )/2 - scs(1)*1e-3/2; % em kHz

start_fc = fc - 35e6;
for i = 1:1:numCellSites                            % Criação dos vários canais a serem usados
    fc_vec(i) = start_fc + i*(ch_size(1)-5e6) + i*BW_guard*1e3;
end

cellCounter = 1;
siteCounter = 1;
fc_div = zeros(numCells,1);
for i = 1:numCells
    switch siteCounter
        case {1,8,9,10,11,12,13}
            if cellCounter == 1
              fc_div(i) = fc_vec(1); 
            elseif cellCounter == 2
                fc_div(i) = fc_vec(3); 
            elseif cellCounter == 3
                fc_div(i) = fc_vec(5); 
            end
        
        case {2,4,6,15,17,19}
            if cellCounter == 1
                fc_div(i) = fc_vec(2); 
            elseif cellCounter == 2
                fc_div(i) = fc_vec(4); 
            elseif cellCounter == 3
                fc_div(i) = fc_vec(6); 
            end

        case {3,5,7,14,16,18}
            if cellCounter == 1
                fc_div(i) = fc_vec(7); 
            elseif cellCounter == 2
                fc_div(i) = fc_vec(9); 
            elseif cellCounter == 3
                fc_div(i) = fc_vec(11); 
            end
    end

    cellCounter = cellCounter + 1;
    if cellCounter == 4
        siteCounter = siteCounter + 1;
        cellCounter = 1;
    end
end

% For each cell site location, populate data for each cell transmitter
cellInd = 1;
for siteInd = 1:numCellSites
    % Assign values for each cell
    for cellSectorAngle = cellSectorAngles
        cellNames(cellInd)  = "Célula " + cellInd;
        cellAngles(cellInd) = cellSectorAngle;
        cellInd             = cellInd + 1;
    end
end

% CREATE TRANSMITTER SITES
cellCounter = 1;
siteCounter = 1;
for i = 1:numCells % Create cell transmitter sites
    txs(i) = txsite('Name',cellNames(i),        ...
        'Latitude',cellLocs(siteCounter,1),     ...
        'Longitude',cellLocs(siteCounter,2),    ...
        'Antenna',phasedArray(fc),              ...
        'AntennaAngle',cellAngles(i),           ...
        'AntennaHeight',htx,                    ...
        'TransmitterFrequency',fc_div(i),              ...
        'TransmitterPower',txPowerW);
    
    cellCounter = cellCounter + 1;
    if cellCounter == 4
       siteCounter = siteCounter + 1;
       cellCounter = 1;
    end
end

end