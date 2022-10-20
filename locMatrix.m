function [T,rx_test,vec_BS,loc] = locMatrix(fc,site,SRx)
% INPITS
% ->    site        - Site de transmissão central a partir do qual se vão calcular os sites de receção envolventes
%
% OUTPUTS
% ->    T           - Tabela com as coordenadas de Latitude e Longitude de cada ponto de receção para ser calculado
% ->    rx_test     - Vetor de sites de receção proveniente da matriz de localizações
% ->    vec_BS      - Vetor de distância entre cada site de receção e o site de transmissão central

%% Cria matriz de distâncias
centerSite = site; 
pos = 101;                                                                                              % Ponto central da matriz (21,21 -> matriz de 41x41)
var_a = 9.33 * 1e12;        var_b = 0.02178;        var_c = 29.76;      var_d = -5.4 * 1e12;
max_dist = 5 * ( (1000 * fc * 1e-9) / (var_a * fc * 1e-9 + var_d) ) * exp(-var_b * fc * 1e-9 + var_c);  % Função para calcular a distância máxima lateral
dist     = max_dist/(pos-1);                                                                            % Incremento mínimo de distância / distância unitária entre sites

bw = zeros( pos,pos );
bw( pos, pos ) = 1;
BS = bwdist(bw);
BS = BS*dist;

% Roda matriz
BS_2 = rot90(BS);
BS_3 = rot90(BS_2);
BS_4 = rot90(BS_3);

% Concatena matriz
BS_TOP = horzcat( BS, BS_4(:,2:pos) );
BS_BOT = horzcat( BS_2(2:pos,:), BS_3(2:pos,2:pos) );
BS_F   = vertcat(BS_TOP,BS_BOT);

%% Cria matriz de ângulos
alfa = zeros( pos,pos );
for i = 1:pos
    alfa(i,1) = 90;   % Aplica 90º à 1ª coluna
    alfa(pos,i) = 0;  % Aplica 0º  à última linha
end
alfa(pos,1) = -9999;

% Exemplo
% alfa = calc_cl_angle(alfa,1,21,21,100,2000);
% alfa = calc_cl_angle(alfa,2,20,21,100,1900);
% alfa = calc_cl_angle(alfa,3,19,21,100,1800);
count = 1;
for i = pos:-1:1
    alfa = calc_cl_angle(alfa,count,i,pos,dist,max_dist);
    max_dist = max_dist - dist;
    count = count + 1;
end

% Roda Madriz
alfa_2 = rot90(alfa   + 90);
alfa_3 = rot90(alfa_2 + 90);
alfa_4 = rot90(alfa_3 + 90);

% Concatena matriz
alfa_TOP = horzcat( alfa_2(:,1:pos-1), alfa );
alfa_BOT = horzcat( alfa_3(2:pos,1:pos-1), alfa_4(2:pos,:) );
alfa_F   = vertcat(alfa_TOP,alfa_BOT);

%% Matrizes para vetor
count = 1;
for i = 1:1:length(BS_F)
    for k = 1:1:length(BS_F)
        vec_BS(count)   = BS_F(i,k);
        vec_alfa(count) = alfa_F(i,k);
        count = count + 1;
    end
end

for i = 1:1:length(vec_BS)  % Devolve as coordenadas através da distância de um site de receção e ângulo ao site transmissor central
    [cellLats(i),cellLons(i)] = location(centerSite, vec_BS(i), vec_alfa(i));
end
loc = [min(cellLats) max(cellLats) min(cellLons) max(cellLons)];

assignin('base',"vec_BS",vec_BS);

for i = 1:1:length(vec_BS)
    name = ["Test Site " + num2str(i)];
    rx_test(i) = rxsite("Name",name, ...
        'Latitude',cellLats(i), ...
        'Longitude',cellLons(i), ...
        'ReceiverSensitivity',SRx);
end
%show(rx_test,"Animation","none") % DEBUG

%% Criação de tabela
T = table(cellLats',cellLons');
T.Properties.VariableNames = {'Latitude','Longitude'};

end