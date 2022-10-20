function [fc,bw,txs_macro,txs_small,txs_small_opt,txs_post,txs_hex,txs_hex_fix,rxs_macro,rxs_small,place,building_map] = config(path)
% INPUTS
% -> path           - Camnho da diretoria onde se encontram os ficheiros a serem lidos
%
% OUTPUTS
% -> fc             - Vetor de frequências usadas
% -> txs_macro      - Vetor de macrocells
% -> rxs_macro      - Vetor de recetores das macrocells
% -> ...

building_map = path + "map\"+"LeiriaCenter_map.osm";
place = "Leiria";

% ANACOM
% --------------------------------------------------------------------------------------------------------
% 700 MHz  (FDD): 703-733 MHz / 758-788 MHz;
% 900 MHz  (FDD): 880-885 MHz / 925-930 MHz | 895,1-898,1 MHz / 940,1-943,1 MHz | 914-915 MHz / 959-960 MHz;
% 1800 MHz (FDD): 1770-1785 MHz / 1865-1880 MHz;
% 2,1 GHz  (FDD): 1954,9-1959,9 MHz / 2144,9-2149,9 MHz;
% 2,6 GHz  (FDD): 2500-2510 MHz / 2620-2630 MHz;
% 2,6 GHz  (TDD): 2595-2620 MHz;
% 3,6 GHz  (TDD): 3400-3800 MHz.


% Criação dos transmissores (TX) e recetores (RX)
%% TX
fc = [ % Frequência das portadoras
    700e6;    % FR1 - Low Band     ->   700 MHz   -> Melhor taxa de penetração em ambientes urbanos -> usado em mIoT / baixa data rate
    800e6;    % FR1 - Low Band     ->   800 MHz
    900e6;    % FR1 - Low Band     ->   900 MHz
    1500e6;   % FR1 - Low Band     ->   1.5 GHz
    1800e6;   % FR1 - Low Band     ->   1.8 GHz
    1900e6;   % FR1 - Low Band     ->   1.9 GHz
    2100e6;   % FR1 - Low Band     ->   2.1 GHz
    2300e6;   % FR1 - Low Band     ->   2.3 GHz
    2400e6;   % FR1 - Low Band     ->   2.4 GHz
    2500e6;   % FR1 - Low Band     ->   2.5 GHz
    2600e6;   % FR1 - Low Band     ->   2.3 GHz
    3500e6;   % FR1 - High Band    ->   3.5 GHz   -> Mix entre cobertura e capacidade
    3700e6;   % FR1 - High Band    ->   3.7 GHz
    4700e6;   % FR1 - High Band    ->   4.7 GHz
    5200e6;   % FR1 - High Band    ->   5.2 GHz
    5900e6;   % FR1 - High Band    ->   5.9 GHz
    6000e6;   % FR1 - High Band    ->   6.0 GHz

    26000e6;  % FR2      ->   26 GHz   -> Alto data rate / curto alcance
    28000e6;  % FR2      ->   28 GHz
    39000e6;  % FR2      ->   39 GHz
    41000e6;  % FR2      ->   41 GHz
    47000e6;  % FR2      ->   47 GHz
    ];
bw = [ % Largura de banda
    5;          % min for FR1               
    10;
    20;
    50;         % min for FR2
    100;        % max for FR1
    200;
    400;        % max for FR2
    ];
macro_name_vec = [ % Vetor de nomes das macrocells
    "MACRO_ID 324 "
    "MACRO_ID 325"
    "MACRO_ID 329"
    "MACRO_ID 625"
    "MACRO_ID 5007"
    "MACRO_ID 16320"
    "MACRO_ID 16321"
    "MACRO_ID 16323"
    "MACRO_ID 16324"
    "MACRO_ID 16326"
    "MACRO_ID 16327"
    ];
small_name_vec = [
    "SMALL_ID 1"
    "SMALL_ID 2"
    "SMALL_ID 3"
    "SMALL_ID 4"
    "SMALL_ID 5"
    "SMALL_ID 6"
    "SMALL_ID 7"
    "SMALL_ID 8"
];
macro_loc_vec = [ % vetor de latitudes e longitudes das torres existentes em Leiria
    [39.74040,-8.80709];         % ID 324
    [39.74173,-8.81027];         % ID 325
    [39.74693,-8.81667];         % ID 329
    [39.75366,-8.81864];         % ID 625
    [39.75039,-8.81243];         % ID 5007
    [39.74292,-8.80862];         % ID 16320
    [39.74224,-8.81714];         % ID 16321
    [39.75076,-8.80392];         % ID 16323
    [39.74713,-8.80751];         % ID 16324
    [39.74682,-8.82099];         % ID 16326
    [39.74111,-8.79948]          % ID 16327
    ];
small_loc_vec = [
    [39.74973,-8.81306];   % stadium 1
    [39.74789,-8.81282];   % stadium 2
    [39.74839,-8.81220];   % stadium 3
    [39.74825,-8.81355];   % stadium 4
    [39.74919,-8.81365];   % stadium 5
    [39.74929,-8.81235];   % stadium 6
    [39.74886,-8.81224];   % stadium 7
    [39.74877,-8.81361]    % stadium 8
    ];
post_loc_vec = [
    [39.74138,-8.81049];   % post 1
    [39.74174,-8.81076];   % post 2
    [39.74224,-8.81105];   % post 3
    [39.74270,-8.81143];   % post 4
    ]; 
macro_htx_vec = [ % vetor de alturas TX       [m]
    3.5;    % ID 324
    3.5;    % ID 325
    3.5;    % ID 329
    3.5;    % ID 625
    3.5;    % ID 5007
    3.5;    % ID 16320
    3.5;    % ID 16321
    3.5;    % ID 16323
    3.5;    % ID 16324
    3.5;    % ID 16326
    3.5     % ID 16327
    ];
small_htx_vec = [ % vetor de alturas TX       [m]
    1.5;   % stadium 1
    1.5;   % stadium 2
    1.5;   % stadium 3
    1.5;   % stadium 4
    1.5;   % stadium 5
    1.5;   % stadium 6
    1.5;   % stadium 7
    1.5    % stadium 8
    ];
post_htx = 10;
Ptx_vec = [ % vetor de potências TX     [W]
    10 ^ ((45 - 30) / 10);    % macrocells   ->  max de 45dBm (outdoors)
    10 ^ ((40 - 30) / 10);    % microcells   ->  max de 40dBm (outdoors)
    10 ^ ((37 - 30) / 10);    % picocells    ->  max de 37dBm (outdoors)
    10 ^ ((30 - 30) / 10);    % picocells    ->  min de 30dBm (outdoors)
    10 ^ ((30 - 30) / 10)     % femtocells   ->  max de 30dBm (outdoors)
    10 ^ ((23 - 30) / 10)     % femtocells   ->  min de 23dBm (outdoors)
    ];


% criação das macrocells
for i = 1:1:length(macro_loc_vec)
    txs_macro(i) = txsite("Name",macro_name_vec(i),               ...
        "Latitude"              ,macro_loc_vec(i,1),              ...
        "Longitude"             ,macro_loc_vec(i,2),              ...
        "Antenna"               ,design(dipole,fc(12)),           ...
        "AntennaHeight"         ,macro_htx_vec(i),                ...   % Units: m
        "TransmitterFrequency"  ,fc(12),                          ...   % Units: Hz
        "TransmitterPower"      ,Ptx_vec(1));                           % Units: W
end

% criação das small cells do estádio
for i = 1:1:length(small_loc_vec)
    txs_small(i) = txsite("Name",small_name_vec(i),               ...
        "Latitude"              ,small_loc_vec(i,1),              ...
        "Longitude"             ,small_loc_vec(i,2),              ...
        "Antenna"               ,phasedArray_small(fc(19)),             ...
        "AntennaHeight"         ,small_htx_vec(i),                ...   % Units: m
        "TransmitterFrequency"  ,fc(19),                          ...   % Units: Hz
        "TransmitterPower"      ,Ptx_vec(6));                           % Units: W
end

scs = [   % SubCarrier Spacing
    15e3;
    30e3;
    60e3;
    120e3;
    240e3;
    ];
nRB = 66;
BW_guard = ( bw(4) * 1000 - nRB * scs(3)*1e-3 * 12 )/2 - scs(3)*1e-3/2; % em kHz

start_fc = fc(19) - 205e6;
for i = 1:1:8                            % Criação dos vários canais a serem usados nas small cells do estádio
    fc_vec(i) = start_fc + i*bw(4)*1e6 + i*BW_guard*1e3;
end

% criação das small cells do estádio otimizadas
for i = 1:1:length(small_loc_vec)
    txs_small_opt(i) = txsite("Name",small_name_vec(i),           ...
        "Latitude"              ,small_loc_vec(i,1),              ...
        "Longitude"             ,small_loc_vec(i,2),              ...
        "Antenna"               ,phasedArray_small(fc(19)),       ...
        "AntennaHeight"         ,small_htx_vec(i),                ...   % Units: m
        "TransmitterFrequency"  ,fc_vec(i),                       ...   % Units: Hz
        "TransmitterPower"      ,Ptx_vec(6));                           % Units: W
end

% criação das small cells dos postes de iluminacao
for i = 1:1:length(post_loc_vec)
    name = ["Poste Iluminação " + num2str(i)];
    txs_post(i) = txsite("Name" ,name,                            ...
        "Latitude"              ,post_loc_vec(i,1),               ...
        "Longitude"             ,post_loc_vec(i,2),               ...
        "Antenna"               ,phasedArray_small(fc(21)),             ...
        "AntennaHeight"         ,post_htx,                        ...   % Units: m
        "TransmitterFrequency"  ,fc(21),                          ...   % Units: Hz
        "TransmitterPower"      ,Ptx_vec(4));                           % Units: W
end

% criação das macrocells da arquitetura celular
htx = [25 3.5];
txs_hex     = cellArch(fc(12),Ptx_vec(2),htx(1));
txs_hex_fix = cellArchFIX(fc(12),Ptx_vec(2),htx(2));


%% RX
rx_macro_loc = [              % vetor de latitudes e longitudes dos RX
    [39.74417,-8.79574];    % torre hospital
    [39.74452,-8.80805];    % praça rodrigues lobo
    [39.74125,-8.80206]     % parque dos mortos
    ];
rx_small_loc = [39.74878,-8.81293];    % no centro do estádio de Leiria    
hrx_vec = 1.5;              % vetor de alturas RX             [m]
Srx_vec = [                 % vetor de sensibilidades RX      [dBm]
    -97;                    % B = 5MHz
    -94;                    % B = 10MHz
    -91;                    % B = 20MHz
    -87;                    % B = 50MHz
    -84;                    % B = 100MHz
    -81;                    % B = 200MHz
    -78                     % B = 400MHz
    ];

% criação dos recetores
for i = 1:1:length(rx_macro_loc)
    name = ["RX_MACRO " + num2str(i)];
    rxs_macro(i) = rxsite("Name"      ,name,                                         ...
        "Latitude"              ,rx_macro_loc(i,1),                                  ...
        "Longitude"             ,rx_macro_loc(i,2),                                  ...
        "Antenna"               ,design(dipole,txs_macro(1).TransmitterFrequency),   ...
        "AntennaHeight"         ,hrx_vec,                                            ...   % Units: m
        "ReceiverSensitivity"   ,Srx_vec(5));                                              % Units: dBm
end

name = ["RX_SMALL " + num2str(1)];
rxs_small = rxsite("Name"      ,name,                                            ...
    "Latitude"              ,rx_small_loc(1,1),                                  ...
    "Longitude"             ,rx_small_loc(1,2),                                  ...
    "Antenna"               ,design(dipole,txs_small(1).TransmitterFrequency),   ...
    "AntennaHeight"         ,hrx_vec,                                            ...   % Units: m
    "ReceiverSensitivity"   ,Srx_vec(6));                                              % Units: dBm

end