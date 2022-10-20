function [macro_ant,small_ant_stadium,small_ant_post] = genAntenna(fc)
 
macro_ant = phasedArray_macro(fc(12));    % Antenna used for macrocell coverage
small_ant_stadium = phasedArray_small(fc(19));    % Antenna used for stadium
small_ant_post    = phasedArray_small(fc(21));    % Antenna used for directional and specific usage like V2X and high speed traffic 

end