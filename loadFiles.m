function [file_coverage_macro,file_coverage_small,file_sinr_macro,file_sinr_small] = loadFiles(path)
file_coverage_macro = path + "files/macro/coverage/freespace_coverage_macro_02-May-2022.mat";       % <- inserir nome dos ficheiros a seguir ao respetivo caminho secundário
file_coverage_small = path + "files/small/coverage/freespace_coverage_small_03-May-2022.mat";       
file_sinr_macro     = path + "files/macro/sinr/freespace_sinr_03-May-2022.mat";
file_sinr_small     = path + "files/small/sinr/freespace_sinr_03-May-2022.mat";
end