function createKML(PATH_SAVE,FILE_SAVE,SIGNALS,TITLE,TYPE,LOC,TX,RX)
%

% ========================================================================
% LOAD ORIGINAL DATA
% ========================================================================
% Leiria city window coordinates
LATITUDE_NORTH = LOC(2);
LATITUDE_SOUTH = LOC(1);
LONGITUDE_WEST = LOC(3);
LONGITUDE_EAST = LOC(4);
SIGNAL_LEVELS  = SIGNALS;

FILE = [PATH_SAVE FILE_SAVE];

%% ====================================================================
%% Create image
%% ====================================================================
SIGNAL_LEVEL_MAP_IMAGE_R = uint8(zeros(length(SIGNAL_LEVELS(:,1)), length(SIGNAL_LEVELS(1,:))));
SIGNAL_LEVEL_MAP_IMAGE_G = uint8(zeros(length(SIGNAL_LEVELS(:,1)), length(SIGNAL_LEVELS(1,:))));
SIGNAL_LEVEL_MAP_IMAGE_B = uint8(zeros(length(SIGNAL_LEVELS(:,1)), length(SIGNAL_LEVELS(1,:))));
if strcmpi(TYPE, "POWER")
    Signal_levels_and_colors = ...
        [1e9    -10     254 000 000
        -10     -20     255 127 000
        -20     -30     254 165 000
        -30     -40     254 206 000
        -40     -50     255 255 000
        -50     -60     184 255 000
        -60     -70     000 255 001
        -70     -80     000 208 000
        -80     -90     000 197 194
        -90     -100    000 148 254
        -100    -110    080 080 254
        -110    -120    000 038 255
        -120    -130    143 063 255
        -130    -140    196 053 255
        -140    -150    254 001 252
        -150    -200    255 193 204];
elseif strcmpi(TYPE, "SINR")
    Signal_levels_and_colors = ...
        [1e9    18     254 000 000
        18      16     255 127 000
        16      14     254 165 000
        14      12     254 206 000
        12      10     255 255 000
        10      8      184 255 000
        8       6      000 255 001
        6       4      000 208 000
        4       2      000 197 194
        2       0      000 148 254
        0       -2     080 080 254
        -2      -5     000 038 255
        -5      -10    143 063 255
        -10     -15    196 053 255
        -15     -20    254 001 252
        -20     -200   255 193 204];
elseif strcmpi(TYPE, "CAPACITY")
    Signal_levels_and_colors = ...
        [1e9    1360   254 000 000
        1360    1290   255 127 000
        1290    1220   254 165 000
        1220    1150   254 206 000
        1150    1080   255 255 000
        1080    1010   184 255 000
        1010    940    000 255 001
        940     870    000 208 000
        870     800    000 197 194
        800     730    000 148 254
        730     660    080 080 254
        660     590    000 038 255
        590     520    143 063 255
        520     450    196 053 255
        450     380    254 001 252
        380     0      255 193 204];
end

for LEVEL_index = 1 : length(Signal_levels_and_colors(:,1))
    LEVEL_MAX = Signal_levels_and_colors(LEVEL_index,1);
    LEVEL_MIN = Signal_levels_and_colors(LEVEL_index,2);
    
    SIGNAL_LEVEL_MAP_IMAGE_R(SIGNAL_LEVELS<LEVEL_MAX & SIGNAL_LEVELS>= LEVEL_MIN) = uint8(Signal_levels_and_colors(LEVEL_index,3));
    SIGNAL_LEVEL_MAP_IMAGE_G(SIGNAL_LEVELS<LEVEL_MAX & SIGNAL_LEVELS>= LEVEL_MIN) = uint8(Signal_levels_and_colors(LEVEL_index,4));
    SIGNAL_LEVEL_MAP_IMAGE_B(SIGNAL_LEVELS<LEVEL_MAX & SIGNAL_LEVELS>= LEVEL_MIN) = uint8(Signal_levels_and_colors(LEVEL_index,5));
end
SIGNAL_LEVEL_MAP_IMAGE(:,:,1) = SIGNAL_LEVEL_MAP_IMAGE_R;
SIGNAL_LEVEL_MAP_IMAGE(:,:,2) = SIGNAL_LEVEL_MAP_IMAGE_G;
SIGNAL_LEVEL_MAP_IMAGE(:,:,3) = SIGNAL_LEVEL_MAP_IMAGE_B;

% imwrite(SIGNAL_LEVEL_MAP_IMAGE,[FILE_LOAD '.png']);


TRANSPARENCY_SIGNAL_LEVELS = ones(size(SIGNAL_LEVEL_MAP_IMAGE_R));

SIGNAL_LEVEL_MAP_IMAGE_R_TRANSPARENT = SIGNAL_LEVEL_MAP_IMAGE_R;
SIGNAL_LEVEL_MAP_IMAGE_G_TRANSPARENT = SIGNAL_LEVEL_MAP_IMAGE_G;
SIGNAL_LEVEL_MAP_IMAGE_B_TRANSPARENT = SIGNAL_LEVEL_MAP_IMAGE_B;

INDEXES = find(SIGNAL_LEVEL_MAP_IMAGE_R == 0 & SIGNAL_LEVEL_MAP_IMAGE_G == 0 & SIGNAL_LEVEL_MAP_IMAGE_B == 0);

SIGNAL_LEVEL_MAP_IMAGE_R_TRANSPARENT(INDEXES) = 255;
SIGNAL_LEVEL_MAP_IMAGE_G_TRANSPARENT(INDEXES) = 255;
SIGNAL_LEVEL_MAP_IMAGE_B_TRANSPARENT(INDEXES) = 255;
TRANSPARENCY_SIGNAL_LEVELS(INDEXES) = 0;


SIGNAL_LEVEL_MAP_IMAGE_TRANSPARENT(:,:,1) = SIGNAL_LEVEL_MAP_IMAGE_R_TRANSPARENT;
SIGNAL_LEVEL_MAP_IMAGE_TRANSPARENT(:,:,2) = SIGNAL_LEVEL_MAP_IMAGE_G_TRANSPARENT;
SIGNAL_LEVEL_MAP_IMAGE_TRANSPARENT(:,:,3) = SIGNAL_LEVEL_MAP_IMAGE_B_TRANSPARENT;

imwrite(SIGNAL_LEVEL_MAP_IMAGE_TRANSPARENT,[FILE '.png'],'Alpha',TRANSPARENCY_SIGNAL_LEVELS);



%% ========================================================================
%% Create KML file
%% ========================================================================
if strcmpi(TYPE, "POWER")
    legend = "kml\extras\powerLegend.png";
elseif strcmpi(TYPE, "SINR")
    legend = "kml\extras\SINRLegend.png";
elseif strcmpi(TYPE, "CAPACITY")
    legend = "kml\extras\capacityLegend.png";
end


descTX  = "TX Location";
descRX  = "RX Location";
tx_icon = "kml\extras\markerTX.png";
rx_icon = "kml\extras\markerRX.png";
g_icon  = "kml\extras\logo.png";

fid_write = fopen([FILE '.kml'],'w');
fprintf(fid_write,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid_write,'<kml xmlns="http://earth.google.com/kml/2.1">\n');
fprintf(fid_write,'  <Folder>\n');
fprintf(fid_write,'   <name>%s</name>\n',TITLE);
fprintf(fid_write,'       <GroundOverlay>\n');
fprintf(fid_write,'		<Icon>\n');
fprintf(fid_write,'              <href>%s.png</href>\n',FILE);
fprintf(fid_write,'		</Icon>\n');
fprintf(fid_write,'            <LatLonBox>\n');
fprintf(fid_write,'               <north>%s</north>\n',num2str(LATITUDE_NORTH));
fprintf(fid_write,'               <south>%s</south>\n',num2str(LATITUDE_SOUTH));
fprintf(fid_write,'               <east>%s</east>\n',num2str(LONGITUDE_EAST));
fprintf(fid_write,'               <west>%s</west>\n',num2str(LONGITUDE_WEST));
fprintf(fid_write,'               <rotation>270</rotation>\n');
fprintf(fid_write,'            </LatLonBox>\n');
fprintf(fid_write,'       </GroundOverlay>\n');
% FOR para TX
counterSite = 1;
counterCell = 1;
for i = 1:1:length(TX)
    fprintf(fid_write,'<Style id="redpin">\n');
    fprintf(fid_write,'  <IconStyle>\n');
    fprintf(fid_write,'    <Icon>\n');
    fprintf(fid_write,'      <href>%s%s</href>\n',PATH_SAVE,tx_icon);
    fprintf(fid_write,'    </Icon>\n');
    fprintf(fid_write,'  </IconStyle>\n');
    fprintf(fid_write,'</Style>\n');
    fprintf(fid_write,'  <Placemark>\n');
    fprintf(fid_write,'    <styleUrl>#redpin</styleUrl>\n');
    fprintf(fid_write,'    <name>Cell %s</name>\n',num2str(i));
    fprintf(fid_write,'    <description>%s</description>\n',descTX);
    fprintf(fid_write,'    <Point>\n');
    fprintf(fid_write,'      <coordinates>%s,%s,0</coordinates>\n',TX(i).Longitude,TX(i).Latitude);
    fprintf(fid_write,'    </Point>\n');
    fprintf(fid_write,'  </Placemark>\n');
end
% FOR para RX
for i = 1:1:length(RX)
    fprintf(fid_write,'<Style id="bluepin">');
    fprintf(fid_write,'  <IconStyle>');
    fprintf(fid_write,'    <Icon>');
    fprintf(fid_write,'      <href>%s%s</href>',PATH_SAVE,rx_icon);
    fprintf(fid_write,'    </Icon>');
    fprintf(fid_write,'  </IconStyle>');
    fprintf(fid_write,'</Style>');
    fprintf(fid_write,'  <Placemark>\n');
    fprintf(fid_write,'    <styleUrl>#bluepin</styleUrl>');
    fprintf(fid_write,'    <name>RX %s</name>\n',num2str(i));
    fprintf(fid_write,'    <description>%s</description>\n',descRX);
    fprintf(fid_write,'    <Point>\n');
    fprintf(fid_write,'      <coordinates>%s,%s,0</coordinates>\n',RX(i).Longitude,RX(i).Latitude);
    fprintf(fid_write,'    </Point>\n');
    fprintf(fid_write,'  </Placemark>\n');
end
fprintf(fid_write,'       <ScreenOverlay>\n');
fprintf(fid_write,'          <name>Color Key</name>\n');
fprintf(fid_write,'            <description>Contour Color Key</description>\n');
fprintf(fid_write,'          <Icon>\n');
fprintf(fid_write,'            <href>%s%s</href>\n',PATH_SAVE,legend);
fprintf(fid_write,'          </Icon>\n');
fprintf(fid_write,'          <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'          <screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'          <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'          <size x="0" y="0" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'       </ScreenOverlay>\n');
fprintf(fid_write,'       <ScreenOverlay>\n');
fprintf(fid_write,'          <name>5G Logo</name>\n');
fprintf(fid_write,'            <description>5G Logo</description>\n');
fprintf(fid_write,'          <Icon>\n');
fprintf(fid_write,'            <href>%s%s</href>\n',PATH_SAVE,g_icon);
fprintf(fid_write,'          </Icon>\n');
fprintf(fid_write,'          <overlayXY x="1" y="1" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'          <screenXY x="0.5" y="1" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'          <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'          <size x="0" y="0" xunits="fraction" yunits="fraction"/>\n');
fprintf(fid_write,'       </ScreenOverlay>\n');
fprintf(fid_write,'  </Folder>\n');
fprintf(fid_write,'</kml>\n');

fclose(fid_write);
end