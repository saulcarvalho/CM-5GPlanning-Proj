function sim5G_urban
% ---------------------------------------------------------------------------------
%                   Simulador 5G Urbano (Planeamento Celular)
% ---------------------------------------------------------------------------------
%
% Esta função permite criar um simulador de planeamento de rede 5G,
% recorrendo a outras funções para tal, sendo essas mesmas funções do
% MATLAB ou criadas de raiz.
%
% Este simulador é facilmente adaptável tanto para outras localizações como
% para outros parâmetros através da edição do ficheiro config.m
%
evalin('base', 'clc')
evalin('base', 'clear vars')
evalin('base', 'clear all')
all_fig = findall(groot,'Type','figure');

if all_fig ~= 0
    close(all_fig);
end
%%
%%----------------------------------------------------------------------------------------------------------------
%                       Comunicações Móveis - Simulador de planeamento de rede 5G urbana
% ----------------------------------------------------------------------------------------------------------------

% NOTAS :
% -> Usar torres existentes para as macrocells porque nenhuma operadora vai investir em novas torres se não for necessário.
% -> Para small cells criar estações-base novas. Cada célula depende da densidade populacional, da quantidade de utilizadores
%    em cada operadora, a área a cobrir, o período anual, o período diário de utilização, o tipo de utilizador.
% -> Baixas frequências como 700MHz são apenas usadas para fornecer uma ligação 5G de baixo débito aos utilizadores.
% -> Frequências como 3.6GHz (banda de 3.4 a 3.8GHz) são usadas para
%    estabelecer ligações com débitos mais elevados mas a curtas distâncias, como o caso de small cells.
% -> No planeamento de uma rede é primeiro feito uma abordagem genérica com agregados de células. Mais tarde conforme a morfologia geográfica,
%    as estações-base são ajustadas, mediante a sua difusão, ou seja, passa a ser feita uma divisão setorial.
% -> Para redes novas, tipicamente alteram-se s infraestruturas existentes, ou seja, reutilizam-se as torres existentes,
%    mudando as antenas e sistemas das mesmas.

cprintf('*magenta', ['>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Simulador de rede 5G urbana <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<' newline]);
cprintf('*black',   ['                                                por Saúl Carvalho' newline]);

% Deve ser mudado este path para o caminho da pasta do simulador
path  = 'D:\Utilizador\OneDrive - IPLeiria\2_PolitecnicoLeiria\2_Licenciatura_EEC_19_22\3_Ano\Eletronica_Computadores\Semestre_2\ComunicacoesMoveis\3_PL\Projeto\Proj\';
path2 = 'D://Utilizador/OneDrive - IPLeiria/2_PolitecnicoLeiria/2_Licenciatura_EEC_19_22/3_Ano/Eletronica_Computadores/Semestre_2/ComunicacoesMoveis/3_PL/Projeto/Proj/';

[fc,bw,txs_macro,txs_small,txs_small_opt,txs_post,txs_hex,txs_hex_fix,rxs_macro,rxs_small,place,building_map] = config(path);
[macro_ant,small_ant_stadium,~] = genAntenna(fc);

f1 = uifigure("MenuBar","none",                ...
    "ToolBar"          ,"none",                ...
    "Name"             ,"Simulador Urbano 5G", ...
    'NumberTitle'      ,"off",                 ...
    "WindowState"      ,"maximized",           ...
    "Icon", path+"img\"+"tab_logo.png");
assignin('base', 'f1', f1);


%% TABS
im = uiimage(f1,'ImageSource',path+"img\"+'sim_logo2.png');
im.InnerPosition = [870 875 200 200];       % x, y , size_x, size y
im.Tooltip = sprintf(['Simulador de rede 5G urbano/suburbano, criado no âmbito de projeto da unidade curricular de Comunicações Móveis.\n\n' ...
    'Desenvolvido por Saúl S. Carvalho [2022]']);
im2 = uiimage(f1,'ImageSource',path+"img\"+'ipl_logo.png');
im2.InnerPosition = [10 890 180 180];
im3 = uiimage(f1,'ImageSource',path+"img\"+'matlab.png');
im3.InnerPosition = [210 890 170 170];

tg = uitabgroup(f1,'Position',[10 10 1900 930]);
t1 = uitab(tg,'Title','Painel de Controlo');
t1.Scrollable = 'on';
t2 = uitab(tg,'Title','Ajuda');
t2.Scrollable = 'on';

m = uicontrol(f1,'Style','text','fontweight','bold','FontSize',10,'HorizontalAlignment','right');
m.Position = [1690 982 130 20];
m.String = {'Modo Simulação'};

selMode = uicontrol(f1,'Style','popupmenu','fontweight','bold','HorizontalAlignment','center');
selMode.Position = [1830 980 80 30];
selMode.String = {'RUN','LOAD'};
selMode.Value = 1;
selMode.Callback = @selMode_cb;
assignin('base','simMode','0');

m = uicontrol(f1,'Style','text','fontweight','bold','FontSize',10,'HorizontalAlignment','right');
m.Position = [1690 947 130 20];
m.String = {'Modo Geração'};

genMode = uicontrol(f1,'Style','popupmenu','fontweight','bold','HorizontalAlignment','center');
genMode.Position = [1830 945 80 30];
genMode.String = {'NORMAL','FAST'};
genMode.Value = 2;
genMode.Callback = @genMode_cb;
assignin('base','genMode','1');

m = uicontrol(f1,'Style','text','fontweight','bold','FontSize',10,'HorizontalAlignment','right');
m.Position = [1400 982 140 20];
m.String = {'Modo Planeamento'};

planMode = uicontrol(f1,'Style','popupmenu','fontweight','bold','HorizontalAlignment','center');
planMode.Position = [1550 980 120 30];
planMode.String = {'INICIAL','OPTIMIZADO'};
planMode.Value = 1;
planMode.Callback = @planMode_cb;
assignin('base','planMode','0');

m = uicontrol(t1,'Style','text','fontweight','bold','HorizontalAlignment','left');
m.Position = [280 975 300 22];
m.String = {'Cobertura, Best-Servers, Handover e Feixes Hertzianos'};

tg2 = uitabgroup(t1,'Position',[280 480 320 500]);
t3  = uitab(tg2,'Title','Macrocells');
t4  = uitab(tg2,'Title','Small cells ');


m = uicontrol(t1,'Style','text','fontweight','bold','HorizontalAlignment','left');
m.Position = [960 975 180 22];
m.String = {'Diagramas de radiação das antenas'};

tg3 = uitabgroup(t1,'Position',[960 480 320 500]);
t5  = uitab(tg3,'Title','Macrocells');
t6  = uitab(tg3,'Title','Small cells ');
tg4 = uitabgroup(t4,'Position',[10 10 300 250]);
t_handover = uitab(tg4,'Title','Teste Handover');


m = uicontrol(t1,'Style','text','fontweight','bold','HorizontalAlignment','left');
m.Position = [620 975 180 22];
m.String = {'Capacidade'};

tg5 = uitabgroup(t1,'Position',[620 480 320 500]);
t7  = uitab(tg5,'Title','');

m = uicontrol(t1,'Style','text','fontweight','bold','HorizontalAlignment','left');
m.Position = [1300 975 180 22];
m.String = {'Outras funcionalidades'};

tg6 = uitabgroup(t1,'Position',[1300 480 320 500]);
t8  = uitab(tg6,'Title','');

helpSim(t2);       % janela de ajuda para o simulador
propModel_sel(t1); % seletor de modelo de propagação
[file_coverage_macro,file_coverage_small,file_sinr_macro,file_sinr_small]  = loadFiles(path);


%% BUTTONS AND OTHERS
a = uicontrol(f1,'Style','text','fontweight','bold','FontSize',12,'ForegroundColor','black');
a.InnerPosition = [410 967 60 20];       % x, y , size_x, size y
a.String = {'Cidade: '};
a = uicontrol(f1,'Style','text','fontweight','bold','FontSize',12,'ForegroundColor','blue');
a.InnerPosition = [470 967 50 20];       % x, y , size_x, size y
a.String = {place};

aa = uicontrol(t1,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
aa.InnerPosition = [10 120 260 40];
aa.String = 'Estações-base Vodafone e recetores';
aa.Tooltip = sprintf('Permite verificar as localizações da estações-base da Vodafone da cidade em estudo e os recetores.');
aa.Callback = @cb0;

aa2 = uicontrol(t1,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
aa2.InnerPosition = [10 170 260 40];
aa2.String = 'Arquitetura celular (sem ajustes)';
aa2.Tooltip = sprintf('Permite verificar as localizações da estações-base em arquitetura celular hexagonal sem ajustes.');
aa2.Callback = @cb_hex;

aa3 = uicontrol(t1,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
aa3.InnerPosition = [10 220 260 40];
aa3.String = 'Arquitetura celular (ajustada)';
aa3.Tooltip = sprintf('Permite verificar as localizações da estações-base em arquitetura celular hexagonal ajustada.');
aa3.Callback = @cb_hex_fix;

b1 = uicontrol(t3,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
b1.InnerPosition = [10 420 300 40];
b1.String = 'Mapa de Cobertura';
b1.Tooltip = sprintf(['Permite criar um mapa de cobertura das várias macrocells. \n' ...
    'Mostra adicionalmente os diagramas de radiação de cada antena, linhas de vista e budget link entre macrocells e recetores.']);
b1.Callback = @cb_macro;

b2 = uicontrol(t4,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
b2.InnerPosition = [10 420 300 40];
b2.String = 'Mapa de Cobertura';
b2.Tooltip = sprintf(['Permite criar um mapa de cobertura das várias small cells. \n' ...
    'Mostra adicionalmente os diagramas de radiação de cada antena, linhas de vista e budget link entre small cells e recetores.']);
b2.Callback = @cb_small;

c1 = uicontrol(t3,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
c1.InnerPosition = [10 320 300 40];
c1.String = 'Mapa de SINR';
c1.Tooltip = sprintf(['Permite criar um mapa da relação sinal-ruído-interferência das várias macrocells. ' ...
    'Através deste mapa é possível identificar o efeito da interferência das várias estações-base adjacentes.']);
c1.Callback = @cb2;

c1a = uicontrol(t4,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
c1a.InnerPosition = [10 320 300 40];
c1a.String = 'Mapa de SINR';
c1a.Tooltip = sprintf(['Permite criar um mapa da relação sinal-ruído-interferência das várias small cells. ' ...
    'Através deste mapa é possível identificar o efeito da interferência das várias estações-base adjacentes.']);
c1a.Callback = @cb2_small;

c2 = uicontrol(t_handover,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
c2.InnerPosition = [30 180 240 40];
c2.String = 'Verificar Handover';
c2.Tooltip = sprintf('Permite verificar a situação de handover de uma estação-base para outra de um recetor num veículo ao se deslocar ao longo de uma estrada.');
c2.Callback = @cb_handover;

d1a = uicontrol(t4,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
d1a.InnerPosition = [10 270 300 40];
d1a.String = 'Perfil Atraso Potência';
d1a.Tooltip = sprintf('Permite criar o perfil de atraso de potência para uma small cell.');
d1a.Callback = @cb_delayProfile;

m = uicontrol(t_handover,'Style','text','ForegroundColor','magenta','FontSize', 12,'fontweight','bold','HorizontalAlignment','center');
m.Position = [30 150 240 22];
m.String = {'Deslocar veículo'};

m = uicontrol(t_handover,'Style','text','fontweight','bold','HorizontalAlignment','center');
m.Position = [30 120 240 22];
m.String = {'Posição:'};

p1value = uicontrol(t_handover,'Style','text','ForegroundColor','blue','fontweight','bold');
p1value.Position = [140 90 20 15];       % x, y , size_x, size y
car_loc_now = 0;
p1value.String = num2str(car_loc_now);

c3 = uicontrol(t_handover,"Style","pushbutton",'fontweight','bold','FontSize', 14,'ForegroundColor','black','BackgroundColor','white');
c3.InnerPosition = [230 80 40 40];
c3.String = '+';
c3.Tooltip = sprintf('Próxima posição do veículo no teste de handover.');
c3.Callback = @cb_handover_plus;

c4 = uicontrol(t_handover,"Style","pushbutton",'fontweight','bold','FontSize', 14,'ForegroundColor','black','BackgroundColor','white');
c4.InnerPosition = [30 80 40 40];
c4.String = '-';
c4.Tooltip = sprintf('Posição anterior do veículo no teste de handover.');
c4.Callback = @cb_handover_minus;
c4.BackgroundColor = 'red';
c4.ForegroundColor = 'white';

d1 = uicontrol(t3,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
d1.InnerPosition = [10 370 300 40];
d1.String = 'Mapa de Best-servers';
d1.Tooltip = sprintf(['Permite identificar a macrocell best-server para cada recetor através do nível de potência' ...
    ' e através da distância entre as macrocells e recetores.']);
d1.Callback = @cb3;

d2 = uicontrol(t4,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
d2.InnerPosition = [10 370 300 40];
d2.String = 'Mapa de Best-servers';
d2.Tooltip = sprintf(['Permite identificar a small cell best-server para cada recetor através do nível de potência' ...
    ' e através da distância entre as small cell e recetores.']);
d2.Callback = @cb4;


e1 = uicontrol(t5,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
e1.InnerPosition = [10 420 300 40];
e1.String  = 'Verificar diagrama radiação';
e1.Tooltip = sprintf('Permite verificar o diagrama de radiação baseado no tipo de antena usado para a estação-base em causa.');
e1.Callback = @cb_macro_ant;

e1a = uicontrol(t5,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
e1a.InnerPosition = [10 370 300 40];
e1a.String  = 'Verificar diagrama diretividade';
e1a.Tooltip = sprintf('Permite verificar o diagrama de diretividade baseado no tipo de antena usado para a estação-base em causa.');
e1a.Callback = @cb_macro_ant_az;

e2 = uicontrol(t6,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
e2.InnerPosition = [10 420 300 40];
e2.String  = 'Verificar diagrama radiação (TX)';
e2.Tooltip = sprintf('Permite verificar o diagrama de radiação baseado no tipo de antena usado para a estação-base em causa.');
e2.Callback = @cb_small_ant;

e2a = uicontrol(t6,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
e2a.InnerPosition = [10 370 300 40];
e2a.String  = 'Verificar diagrama diretividade (TX)';
e2a.Tooltip = sprintf('Permite verificar o diagrama de diretividade baseado no tipo de antena usado para a estação-base em causa.');
e2a.Callback = @cb_small_ant_az;

e2b = uicontrol(t6,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
e2b.InnerPosition = [10 320 300 40];
e2b.String  = 'Verificar diagrama radiação (RX)';
e2b.Tooltip = sprintf('Permite verificar o diagrama de radiação baseado no tipo de antena usado para o veículo.');
e2b.Callback = @cb_small_ant_car;

e2c = uicontrol(t6,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
e2c.InnerPosition = [10 270 300 40];
e2c.String  = 'Verificar diagrama diretividade (RX)';
e2c.Tooltip = sprintf('Permite verificar o diagrama de diretividade baseado no tipo de antena usado para o veículo.');
e2c.Callback = @cb_small_ant_az_car;

f1a = uicontrol(t3,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
f1a.InnerPosition = [10 270 300 40];
f1a.String = 'Mapa LoS, Reflexões e Budget-Link';
f1a.Tooltip = sprintf('Permite identificar linhas de vista e budget-link entre estações-base e recetores.');
f1a.Callback = @cb_f1a;


g1 = uicontrol(t7,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','red','BackgroundColor','white');
g1.InnerPosition = [10 420 300 40];
g1.String = 'Gerador de Tráfego';
g1.Tooltip = sprintf('Permite definir um padrão de tráfego de chamadas.');
g1.Callback = @cb_genTraffic;

g2 = uicontrol(t7,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
g2.InnerPosition = [10 370 300 40];
g2.String = 'Densidade Populacional';
g2.Tooltip = sprintf('Permite verificar um modelo de densidade populacional da cidade de Leiria.');
g2.Callback = @cb_popDensity;

g3 = uicontrol(t7,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
g3.InnerPosition = [10 320 300 40];
g3.String = 'Mapa de Capacidade - Macrocells';
g3.Tooltip = sprintf('Permite gerar um mapa de capacidade através de um modelo de densidade populacional.');
g3.Callback = @cb_capacity;

g4 = uicontrol(t8,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
g4.InnerPosition = [10 420 300 40];
g4.String = 'Verificação Global';
g4.Tooltip = sprintf('Permite verificar algumas estimativas para certos parâmetros da rede.');
g4.Callback = @cb_finalCheck;

g5 = uicontrol(t8,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
g5.InnerPosition = [10 370 300 40];
g5.String = 'Cell Breathing';
g5.Tooltip = sprintf('Permite verificar a funcionalidade de cell breathing');
g5.Callback = @cb_cellBreath;

cb_handover_OK = 1;
cb_macro_OK = 1;
cb_small_OK = 1;
cb2_OK = 1;
cb3_OK = 1;
cb4_OK = 1;
cb_f1a_OK = 1;
cb_delay_OK = 1;
cb_capacity_OK = 1;
assignin('base','planString','PI');

%% SIM MODE
    function selMode_cb(~,~)
        selString = selMode.String{selMode.Value};
        switch selString
            case {'RUN'}
                assignin('base','simMode','0');
            case 'LOAD'
                assignin('base','simMode','1');
            otherwise
                fprintf([' > «!» Modo de arranque do simulador não reconhecido. «!»' newline]);
        end
    end


%% GEN MODE
    function genMode_cb(~,~)
        selString = genMode.String{genMode.Value};
        switch selString
            case {'NORMAL'}
                assignin('base','genMode','0');
            case 'FAST'
                assignin('base','genMode','1');
            otherwise
                fprintf([' > «!» Modo de cálculos do simulador não reconhecido. «!»' newline]);
        end
    end

%% PLAN MODE
    function planMode_cb(~,~)
        selString = planMode.String{planMode.Value};
        switch selString
            case {'INICIAL'}
                assignin('base','planMode','0');
                assignin('base','planString','PI');
            case 'OPTIMIZADO'
                assignin('base','planMode','1');
                assignin('base','planString','PO');
            otherwise
                fprintf([' > «!» Modo de planeamento do simulador não reconhecido. «!»' newline]);
        end
    end


%% ARQUITETURA CELULAR - SEM AJUSTES
    function cb_hex(~,~)
        ld = uiprogressdlg(f1,'Title','Arquitetura celular hexagonal (sem ajustes)','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
        if evalin('base', 'exist(''viewer_hex'',''var'')')
            evalin('base', 'close(viewer_hex)');
        end

        assignin('base','viewer_hex', ...
            siteviewer("Name","Simulador de Rede 5G Urbana - Arquitetura celular hexagonal (sem ajustes)", ...
            "Position"            ,[0 0 1920 1050],          ...
            "Basemap"             ,"openstreetmap",          ...
            "Terrain"             ,"gmted2010",              ...
            "Buildings"           ,building_map)             ...
            );

        ld.Value = .50;
        ld.Message = 'A criar macrocells ...';
        show(txs_hex,'Animation','none','Map',evalin('base', 'viewer_hex'))
        if evalin('base', 'genMode') == '0'
            for i = 1:1:length(txs_hex) % show macrocells and patterns
                pattern(txs_hex(i),txs_hex(i).TransmitterFrequency,'Size',8,'Map',evalin('base', 'viewer_hex'));
            end
        end

        ld.Value = 1;
        ld.Message = 'A terminar ...';
        pause(1);
        close(ld);
    end

%% ARQUITETURA CELULAR - AJUSTADA
    function cb_hex_fix(~,~)
        ld = uiprogressdlg(f1,'Title','Arquitetura celular hexagonal (ajustada)','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
        if evalin('base', 'exist(''viewer_hex_fix'',''var'')')
            evalin('base', 'close(viewer_hex_fix)');
        end

        assignin('base','viewer_hex_fix', ...
            siteviewer("Name","Simulador de Rede 5G Urbana - Arquitetura celular hexagonal (ajustada)", ...
            "Position"            ,[0 0 1920 1050],          ...
            "Basemap"             ,"openstreetmap",          ...
            "Terrain"             ,"gmted2010",              ...
            "Buildings"           ,building_map)             ...
            );

        ld.Value = .50;
        ld.Message = 'A criar macrocells ...';
        show(txs_hex_fix,'Animation','none','Map',evalin('base', 'viewer_hex_fix'));
        if evalin('base', 'genMode') == '0'
            for i = 1:1:length(txs_hex_fix) % show macrocells and patterns
                pattern(txs_hex_fix(i),txs_hex_fix(i).TransmitterFrequency,'Size',8,'Map',evalin('base', 'viewer_hex_fix'));
            end
        end

        ld.Value = 1;
        ld.Message = 'A terminar ...';
        pause(1);
        close(ld);
    end

%% VIEW LOCATIONS OF TX AND RX
    function cb0(~,~)
        ld = uiprogressdlg(f1,'Title','Localização das estações-base e recetores','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
        if evalin('base', 'exist(''viewer0'',''var'')')
            evalin('base', 'close(viewer0)');
        end

        assignin('base','viewer0', ...
            siteviewer("Name","Simulador de Rede 5G Urbana - Localizações", ...
            "Position"            ,[0 0 1920 1050],          ...
            "Basemap"             ,"openstreetmap",          ...
            "Terrain"             ,"gmted2010",              ...
            "Buildings"           ,building_map)             ...
            );

        ld.Value = .25;
        ld.Message = 'A apresentar macrocells ...';
        show(txs_macro,'Animation','none','Map',evalin('base', 'viewer0'))

        ld.Value = .50;
        ld.Message = 'A apresentar small cells ...';
        show(txs_small,'Animation','none','Map',evalin('base', 'viewer0'))
        show(txs_post,'Animation','none','Map',evalin('base', 'viewer0'))

        ld.Value = .75;
        ld.Message = 'A apresentar recetores ...';
        show(rxs_macro,'Animation','none','Map',evalin('base', 'viewer0'))
        show(rxs_small,'Animation','none','Map',evalin('base', 'viewer0'))

        ld.Value = 1;
        ld.Message = 'A terminar ...';
        pause(1);
        close(ld);
    end



%% COVERAGE MACROCELLS
    function cb_macro(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb_macro_OK == 1
            cb_macro_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if evalin('base', 'planMode') == '0'        % INICIAL
                txs = txs_macro;
            elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                txs = txs_hex_fix;
            end
            freq_OK    = checkFreq(txs,evalin('base', 'propModel'));

            if (freq_OK == 1) && (pm_OK == 1)
                ld = uiprogressdlg(f1,'Title','Mapa de Cobertura - Macrocells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
                if evalin('base', 'exist(''viewer_macro'',''var'')')
                    evalin('base', 'close(viewer_macro)');
                end

                % Cobertura
                assignin('base','viewer_macro', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de Cobertura Macrocells", ...
                    "Position"            ,[0 0 1920 1050],          ...
                    "Basemap"             ,"openstreetmap",          ...
                    "Terrain"             ,"gmted2010",              ...
                    "Buildings"           ,building_map)             ...
                    );

                ld.Value = .25;
                ld.Message = 'A apresentar macrocells e padrões de antena no mapa ...';
                show(txs,'Animation','none','Map',evalin('base', 'viewer_macro'));
                if evalin('base', 'genMode') == '0'
                    for i = 1:1:length(txs) % show macrocells and patterns
                        pattern(txs(i),txs(i).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer_macro'));
                    end
                end

                ld.Value = .50;
                ld.Message = 'A apresentar recetores e padrões de antena no mapa ...';
                show(rxs_macro,'Animation','none','Map',evalin('base', 'viewer_macro'));
                if evalin('base', 'genMode') == '0'
                    for i = 1:1:length(rxs_macro) % show receivers and patterns
                        pattern(rxs_macro(i),txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer_macro'));
                    end
                end

                ld.Value = .75;
                if evalin('base', 'simMode') == '0'        % RUN

                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")

                        ld.Message = 'A adquirir a grelha de latitudes e longitudes em redor das macrocells ...';
                        SRx = rxs_macro(1).ReceiverSensitivity; % dBm
                        centerSite = txsite("Name","Center Site","Latitude",39.74452, "Longitude",-8.80805);
                        [table_temp,rx_test,~,LOC] = locMatrix(txs(1).TransmitterFrequency,centerSite,SRx);
                        table_cell  = {table_temp};
                        assignin("base","LOC",LOC);

                        ld.Message = 'A calcular a distância entre cada macrocell e os recetores de teste ...';
                        dist_testSites = zeros( length(txs),length(rx_test) );      % Pré-alocação de memória
                        test_macro = txs';
                        test_recv  = rx_test';
                        for i = 1:1:length(txs)
                            dist_testSites(i,:) = distance( test_macro(i,1), test_recv(:,1) );
                        end
                        
                        ld.Message = 'A calcular os ganhos nos pontos envolventes às macrocells ...';
                        [az,el] = angle(txs, rx_test);
                        Gtx = zeros(size(az,1),size(az,2));
                        for i = 1:1:length(txs)
                            Gtx(:,i) = gain(txs(i), txs(i).TransmitterFrequency,az(:,i),el(:,i));
                        end
                        Gtx = Gtx + (-1 * 0.2 * Gtx);   % Corretor de ganho
                        assignin('base','Gtx',Gtx);

                        ld.Message = 'A calcular a perdas de percurso os pontos envolventes às macrocells ...';
                        if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                            pl_logdist = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_logdist(i,k) = m_logdist(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n);
                                end
                            end
                            
                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_logdist(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                            sigma = evalin('base', 'propModel_LogNormal_Variance');
                            pl_lognorm = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_lognorm(i,k) = m_lognorm(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n,sigma);
                                end
                            end
                            
                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_lognorm(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "hata")
                            areaType = evalin('base', 'propModel_Hata_AreaType');
                            pl_hata = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_hata(i,k) = m_hata(txs(i).TransmitterFrequency,dist_testSites(i,k),txs(i).AntennaHeight,rx_test(k).AntennaHeight,areaType);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - pl_hata(i,k); % Budget Link
                                end
                            end
                        end
                        PRx_W = 10 .^ ((PRx - 30) / 10);

                        ld.Message = 'A calcular o melhor nível de potência para cada localização ...';
                        f_PRx = zeros( 1,length(rx_test) );
                        for k = 1:1:length(rx_test)
                            for i = 1:1:length(txs)
                                f_PRx(1,k) = sum( PRx_W(:,k) );
                            end
                        end
                        f_PRx = 10*log10(f_PRx/1e-3);
                        f_PRx = f_PRx';
                        assignin("base","f_PRx",f_PRx);

                        ld.Message = 'A agregar todos os dados numa tabela única ...';

                        ts = table( table_cell{1,1}.Latitude,table_cell{1,1}.Longitude,f_PRx(:,1) );
                        assignin("base","ts",ts);
                        count = 1;
                        f_ts = table(0,0,0);
                        for i = 1:1:height(ts)
%                             if ts(:,3).Var3(i) >= SRx
                                f_ts(count,:) = ts(i,:);
                                count = count + 1;
%                             end
                        end
                        f_ts(1,:) = [];
                        f_table_cell = {f_ts};
                        f_table_cell{1,1}.Properties.VariableNames = {'Latitude','Longitude','Power'};

                        assignin("base","f_table_cell",f_table_cell);
                        coverageData = propagationData(f_table_cell{1,1});

                    else
                        ld.Message = 'A calcular cobertura das macrocells ...';
                        coverageData = coverage(txs,'PropagationModel',pm,"SignalStrengths",rxs_macro(1).ReceiverSensitivity:10:-5,'Transparency',0.5); % display coverage
                        kmlData = coverage(txs,'PropagationModel',pm,"SignalStrengths",-200:10:200,'Transparency',0.5); % display coverage
                    end

                    filename = path2 + "files/macro/coverage/" + evalin('base', 'planString') + "_"  + evalin('base', 'propModel') + "_coverage_macro_" + date + ".mat";   % guarda dados em .mat
                    save(convertStringsToChars(filename),'coverageData');
                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                        file     = "kml\macro\coverage\" + evalin('base', 'propModel') + "_coverage_macro_" + date;
                        M_data_power = reshape(f_PRx,round(sqrt( length(evalin('base', 'f_PRx')) )),[]);
                        createKML(path, convertStringsToChars(file),M_data_power,"Mapa de Cobertura Macrocells","POWER",LOC,txs,rxs_macro);
                    else
                        %M_data_power = reshape(kmlData.Data.Power,round(sqrt( length(kmlData.Data.Power) )),[]);
                    end


                    pd = propagationData(coverageData.Data);
                elseif evalin('base', 'simMode') == '1'    % LOAD
                    ld.Message = 'A ler ficheiro de cobertura das macrocells ...';
                    fileData = load(convertStringsToChars(file_coverage_macro),'coverageData');

                    pd = propagationData(fileData.coverageData.Data);
                end

                legendTitle = "Power" + newline + "(dBm)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",rxs_macro(1).ReceiverSensitivity:1:-5,"ColorLimits",[rxs_macro(1).ReceiverSensitivity -5],"Transparency",0.5,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_macro'));

                ld.Value = 1;
                ld.Message = 'A terminar ...';
                pause(1);
                close(ld);

            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as macrocells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb_macro_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb_macro_OK = 1;
    end



%% COVERAGE SMALL CELLS
    function cb_small(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb_small_OK == 1
            cb_small_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if evalin('base', 'planMode') == '0'        % INICIAL
                txs = txs_small;
            elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                txs = txs_small_opt;
            end
            freq_OK = checkFreq(txs,evalin('base', 'propModel'));

            if (freq_OK == 1) && (pm_OK == 1)
                ld = uiprogressdlg(f1,'Title','Mapa de Cobertura - Small Cells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
                if evalin('base', 'exist(''viewer_small'',''var'')')
                    evalin('base', 'close(viewer_small)');
                end

                % Cobertura
                assignin('base','viewer_small', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de Cobertura Small Cells", ...
                    "Position"            ,[0 0 1920 1050],          ...
                    "Basemap"             ,"openstreetmap",          ...
                    "Terrain"             ,"gmted2010",              ...
                    "Buildings"           ,building_map)             ...
                    );
                ld.Value = .25;
                ld.Message = 'A apresentar small cells e padrões de antena no mapa ...';

                % SMALL CELLS
                show(txs,'Animation','none','Map',evalin('base', 'viewer_small'));
                for i = 1:length(txs) % show small cells and patterns
                    [az,el] = angle(txs(i), rxs_small);
                    txs(i).AntennaAngle = [az,el];
                    if evalin('base', 'genMode') == '0'
                        pattern(txs(i),txs(i).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer_small'))
                    end
                end

                ld.Value = .50;
                ld.Message = 'A apresentar recetores e padrões de antena no mapa ...';
                show(rxs_small,'Animation','none','Map',evalin('base', 'viewer_small'));
                if evalin('base', 'genMode') == '0'
                    pattern(rxs_small,txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer_small'))
                end

                ld.Value = .75;
                if evalin('base', 'simMode') == '0'        % RUN

                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")

                        ld.Message = 'A adquirir a grelha de latitudes e longitudes em redor das small cells ...';
                        SRx = rxs_small(1).ReceiverSensitivity; % dBm
                        centerSite = txsite("Name","Center Site","Latitude",39.74452, "Longitude",-8.80805);
                        [table_temp,rx_test,~,LOC] = locMatrix(txs(1).TransmitterFrequency,centerSite,SRx);
                        table_cell  = {table_temp};
                        assignin("base","LOC",LOC);

                        ld.Message = 'A calcular a distância entre cada small cell e os recetores de teste ...';
                        dist_testSites = zeros( length(txs),length(rx_test) );      % Pré-alocação de memória
                        test_small = txs';
                        test_recv  = rx_test';
                        for i = 1:1:length(txs)
                            dist_testSites(i,:) = distance( test_small(i,1), test_recv(:,1) );
                        end
                            
                        ld.Message = 'A calcular os ganhos nos pontos envolventes às small cells ...';
                        [az,el] = angle(txs, rx_test);
                        Gtx = zeros(size(az,1),size(az,2));
                        for i = 1:1:length(txs)
                            Gtx(:,i) = gain(txs(i), txs(i).TransmitterFrequency,az(:,i),el(:,i));
                        end
                        Gtx = Gtx + (-1 * 0.2 * Gtx);   % Corretor de ganho
                        assignin('base','Gtx',Gtx);

                        ld.Message = 'A calcular a perdas de percurso nos pontos envolventes às small cells ...';
                        if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                            pl_logdist = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_logdist(i,k) = m_logdist(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_logdist(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                            sigma = evalin('base', 'propModel_LogNormal_Variance');
                            pl_lognorm = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_lognorm(i,k) = m_lognorm(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n,sigma);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_lognorm(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "hata")
                            areaType = evalin('base', 'propModel_Hata_AreaType');
                            pl_hata = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_hata(i,k) = m_hata(txs(i).TransmitterFrequency,dist_testSites(i,k),txs(i).AntennaHeight,rx_test(k).AntennaHeight,areaType);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - pl_hata(i,k); % Budget Link
                                end
                            end
                        end
                        PRx_W = 10 .^ ((PRx - 30) / 10);

                        ld.Message = 'A calcular o melhor nível de potência para cada localização ...';
                        f_PRx = zeros( 1,length(rx_test) );
                        for k = 1:1:length(rx_test)
                            for i = 1:1:length(txs)
                                f_PRx(1,k) = sum( PRx_W(:,k) );
                            end
                        end
                        f_PRx = 10*log10(f_PRx/1e-3);
                        f_PRx = f_PRx';
                        assignin("base","f_PRx",f_PRx);

                        ld.Message = 'A agregar todos os dados numa tabela única ...';
                        ts = table( table_cell{1,1}.Latitude,table_cell{1,1}.Longitude,f_PRx(:,1) );
                        count = 1;
                        f_ts = table(0,0,0);
                        for i = 1:1:height(ts)
                            % if ts(:,3).Var3(i) >= SRx
                                f_ts(count,:) = ts(i,:);
                                count = count + 1;
                            % end
                        end
                        f_ts(1,:) = [];
                        f_table_cell = {f_ts};
                        f_table_cell{1,1}.Properties.VariableNames = {'Latitude','Longitude','Power'};

                        coverageData = propagationData(f_table_cell{1,1});
                    else
                        ld.Message = 'A calcular cobertura das small cells ...';
                        coverageData = coverage(txs,'PropagationModel',pm,"SignalStrengths",rxs_small(1).ReceiverSensitivity:10:-5,'Transparency',0.5); % display coverage
                        kmlData = coverage(txs,'PropagationModel',pm,"SignalStrengths",-200:10:200,'Transparency',0.5); % display coverage
                    end

                    filename = path2 + "files/small/coverage/" + evalin('base', 'planString') + "_"  + evalin('base', 'propModel') + "_coverage_small_" + date + ".mat";
                    save(convertStringsToChars(filename),'coverageData');
                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                        file     = "kml\small\coverage\" + evalin('base', 'propModel') + "_coverage_small_" + date;
                        M_data_power = reshape(f_PRx,round(sqrt( length(evalin('base', 'f_PRx')) )),[]);
                        createKML(path, convertStringsToChars(file),M_data_power,"Mapa de Cobertura Small Cells","POWER",LOC,txs,rxs_small);
                    else
                        %M_data_power = reshape(kmlData.Data.Power,round(sqrt( length(kmlData.Data.Power) )),[]);
                    end


                    pd = propagationData(coverageData.Data);
                elseif evalin('base', 'simMode') == '1'    % LOAD
                    ld.Message = 'A ler ficheiro de cobertura das small cells ...';
                    fileData = load(convertStringsToChars(file_coverage_small),'coverageData');

                    pd = propagationData(fileData.coverageData.Data);
                end

                legendTitle = "Power" + newline + "(dBm)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",rxs_small(1).ReceiverSensitivity:1:-5,"ColorLimits",[rxs_small(1).ReceiverSensitivity -5],"Transparency",0.5,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_small'));

                ld.Value = 1;
                ld.Message = 'A terminar ...';
                pause(1);
                close(ld);

            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as small cells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb_small_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb_small_OK = 1;
    end



%% LOS, REFLECTIONS AND BUDGET-LINK MACROCELLS
    function cb_f1a(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb_f1a_OK == 1
            cb_f1a_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if evalin('base', 'planMode') == '0'        % INICIAL
                txs = txs_macro;
            elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                txs = txs_hex_fix;
            end
            freq_OK    = checkFreq(txs,evalin('base', 'propModel'));

            if (freq_OK == 1) && (pm_OK == 1)
                ld = uiprogressdlg(f1,'Title','Mapa de LoS e Budget-Link - Macrocells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
                if evalin('base', 'exist(''viewer_los_macro'',''var'')')
                    evalin('base', 'close(viewer_los_macro)');
                end

                % LoS e Budget-Link
                assignin('base','viewer_los_macro', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de LoS e Budget-Link Macrocells", ...
                    "Position"            ,[0 0 1920 1050],          ...
                    "Basemap"             ,"openstreetmap",          ...
                    "Terrain"             ,"gmted2010",              ...
                    "Buildings"           ,building_map)             ...
                    );
                ld.Value = .25;
                ld.Message = 'A apresentar macrocells e padrões de antena no mapa ...';
                show(txs,'Animation','none','Map',evalin('base', 'viewer_los_macro'));
                if evalin('base', 'genMode') == '0'
                    for i = 1:1:length(txs) % show macrocells and patterns
                        pattern(txs(i),txs(i).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer_los_macro'))
                    end
                end

                ld.Value = .50;
                ld.Message = 'A apresentar recetores e padrões de antena no mapa ...';
                show(rxs_macro,'Animation','none','Map',evalin('base', 'viewer_los_macro'));
                if evalin('base', 'genMode') == '0'
                    for i = 1:1:length(rxs_macro) % show receivers and patterns
                        pattern(rxs_macro(i),txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer_los_macro'))
                    end
                end

                ld.Value = .75;
                ld.Message = 'A calcular linhas de vista e link budget ...';
                for i = 1:1:length(txs) % display LoS and link budget
                    for k = 1:length(rxs_macro)
                        los(txs(i),rxs_macro(k),'Animation','none','Map',evalin('base', 'viewer_los_macro'));
                        link(rxs_macro(k),txs(i),'PropagationModel',pm,"SuccessColor",'blue',"FailColor",'black','Animation','none','Map',evalin('base', 'viewer_los_macro'));
                        if strcmpi(evalin('base', 'propModel'),'raytracing')
                            raytrace(txs(i),rxs_macro(k),pm,'Animation','none','Map',evalin('base', 'viewer_los_macro'));
                        end
                    end
                end

                ld.Value = 1;
                ld.Message = 'A terminar cálculos ...';
                pause(1);
                close(ld);

            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as macrocells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb_f1a_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb_f1a_OK = 1;
    end



%% SINR MACROCELLS
    function cb2(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb2_OK == 1
            cb2_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if evalin('base', 'planMode') == '0'        % INICIAL
                txs = txs_macro;
            elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                txs = txs_hex_fix;
            end
            freq_OK_macro = checkFreq(txs,evalin('base', 'propModel'));

            if (freq_OK_macro == 1) && (pm_OK == 1)
                ld = uiprogressdlg(f1,'Title','Mapa de SINR - Macrocells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');

                if evalin('base', 'exist(''viewer2'',''var'')')
                    evalin('base', 'close(viewer2)');
                end

                % SINR
                assignin('base','viewer2', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de SINR Macrocells", ...
                    "Position"            ,[0 0 1920 1050],        ...
                    "Basemap"             ,"openstreetmap",        ...
                    "Terrain"             ,"gmted2010",            ...
                    "Buildings"           ,building_map)           ...
                    );
                ld.Value = .25;
                ld.Message = 'A apresentar macrocells e padrões de antena no mapa ...';
                show(txs,'Animation','none','Map',evalin('base', 'viewer2'));
                if evalin('base', 'genMode') == '0'
                    for i = 1:length(txs) % show macrocells and patterns
                        pattern(txs(i),txs(i).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer2'))
                    end
                end

                ld.Value = .50;
                ld.Message = 'A apresentar recetores e padrões de antena no mapa ...';
                show(rxs_macro,'Animation','none','Map',evalin('base', 'viewer2'));
                if evalin('base', 'genMode') == '0'
                    for i = 1:length(rxs_macro) % show receivers and patterns
                        pattern(rxs_macro(i),rxs_macro(i).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer2'))
                    end
                end

                ld.Value = .75;
                if evalin('base', 'simMode') == '0'        % RUN
                    ld.Message = 'A calcular SINR das macrocells ...';

                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")

                        ld.Message = 'A adquirir a grelha de latitudes e longitudes em redor das macrocells ...';
                        SRx = rxs_macro(1).ReceiverSensitivity; % dBm
                        centerSite = txsite("Name","Center Site","Latitude",39.74452, "Longitude",-8.80805);
                        [table_temp,rx_test,~,LOC] = locMatrix(txs(1).TransmitterFrequency,centerSite,SRx);
                        table_cell  = {table_temp};
                        assignin("base","LOC",LOC);

                        ld.Message = 'A calcular a distância entre cada macrocell e os recetores de teste ...';
                        dist_testSites = zeros( length(txs),length(rx_test) );      % Pré-alocação de memória
                        test_macro = txs';
                        test_recv  = rx_test';
                        for i = 1:1:length(txs)
                            dist_testSites(i,:) = distance( test_macro(i,1), test_recv(:,1) );
                        end
                        
                        ld.Message = 'A calcular os ganhos nos pontos envolventes às macrocells ...';
                        [az,el] = angle(txs, rx_test);
                        Gtx = zeros(size(az,1),size(az,2));
                        for i = 1:1:length(txs)
                            Gtx(:,i) = gain(txs(i), txs(i).TransmitterFrequency,az(:,i),el(:,i));
                        end
                        Gtx = Gtx + (-1 * 0.2 * Gtx);   % Corretor de ganho
                        assignin('base','Gtx',Gtx);

                        ld.Message = 'A calcular a perdas de percurso os pontos envolventes às macrocells ...';
                        if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                            pl_logdist = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_logdist(i,k) = m_logdist(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_logdist(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                            sigma = evalin('base', 'propModel_LogNormal_Variance');
                            pl_lognorm = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_lognorm(i,k) = m_lognorm(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n,sigma);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_lognorm(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "hata")
                            areaType = evalin('base', 'propModel_Hata_AreaType');
                            pl_hata = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_hata(i,k) = m_hata(txs(i).TransmitterFrequency,dist_testSites(i,k),txs(i).AntennaHeight,rx_test(k).AntennaHeight,areaType);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - pl_hata(i,k); % Budget Link
                                end
                            end
                        end
                        PRx_W = 10 .^ ((PRx - 30) / 10);

                        ld.Message = 'A calcular os níveis de SINR as para cada localização ...';
                        sum_interf_W = zeros( length(txs),length(rx_test) );
                        for k = 1:1:length(rx_test)
                            for i = 1:1:length(txs)
                                sum_interf_W(i,k) = sum( PRx_W(:,k) ) - PRx_W(i,k);   % Soma das interferências [W]
                            end
                        end
                        noise_W = 10 ^ ((-107 - 30) / 10);          % Noise [W]
                        SINR = PRx_W ./ (sum_interf_W + noise_W);
                        SINR_DB = 10 * log10(SINR / 1e-3);
                        assignin("base","SINR_DB",SINR_DB);
                        SINR_DB_mean = zeros(1,length(SINR_DB));
                        for i = 1:1:length(SINR_DB)
                            SINR_DB_mean(i) = mean2(SINR_DB(:,i));
                        end
                        SINR_DB_mean = SINR_DB_mean' .* -1;
                        assignin("base","SINR_DB_mean",SINR_DB_mean);

                        ld.Message = 'A agregar todos os dados numa tabela única ...';
                        ts = table( table_cell{1,1}.Latitude,table_cell{1,1}.Longitude,SINR_DB_mean(:,1) );
                        count = 1;
                        f_ts = table(0,0,0);
                        for i = 1:1:height(ts)
                           % if ts(:,3).Var3(i) >= -5
                                f_ts(count,:) = ts(i,:);
                                count = count + 1;
                           % end
                        end
                        f_ts(1,:) = [];
                        f_table_cell = {f_ts};
                        f_table_cell{1,1}.Properties.VariableNames = {'Latitude','Longitude','SINR'};

                        sinrData = propagationData(f_table_cell{1,1});
                    else
                        PD = sinr(txs,pm,"MaxRange",5000,'Transparency',0.5);
                        sinrData = PD;
                        kmlData = sinr(txs,pm,"MaxRange",5000,'Transparency',0.5);
                    end

                    filename = path2 + "files/macro/sinr/" + evalin('base', 'planString') + "_" + evalin('base', 'propModel') + "_sinr_macro_" + date + ".mat";
                    save(convertStringsToChars(filename),'sinrData');
                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                        file     = "kml\macro\sinr\" + evalin('base', 'propModel') + "_sinr_macro_" + date;
                        M_data_power = reshape(SINR_DB_mean,round(sqrt( length(evalin('base', 'SINR_DB_mean')) )),[]);
                        createKML(path, convertStringsToChars(file),M_data_power,"Mapa de SINR Macrocells","SINR",LOC,txs,rxs_macro);
                    else
                        %M_data_power = reshape(kmlData.Data.SINR,round(sqrt( length(kmlData.Data.SINR) )),[]);
                    end

                    pd = propagationData(sinrData.Data);
                elseif evalin('base', 'simMode') == '1'    % LOAD
                    ld.Message = 'A ler ficheiro de SINR das macrocells ...';
                    fileData = load(convertStringsToChars(file_sinr_macro),'sinrData');

                    pd = propagationData(fileData.sinrData.Data);
                end

                legendTitle = "SINR" + newline + "(dB)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",-5:1:20,"ColorLimits",[-5 20],'ValidateColorConflicts',false,'Map',evalin('base', 'viewer2'));

                ld.Value = 1;
                ld.Message = 'A terminar ...';
                pause(1);
                close(ld);

            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as estações-base está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb2_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb2_OK = 1;
    end


%% SINR SMALL CELLS
    function cb2_small(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb2_OK == 1
            cb2_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if evalin('base', 'planMode') == '0'        % INICIAL
                txs = txs_small;
            elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                txs = txs_small_opt;
            end
            freq_OK_small = checkFreq(txs,evalin('base', 'propModel'));

            if (freq_OK_small == 1) && (pm_OK == 1)
                ld = uiprogressdlg(f1,'Title','Mapa de SINR - Small Cells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');

                if evalin('base', 'exist(''viewer2_small'',''var'')')
                    evalin('base', 'close(viewer2_small)');
                end

                % SINR
                assignin('base','viewer2_small', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de SINR Small Cells", ...
                    "Position"            ,[0 0 1920 1050],        ...
                    "Basemap"             ,"openstreetmap",        ...
                    "Terrain"             ,"gmted2010",            ...
                    "Buildings"           ,building_map)           ...
                    );
                ld.Value = .25;
                ld.Message = 'A apresentar small cells e padrões de antena no mapa ...';
                show(txs,'Animation','none','Map',evalin('base', 'viewer2_small'));
                if evalin('base', 'genMode') == '0'
                    for i = 1:1:length(txs) % show small cells and patterns
                        [az,el] = angle(txs(i), rxs_small);
                        txs(i).AntennaAngle = [az,el];
                        pattern(txs(i),txs(i).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer2_small'))
                    end
                end

                ld.Value = .50;
                ld.Message = 'A apresentar recetores e padrões de antena no mapa ...';
                show(rxs_small,'Animation','none','Map',evalin('base', 'viewer2_small'));
                if evalin('base', 'genMode') == '0'
                    pattern(rxs_small,txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer2_small'))
                end

                ld.Value = .75;
                if evalin('base', 'simMode') == '0'        % RUN
                    ld.Message = 'A calcular SINR das small cells ...';

                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")

                        ld.Message = 'A adquirir a grelha de latitudes e longitudes em redor das small cells ...';
                        SRx = rxs_small(1).ReceiverSensitivity; % dBm
                        centerSite = txsite("Name","Center Site","Latitude",39.74452, "Longitude",-8.80805);
                        [table_temp,rx_test,~,LOC] = locMatrix(txs(1).TransmitterFrequency,centerSite,SRx);
                        table_cell  = {table_temp};
                        assignin("base","LOC",LOC);

                        ld.Message = 'A calcular a distância entre cada small cell e os recetores de teste ...';
                        dist_testSites = zeros( length(txs),length(rx_test) );      % Pré-alocação de memória
                        test_macro = txs';
                        test_recv  = rx_test';
                        for i = 1:1:length(txs)
                            dist_testSites(i,:) = distance( test_macro(i,1), test_recv(:,1) );
                        end

                        ld.Message = 'A calcular os ganhos nos pontos envolventes às small cells ...';
                        [az,el] = angle(txs, rx_test);
                        Gtx = zeros(size(az,1),size(az,2));
                        for i = 1:1:length(txs)
                            Gtx(:,i) = gain(txs(i), txs(i).TransmitterFrequency,az(:,i),el(:,i));
                        end
                        Gtx = Gtx + (-1 * 0.2 * Gtx);   % Corretor de ganho
                        assignin('base','Gtx',Gtx);

                        ld.Message = 'A calcular a perdas de percurso os pontos envolventes às small cells ...';
                        if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                            pl_logdist = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_logdist(i,k) = m_logdist(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_logdist(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                            sigma = evalin('base', 'propModel_LogNormal_Variance');
                            pl_lognorm = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_lognorm(i,k) = m_lognorm(txs(i).TransmitterFrequency,dist_testSites(i,k),d0,n,sigma);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist_testSites(i,k)) - pl_lognorm(i,k); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "hata")
                            areaType = evalin('base', 'propModel_Hata_AreaType');
                            pl_hata = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    pl_hata(i,k) = m_hata(txs(i).TransmitterFrequency,dist_testSites(i,k),txs(i).AntennaHeight,rx_test(k).AntennaHeight,areaType);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            PRx = zeros(length(txs),length(rx_test));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rx_test)
                                    PRx(i,k) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - pl_hata(i,k); % Budget Link
                                end
                            end
                        end
                        PRx_W = 10 .^ ((PRx - 30) / 10);

                        ld.Message = 'A calcular os níveis de SINR as para cada localização ...';
                        sum_interf_W = zeros( length(txs),length(rx_test) );
                        for k = 1:1:length(rx_test)
                            for i = 1:1:length(txs)
                                sum_interf_W(i,k) = sum( PRx_W(:,k) ) - PRx_W(i,k);   % Soma das interferências [W]
                            end
                        end
                        noise_W = 10 ^ ((-107 - 30) / 10);          % Noise [W]
                        SINR = PRx_W ./ (sum_interf_W + noise_W);
                        SINR_DB = 10 * log10(SINR / 1e-3);
                        assignin("base","SINR_DB",SINR_DB);
                        SINR_DB_mean = zeros(1,length(SINR_DB));
                        for i = 1:1:length(SINR_DB)
                            SINR_DB_mean(i) = mean2(SINR_DB(:,i));
                        end
                        SINR_DB_mean = SINR_DB_mean' .* 1;
                        assignin("base","SINR_DB_mean",SINR_DB_mean);

                        ld.Message = 'A agregar todos os dados numa tabela única ...';
                        ts = table( table_cell{1,1}.Latitude,table_cell{1,1}.Longitude,SINR_DB_mean(:,1) );
                        count = 1;
                        f_ts = table(0,0,0);
                        for i = 1:1:height(ts)
                           % if ts(:,3).Var3(i) >= -5
                                f_ts(count,:) = ts(i,:);
                                count = count + 1;
                           % end
                        end
                        f_ts(1,:) = [];
                        f_table_cell = {f_ts};
                        f_table_cell{1,1}.Properties.VariableNames = {'Latitude','Longitude','SINR'};

                        sinrData = propagationData(f_table_cell{1,1});
                    else
                        PD = sinr(txs,pm,"MaxRange",5000,'Transparency',0.5);
                        sinrData = PD;
                        kmlData = sinr(txs,pm,"MaxRange",5000,'Transparency',0.5);
                    end

                    filename = path2 + "files/small/sinr/" + evalin('base', 'planString') + "_" + evalin('base', 'propModel') + "_sinr_small_" + date + ".mat";
                    save(convertStringsToChars(filename),'sinrData');
                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                        file     = "kml\small\sinr\" + evalin('base', 'propModel') + "_sinr_small_" + date;
                        M_data_power = reshape(SINR_DB_mean,round(sqrt( length(evalin('base', 'SINR_DB_mean')) )),[]);
                        createKML(path, convertStringsToChars(file),M_data_power,"Mapa de SINR Small Cells","SINR",LOC,txs,rxs_small);
                    else
                        %M_data_power = reshape(kmlData.Data.SINR,round(sqrt( length(kmlData.Data.SINR) )),[]);
                    end

                    pd = propagationData(sinrData.Data);
                elseif evalin('base', 'simMode') == '1'    % LOAD
                    ld.Message = 'A ler ficheiro de SINR das small cells ...';
                    fileData = load(convertStringsToChars(file_sinr_small),'sinrData');

                    pd = propagationData(fileData.sinrData.Data);
                end

                legendTitle = "SINR" + newline + "(dB)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",-5:1:20,"ColorLimits",[-5 20],'ValidateColorConflicts',false,'Map',evalin('base', 'viewer2_small'));

                ld.Value = 1;
                ld.Message = 'A terminar ...';
                pause(1);
                close(ld);

            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as estações-base está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb2_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb2_OK = 1;
    end


%% BEST SERVER - MACROCELLS
    function cb3(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb3_OK == 1
            cb3_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if evalin('base', 'planMode') == '0'        % INICIAL
                txs = txs_macro;
            elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                txs = txs_hex_fix;
            end
            freq_OK    = checkFreq(txs,evalin('base', 'propModel'));

            if (freq_OK == 1) && (pm_OK == 1)
                ld = uiprogressdlg(f1,'Title','Mapa de Best-servers - Macrocells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');

                if evalin('base', 'exist(''viewer3'',''var'')')
                    evalin('base', 'close(viewer3)');
                end

                % Best server
                assignin('base','viewer3', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de Best-servers Macrocells", ...
                    "Position"            ,[0 0 1920 1050],          ...
                    "Basemap"             ,"openstreetmap",          ...
                    "Terrain"             ,"gmted2010",              ...
                    "Buildings"           ,building_map)             ...
                    );

                if evalin('base', 'simMode') == '0'        % RUN
                    ld.Value = .25;
                    ld.Message = 'A calcular vetores de potência e distância para cada recetor ...';

                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                        dist = zeros(length(rxs_macro),length(txs));
                        for i = 1:length(rxs_macro)
                            for k = 1:length(txs)
                                dist(i,k)  = distance(txs(k),rxs_macro(i));
                            end
                        end

                        ld.Message = 'A calcular os ganhos nos pontos envolventes às macrocells ...';
                        [az,el] = angle(txs, rxs_macro);
                        Gtx = zeros(size(az,1),size(az,2));
                        for i = 1:1:length(txs)
                            Gtx(:,i) = gain(txs(i), txs(i).TransmitterFrequency,az(:,i),el(:,i));
                        end
                        Gtx = Gtx + (-1 * 0.2 * Gtx);   % Corretor de ganho

                        ld.Message = 'A calcular a perdas de percurso os pontos envolventes às macrocells ...';
                        if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                            pl_logdist = zeros(length(rxs_macro),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_macro)
                                    pl_logdist(k,i) = m_logdist(txs(i).TransmitterFrequency,dist(k,i),d0,n);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            ss = zeros(length(rxs_macro),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_macro)
                                    ss(k,i) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist(k,i)) - pl_logdist(k,i); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                            sigma = evalin('base', 'propModel_LogNormal_Variance');
                            pl_lognorm = zeros(length(rxs_macro),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_macro)
                                    pl_lognorm(k,i) = m_lognorm(txs(i).TransmitterFrequency,dist(k,i),d0,n,sigma);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            ss = zeros(length(rxs_macro),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_macro)
                                    ss(k,i) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist(k,i)) - pl_lognorm(k,i); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "hata")
                            areaType = evalin('base', 'propModel_Hata_AreaType');
                            pl_hata = zeros(length(rxs_macro),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_macro)
                                    pl_hata(k,i) = m_hata(txs(i).TransmitterFrequency,dist(k,i),txs(i).AntennaHeight,rxs_macro(k).AntennaHeight,areaType);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às macrocells ...';
                            ss = zeros(length(rxs_macro),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_macro)
                                    ss(k,i) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - pl_hata(k,i); % Budget Link
                                end
                            end
                        end

                        ld.Value = .50;
                        ld.Message = 'A determinar vetores de posição e distância de possíveis best-servers para cada recetor ...';

                        counter = ones(length(rxs_macro));
                        for i = 1:length(rxs_macro) % mostra macrocell best server para cada RX
                            for k = 1:length(txs)
                                if  ss(i,k) == max(ss(i,:))
                                    tx_pos(i,counter(i))   = k;             % guarda posição das células das torres best server
                                    new_dist(i,counter(i)) = dist(i,k);     % para as potências mais altas de RX e de valor igual, guardar distância
                                    new_ss(i,counter(i)) = ss(i,k);
                                    counter(i) = counter(i) + 1;
                                end
                            end
                        end

                        ld.Value = .75;
                        ld.Message = 'A calcular best-server para cada recetor através dos vetores anteriores ...';

                        for i = 1:length(rxs_macro) % mostra macrocell best server para cada RX
                            for j = 1:length(tx_pos)
                                if  ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) == 1)  || ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) > 1 && new_dist(i) == min( dist(i,:) ) )
                                    show( txs(tx_pos(i)),'Animation','none','Map',evalin('base', 'viewer3'));
                                    if evalin('base', 'genMode') == '0'
                                        pattern(txs(tx_pos(i)),txs(tx_pos(i)).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer3'))
                                    end
                                    show(rxs_macro(i),'Animation','none','Map',evalin('base', 'viewer3'));
                                    if evalin('base', 'genMode') == '0'
                                        pattern(rxs_macro(i),txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer3'))
                                    end
                                    los(txs(tx_pos(i)),rxs_macro(i),'Animation','none','Map',evalin('base', 'viewer3'));

                                    bs_tx(i) = txs(tx_pos(i));
                                    bs_rx(i) = rxs_macro(i);
                                end
                            end
                        end
                        assignin('base',"bs_tx",bs_tx);
                        assignin('base',"bs_rx",bs_rx);

                    else
                        ss = zeros(length(rxs_macro),length(txs));
                        dist = zeros(length(rxs_macro),length(txs));
                        for i = 1:length(rxs_macro)
                            for k = 1:length(txs)
                                ss(i,k)   = sigstrength(rxs_macro(i),txs(k),pm);    % calcula potência recebida nos RX
                                dist(i,k) = distance(txs(k),rxs_macro(i));
                            end
                        end

                        ld.Value = .50;
                        ld.Message = 'A determinar vetores de posição e distância de possíveis best-servers para cada recetor ...';
                        counter = ones(length(rxs_macro));
                        for i = 1:length(rxs_macro) % mostra macrocell best server para cada RX
                            for k = 1:length(txs)
                                if  sigstrength(rxs_macro(i),txs(k),pm) == max(ss(i,:))
                                    tx_pos(i,counter(i))   = k;             % guarda posição das células das torres best server
                                    new_dist(i,counter(i)) = dist(i,k);     % para as potências mais altas de RX e de valor igual, guardar distância
                                    new_ss(i,counter(i))   = ss(i,k);
                                    counter(i) = counter(i) + 1;
                                end
                            end
                        end

                        ld.Value = .75;
                        ld.Message = 'A calcular best-server para cada recetor através dos vetores anteriores ...';

                        for i = 1:1:length(rxs_macro) % mostra macrocell best server para cada RX
                            for j = 1:1:length(tx_pos)
                                if  ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) == 1)  || ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) > 1 && new_dist(i) == min( dist(i,:) ) )
                                    show( txs(tx_pos(i)),'Animation','none','Map',evalin('base', 'viewer3') );
                                    if evalin('base', 'genMode') == '0'
                                        pattern(txs(tx_pos(i)),txs(tx_pos(i)).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer3'))
                                    end
                                    show(rxs_macro(i),'Animation','none','Map',evalin('base', 'viewer3'));
                                    if evalin('base', 'genMode') == '0'
                                        pattern(rxs_macro(i),txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer3'))
                                    end
                                    los(txs(tx_pos(i)),rxs_macro(i),'Animation','none','Map',evalin('base', 'viewer3'));
                                    link(rxs_macro(i),txs(tx_pos(i)),pm,"SuccessColor",'blue',"FailColor",'black','Animation','none','Map',evalin('base', 'viewer3'));
                                    if strcmpi(evalin('base', 'propModel'),'raytracing')
                                        raytrace(txs(tx_pos(i)),rxs_macro(i),pm,'Animation','none','Map',evalin('base', 'viewer3'));
                                    end

                                    bs_tx(i) = txs(tx_pos(i));
                                    bs_rx(i) = rxs_macro(i);
                                end
                            end
                        end
                        assignin('base',"bs_tx",bs_tx);
                        assignin('base',"bs_rx",bs_rx);

                    end

                    filename = path2 + "files/macro/bestserver/" + evalin('base', 'planString') + "_"  + evalin('base', 'propModel') + "_bestserver_macro_" + date + ".mat";
                    save(convertStringsToChars(filename),'bs_tx','bs_rx');

                elseif evalin('base', 'simMode') == '1'        % LOAD
                    ld.Value = .50;
                    ld.Message = 'A ler ficheiro de best-servers das macrocells ...';
                    fileData = load(convertStringsToChars(file_bestserver_macro),'bs_tx','bs_rx');

                    show(bs_rx,'Animation','none','Map',evalin('base', 'viewer3'));
                    show(bs_tx,'Animation','none','Map',evalin('base', 'viewer3'));
                    for i = 1:length(bs_rx)
                        if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                            los(bs_tx(i),bs_rx(i),'Animation','none');
                        else
                            los(bs_tx(i),bs_rx(i),'Animation','none','Map',evalin('base', 'viewer3'));
                            link(bs_rx(i),bs_tx(i),pm,"SuccessColor",'blue',"FailColor",'black','Animation','none','Map',evalin('base', 'viewer3'));
                            if strcmpi(evalin('base', 'propModel'),'raytracing')
                                raytrace(bs_tx(i),bs_rx(i),pm,'Animation','none','Map',evalin('base', 'viewer3'));
                            end
                        end
                    end
                end

                ld.Value = 1;
                ld.Message = 'A terminar ...';
                pause(1);
                close(ld);

            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as macrocells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb3_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb3_OK = 1;
    end



%% BEST SERVER - SMALL CELLS
    function cb4(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb4_OK == 1
            cb4_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if evalin('base', 'planMode') == '0'        % INICIAL
                txs = txs_small;
            elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                txs = txs_small_opt;
            end
            freq_OK = checkFreq(txs,evalin('base', 'propModel'));

            if (freq_OK == 1) && (pm_OK == 1)
                ld = uiprogressdlg(f1,'Title','Mapa de Best-servers - Small Cells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');

                if evalin('base', 'exist(''viewer4'',''var'')')
                    evalin('base', 'close(viewer4)');
                end

                % Best server
                assignin('base','viewer4', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de Best-servers Small Cells ", ...
                    "Position"            ,[0 0 1920 1050],          ...
                    "Basemap"             ,"openstreetmap",          ...
                    "Terrain"             ,"gmted2010",              ...
                    "Buildings"           ,building_map)             ...
                    );

                if evalin('base', 'simMode') == '0'        % RUN
                    ld.Value = .25;
                    ld.Message = 'A calcular vetores de potência e distância para cada recetor ...';

                    if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                        for i = 1:length(rxs_small)
                            for k = 1:length(txs)
                                dist(i,k)  = distance(txs(k),rxs_small(i));
                            end
                        end

                        ld.Message = 'A calcular os ganhos nos pontos envolventes às small cells ...';
                        [az,el] = angle(txs, rxs_small);
                        Gtx = zeros(size(az,1),size(az,2));
                        for i = 1:1:length(txs)
                            Gtx(:,i) = gain(txs(i), txs(i).TransmitterFrequency,az(:,i),el(:,i));
                        end
                        Gtx = Gtx + (-1 * 0.2 * Gtx);   % Corretor de ganho

                        ld.Message = 'A calcular a perdas de percurso os pontos envolventes às small cells ...';
                        if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                            pl_logdist = zeros(length(rxs_small),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_small)
                                    pl_logdist(k,i) = m_logdist(txs(i).TransmitterFrequency,dist(k,i),d0,n);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            ss = zeros(length(rxs_small),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_small)
                                    ss(k,i) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist(k,i)) - pl_logdist(k,i); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                            d0 = 100;
                            n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                            sigma = evalin('base', 'propModel_LogNormal_Variance');
                            pl_lognorm = zeros(length(rxs_small),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_small)
                                    pl_lognorm(k,i) = m_lognorm(txs(i).TransmitterFrequency,dist(k,i),d0,n,sigma);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            ss = zeros(length(rxs_small),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_small)
                                    ss(k,i) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - m_free(txs(i).TransmitterFrequency,dist(k,i)) - pl_lognorm(k,i); % Budget Link
                                end
                            end
                        elseif strcmpi(evalin('base', 'propModel'), "hata")
                            areaType = evalin('base', 'propModel_Hata_AreaType');
                            pl_hata = zeros(length(rxs_small),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_small)
                                    pl_hata(k,i) = m_hata(txs(i).TransmitterFrequency,dist(k,i),txs(i).AntennaHeight,rxs_small(k).AntennaHeight,areaType);
                                end
                            end

                            ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                            ss = zeros(length(rxs_small),length(txs));
                            for i = 1:1:length(txs)
                                for k = 1:1:length(rxs_small)
                                    ss(k,i) = 10*log10(txs(i).TransmitterPower/1e-3) + Gtx(k,i) - pl_hata(k,i); % Budget Link
                                end
                            end
                        end

                        ld.Value = .50;
                        ld.Message = 'A determinar vetores de posição e distância de possíveis best-servers para cada recetor ...';

                        counter = ones(length(rxs_small));
                        for i = 1:length(rxs_small) % mostra small cell best server para cada RX
                            for k = 1:length(txs)
                                if  ss(i,k) == max(ss(i,:))
                                    tx_pos(i,counter(i))   = k;             % guarda posição das células das torres best server
                                    new_dist(i,counter(i)) = dist(i,k);     % para as potências mais altas de RX e de valor igual, guardar distância
                                    new_ss(i,counter(i)) = ss(i,k);
                                    counter(i) = counter(i) + 1;
                                end
                            end
                        end

                        ld.Value = .75;
                        ld.Message = 'A calcular best-server para cada recetor através dos vetores anteriores ...';

                        for i = 1:length(rxs_small) % mostra macrocell best server para cada RX
                            for j = 1:length(tx_pos)
                                if  ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) == 1)  || ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) > 1 && new_dist(i) == min( dist(i,:) ) )
                                    show( txs(tx_pos(i)),'Animation','none','Map',evalin('base', 'viewer4') );
                                    if evalin('base', 'genMode') == '0'
                                        pattern(txs(tx_pos(i)),txs(tx_pos(i)).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer4'))
                                    end
                                    show(rxs_small(i),'Animation','none','Map',evalin('base', 'viewer4'));
                                    if evalin('base', 'genMode') == '0'
                                        pattern(rxs_small(i),txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer4'))
                                    end
                                    los(txs(tx_pos(i)),rxs_small(i),'Animation','none','Map',evalin('base', 'viewer4'));

                                    bs_tx(i) = txs(tx_pos(i));
                                    bs_rx(i) = rxs_small(i);
                                end
                            end
                        end
                        assignin('base',"bs_tx",bs_tx);
                        assignin('base',"bs_rx",bs_rx);

                    else
                        for i = 1:length(rxs_small)
                            for k = 1:length(txs)
                                ss(i,k)   = sigstrength(rxs_small(i),txs(k),pm);    % calcula potência recebida nos RX
                                dist(i,k) = distance(txs(k),rxs_small(i));
                            end
                        end

                        ld.Value = .50;
                        ld.Message = 'A determinar vetores de posição e distância de possíveis best-servers para cada recetor ...';

                        counter = ones(length(rxs_small));
                        for i = 1:length(rxs_small) % mostra macrocell best server para cada RX
                            for k = 1:length(txs)
                                if  sigstrength(rxs_small(i),txs(k),pm) == max(ss(i,:))
                                    tx_pos(i,counter(i))   = k;             % guarda posição das células das torres best server
                                    new_dist(i,counter(i)) = dist(i,k);     % para as potências mais altas de RX e de valor igual, guardar distância
                                    new_ss(i,counter(i))   = ss(i,k);
                                    counter(i) = counter(i) + 1;
                                end
                            end
                        end

                        ld.Value = .75;
                        ld.Message = 'A calcular best-server para cada recetor através dos vetores anteriores ...';

                        for i = 1:1:length(rxs_small) % mostra macrocell best server para cada RX
                            for j = 1:1:length(tx_pos)
                                if  ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) == 1)  || ( new_ss(i) == max( ss(i,:) ) && length(new_ss(i)) > 1 && new_dist(i) == min( dist(i,:) ) )
                                    show( txs(tx_pos(i)),'Animation','none','Map',evalin('base', 'viewer4') );
                                    if evalin('base', 'genMode') == '0'
                                        pattern(txs(tx_pos(i)),txs(tx_pos(i)).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer4'))
                                    end
                                    show(rxs_small(i),'Animation','none','Map',evalin('base', 'viewer4'));
                                    if evalin('base', 'genMode') == '0'
                                        pattern(rxs_small(i),txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer4'))
                                    end
                                    los(txs(tx_pos(i)),rxs_small(i),'Animation','none','Map',evalin('base', 'viewer4'));
                                    link(rxs_small(i),txs(tx_pos(i)),pm,"SuccessColor",'blue',"FailColor",'black','Animation','none','Map',evalin('base', 'viewer4'));
                                    if strcmpi(evalin('base', 'propModel'),'raytracing')
                                        raytrace(txs(tx_pos(i)),rxs_small(i),pm,'Animation','none','Map',evalin('base', 'viewer4'));
                                    end

                                    bs_tx(i) = txs(tx_pos(i));
                                    bs_rx(i) = rxs_small(i);
                                end
                            end
                        end
                        assignin('base',"bs_tx",bs_tx);
                        assignin('base',"bs_rx",bs_rx);

                    end

                    filename = path2 + "files/small/bestserver/" + evalin('base', 'planString') + "_"  + evalin('base', 'propModel') + "_bestserver_small_" + date + ".mat";
                    save(convertStringsToChars(filename),'bs_tx','bs_rx');

                elseif evalin('base', 'simMode') == '1'        % LOAD
                    ld.Value = .50;
                    ld.Message = 'A ler ficheiro de best-servers das small cells ...';
                    fileData = load(convertStringsToChars(file_bestserver_small),'bs_tx','bs_rx');

                    show(bs_rx,'Animation','none','Map',evalin('base', 'viewer4'));
                    show(bs_tx,'Animation','none','Map',evalin('base', 'viewer4'));
                    for i = 1:length(bs_rx)
                        if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                            los(bs_tx(i),bs_rx(i),'Animation','none','Map',evalin('base', 'viewer4'));
                        else
                            los(bs_tx(i),bs_rx(i),'Animation','none','Map',evalin('base', 'viewer4'));
                            link(bs_rx(i),bs_tx(i),pm,"SuccessColor",'blue',"FailColor",'black','Animation','none','Map',evalin('base', 'viewer4'));
                            if strcmpi(evalin('base', 'propModel'),'raytracing')
                                raytrace(bs_tx(i),bs_rx(i),pm,'Animation','none','Map',evalin('base', 'viewer4'));
                            end
                        end
                    end
                end

                ld.Value = 1;
                ld.Message = 'A terminar ...';
                pause(1);
                close(ld);

            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as small cells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb4_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb4_OK = 1;
    end



%% ANTENNAS
    function cb_macro_ant(~,~)
        if evalin('base', 'exist(''fig_macro_ant'',''var'')')
            evalin('base', 'close(fig_macro_ant)');
        end

        assignin('base','fig_macro_ant',                             ...
            figure("Name","Diagrama Radiação - Macrocell Antenna",   ...
            'NumberTitle',"off",                                     ...
            "WindowState","maximized")                               ...
            );
        if evalin('base', 'planMode') == '0'        % INICIAL
            pattern(design(dipole,fc(12)),fc(12))
        elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
            pattern(macro_ant,fc(12))
        end
    end
    function cb_macro_ant_az(~,~)
        if evalin('base', 'exist(''fig_macro_ant_az'',''var'')')
            evalin('base', 'close(fig_macro_ant_az)');
        end

        assignin('base','fig_macro_ant_az',                                    ...
            figure("Name","Diagrama Corte Diretividade - Macrocell Antenna",   ...
            'NumberTitle',"off",                                               ...
            "WindowState","maximized")                                         ...
            );
        if evalin('base', 'planMode') == '0'        % INICIAL
            patternAzimuth(design(dipole,fc(12)),fc(12),[0 25 45 65 90])
        elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
            patternAzimuth(macro_ant,fc(12),[0 25 45 65 90])
        end

    end


    function cb_small_ant(~,~)
        if evalin('base', 'exist(''fig_small_ant'',''var'')')
            evalin('base', 'close(fig_small_ant)');
        end

        assignin('base','fig_small_ant',                              ...
            figure("Name","Diagrama Radiação - Small cell Antenna (Estádio)",   ...
            'NumberTitle',"off",                                      ...
            "WindowState","maximized")                                ...
            );
        pattern(small_ant_stadium,fc(19))
    end
    function cb_small_ant_az(~,~)
        if evalin('base', 'exist(''fig_small_ant_az'',''var'')')
            evalin('base', 'close(fig_small_ant_az)');
        end

        assignin('base','fig_small_ant_az',                                     ...
            figure("Name","Diagrama Corte Diretividade - Small cell Antenna (Estádio)",   ...
            'NumberTitle',"off",                                                ...
            "WindowState","maximized")                                          ...
            );
        patternAzimuth(small_ant_stadium,fc(19),[0 25 45 65 90])
    end


    function cb_small_ant_car(~,~)
        if evalin('base', 'exist(''fig_small_ant_car'',''var'')')
            evalin('base', 'close(fig_small_ant_car)');
        end

        assignin('base','fig_small_ant_car',                              ...
            figure("Name","Diagrama Radiação - Antena Veiculo",   ...
            'NumberTitle',"off",                                      ...
            "WindowState","maximized")                                ...
            );
        pattern(phased.IsotropicAntennaElement,fc(21))
    end
    function cb_small_ant_az_car(~,~)
        if evalin('base', 'exist(''fig_small_ant_az_car'',''var'')')
            evalin('base', 'close(fig_small_ant_az_car)');
        end

        assignin('base','fig_small_ant_az_car',                                     ...
            figure("Name","Diagrama Corte Diretividade - Antena Veiculo",   ...
            'NumberTitle',"off",                                                ...
            "WindowState","maximized")                                          ...
            );
        patternAzimuth(phased.IsotropicAntennaElement,fc(21),[0 25 45 65 90])
    end


%% TRÁFEGO
    function cb_genTraffic(~,~)
        all_fig = findall(groot,'Type','uifigure');
        if evalin('base', 'exist(''fig_gen_traffic'',''var'')')
            evalin('base', 'close(fig_gen_traffic)');
        end

        fig_gen_traffic = uifigure("Name","Gerador de tráfego", ...
            "NumberTitle","off"',                               ...
            "WindowState","maximized",                          ...
            "ToolBar","none");

        genTraffic(fig_gen_traffic);
        pause(1);
        uialert(fig_gen_traffic,'Esta funcionalidade ficou inacabada uma vez que se tomaram outras abordagens! O interface de controlo pode criar erros!','Aviso','Icon','warning');
    end


%% DENSIDADE POPULACIONAL
    function cb_popDensity(~,~)
        if evalin('base', 'exist(''fig_popDensity'',''var'')')
            evalin('base', 'close(fig_popDensity)');
        end

        assignin('base','fig_popDensity',                                     ...
            figure("Name","Densidade populacional da cidade de Leiria",   ...
            'NumberTitle',"off",                                                ...
            "WindowState","maximized")                                          ...
            );

        dist = 0:1:2000;                          % -> Area da cidade: 2000*2 = 4km^2

        i=1:length(dist);
        pdf = 1.5e6*normpdf(i, 0, 202) + 38;   % criação da distribuição de probabilidade da população desde o centro da cidade para os limites (2D)
        pdf = round(pdf);                         % discretização do vetor
        assignin('base','pdf_func',pdf);
        subplot('Position',[0.035 0.75 0.2 0.2]);
        plot(dist, pdf,'Color','blue')
        hold on
        title('Densidade Populacional - Cidade Leiria (2D)')
        xlabel('Área da cidade de Leiria [m]')
        ylabel('Número de habitantes')

        bw = zeros(length(dist),length(dist));
        bw(round(length(dist)/2), round(length(dist)/2)) = 1;
        BS = bwdist(bw);
        Z = 1.5e6*normpdf(BS, 0, 202) + 38;   % criação da distribuição de probabilidade da população desde o centro da cidade para os limites (#D)
        M_pop = round(Z);                        % discretização da matriz
        inc = 1000;
        M_pop_rounded = inc * round(Z/inc);

        max_pop_M = sum(Z,'all');
        avg_pop_M = zeros(length(dist));
        for i = 1:length(dist)
            avg_pop_M(i) = max_pop_M / ( size(Z,1) * size(Z,2) );
        end
        avg_pop = mean(pdf);
        yline(avg_pop,'--','Color','red');
   
        legend({'Distribuição Populacional','Densidade Populacional'},'Location','northeast')
        xlim([0 length(dist)])
        hold off

        %[xi,yi] = polyxpoly(dist,pdf,dist,avg_pop);
        fprintf(['Média População: ' num2str(mean2(Z)) ' habitantes/km2\n']);

        subplot('Position',[0.3 0.15 0.65 0.65]);
        [X,Y] = meshgrid(dist,dist);
        surf(X,Y,Z,Z,"EdgeColor",'none')
        title('Densidade Populacional - Cidade Leiria (3D)')
        xlabel('Área da cidade de Leiria [m]')
        ylabel('Número de habitantes')
        xlim([0 length(dist)])
        ylim([0 length(dist)])
        colorbar

        assignin('base','M_pop',M_pop);
        assignin('base','M_pop_rounded',M_pop_rounded);
        fprintf('Matriz de densidade populacional gerada! Já é possível gerar o mapa de capacidade!\n');
    end


%% CAPACITY MACROCELLS
    function cb_capacity(~,~)
        if evalin('base', 'exist(''M_pop'',''var'')') && cb_capacity_OK == 1 && evalin('base', 'planMode') == '1'
            cb_capacity_OK = 0;

            txs = txs_hex_fix;

            ld = uiprogressdlg(f1,'Title','Mapa de Capacidade - Macrocells','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
            if evalin('base', 'exist(''viewer_capacity'',''var'')')
                evalin('base', 'close(viewer_capacity)');
            end

            % CAPACITY
            assignin('base','viewer_capacity', ...
                siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de Capacidade Macrocells", ...
                "Position"            ,[0 0 1920 1050],          ...
                "Basemap"             ,"openstreetmap",          ...
                "Terrain"             ,"gmted2010",              ...
                "Buildings"           ,building_map)             ...
                );

            ld.Value = .25;
            ld.Message = 'A apresentar macrocells e padrões de antena no mapa ...';
            show(txs,'Animation','none','Map',evalin('base', 'viewer_capacity'));
            if evalin('base', 'genMode') == '0'
                for i = 1:1:length(txs) % show macrocells and patterns
                    pattern(txs(i),txs(i).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer_capacity'));
                end
            end

            ld.Value = .50;
            ld.Message = 'A apresentar recetores e padrões de antena no mapa ...';
            show(rxs_macro,'Animation','none','Map',evalin('base', 'viewer_capacity'));
            if evalin('base', 'genMode') == '0'
                for i = 1:1:length(rxs_macro) % show receivers and patterns
                    pattern(rxs_macro(i),txs(1).TransmitterFrequency,'Size',2,'Map',evalin('base', 'viewer_capacity'));
                end
            end

            ld.Value = .75;
            if evalin('base', 'simMode') == '0'        % RUN

                ld.Message = 'A adquirir a grelha de latitudes e longitudes em redor das macrocells ...';
                SRx = rxs_macro(1).ReceiverSensitivity; % dBm
                centerSite = txsite("Name","Center Site","Latitude",39.74452, "Longitude",-8.80805);
                [table_temp,rx_test,~,LOC] = locMatrix(txs(1).TransmitterFrequency,centerSite,SRx);
                table_cell  = {table_temp};
                assignin("base","LOC",LOC);
                
                ld.Message = 'A distribuir os valores da densidade populacional por cada célula ...';
                hexGrid = imread([path 'img\hexGrid.png'],'png');
                hexGrid = rgb2gray(hexGrid);
                hexGrid = double(hexGrid);
                hexFinal = zeros(length(hexGrid),length(hexGrid));
                pdf_func = evalin('base', 'pdf_func');
                for i = 1:1:201
                    for k = 1:1:201
                        if hexGrid(i,k) == 255
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 251
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 247
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 243
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 239
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 235
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 231
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 227
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 223
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 219
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 215
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 211
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 207
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 203
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 199
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 195
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 191
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 187
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 183
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 179
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 175
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 171
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 167
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 163
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 159
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 155
                            hexFinal(i,k) = round( pdf_func(1) + randi(round(pdf_func(1)/100)) );
                        elseif hexGrid(i,k) == 151
                            hexFinal(i,k) = round( pdf_func(1) + randi(round(pdf_func(1)/100)) );
                        elseif hexGrid(i,k) == 147
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 143
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 139
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 135
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 131
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 127
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 123
                            hexFinal(i,k) = round( pdf_func(1) + randi(round(pdf_func(1)/100)) );
                        elseif hexGrid(i,k) == 119
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 115
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 111
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 107
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 103
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 99
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 95
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 91
                            hexFinal(i,k) = round( pdf_func(100) + randi(round(pdf_func(100)/100)) );
                        elseif hexGrid(i,k) == 87
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 83
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 79
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 75
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 71
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 67
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 63
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 59
                            hexFinal(i,k) = round( pdf_func(200) + randi(round(pdf_func(200)/100)) );
                        elseif hexGrid(i,k) == 55
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 51
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        elseif hexGrid(i,k) == 47
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 43
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 39
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 35
                            hexFinal(i,k) = round( pdf_func(300) + randi(round(pdf_func(300)/100)) );
                        elseif hexGrid(i,k) == 31
                            hexFinal(i,k) = round( pdf_func(400) + randi(round(pdf_func(400)/100)) );
                        else
                            hexFinal(i,k) = round( pdf_func(600) + randi(round(pdf_func(400)/100)) );
                        end
                    end
                end
                assignin('base',"hexFinal",hexFinal);

                spacer  = zeros(201,201);
                s1      = horzcat(spacer,spacer,spacer);
                s2      = horzcat(spacer,hexFinal,spacer);
                s_final = vertcat(s1,s2,s1);
                s_final = s_final(1:3:end,:);
                s_final = s_final(:,1:3:end);

                cap_vec = reshape(s_final.',1,[]); % Matrix to vector
                cap_vec = cap_vec';
                assignin("base","cap_vec",cap_vec);    

                ld.Message = 'A agregar todos os dados de densidade populacional numa tabela única ...';
                ts = table( table_cell{1,1}.Latitude,table_cell{1,1}.Longitude,cap_vec(:,1));
                assignin("base","ts",ts);
                count = 1;
                f_ts = table(0,0,0);
                for i = 1:1:height(ts)
                    % if ts(:,3).Var3(i) >= 500
                        f_ts(count,:) = ts(i,:);
                        count = count + 1;
                    % end
                end
                f_ts(1,:) = [];
                f_table_cell = {f_ts};
                f_table_cell{1,1}.Properties.VariableNames = {'Latitude','Longitude','Custom'};

                capacityData = propagationData(f_table_cell{1,1});

                filename = path2 + "files/macro/capacity/" + evalin('base', 'planString') + "_capacity_macro_" + date + ".mat";
                save(convertStringsToChars(filename),'capacityData');

                file     = "kml\macro\capacity\capacity_macro_" + date;
                M_data_power = reshape(cap_vec,round(sqrt( length(evalin('base', 'cap_vec')) )),[]);
                createKML(path, convertStringsToChars(file),M_data_power,"Mapa de Capacidade Macrocells","CAPACITY",LOC,txs,rxs_macro);

                pd = propagationData(capacityData.Data);
            elseif evalin('base', 'simMode') == '1'    % LOAD
                ld.Message = 'A ler ficheiro de capacidade das macrocells ...';
                fileData = load(convertStringsToChars(file_capacity_macro),'capacityData');

                pd = propagationData(fileData.capacityData.Data);
            end

            legendTitle = "Capacity" + newline + "(users/cell)";
            contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",380:80:max(max(ts(:,3).Var3)),"ColorLimits",[380 max(max(ts(:,3).Var3))],"Transparency",1,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_capacity'));

            ld.Value = 1;
            ld.Message = 'A terminar ...';
            pause(1);
            close(ld);
        elseif evalin('base', 'planMode') == '0' || evalin('base', 'exist(''M_pop'',''var'')') == 0
            uialert(f1,'É necessário ter o modo de planeamento optimizado ativado e a matriz de densidade de população para testar esta funcionalidade!','Erro','Icon','error');
        elseif (cb_capacity_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        end
        cb_capacity_OK = 1;
    end


%% PERFIL ATRASO POTENCIA - SMALL CELLS
    function cb_delayProfile(~,~)
        if evalin('base', 'exist(''propModel'',''var'')') && cb_delay_OK == 1
            cb_delay_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));

            if strcmpi(evalin('base', 'propModel'), "raytracing")

                if evalin('base', 'planMode') == '0'        % INICIAL
                    txs = txs_small;
                elseif evalin('base', 'planMode') == '1'    % OPTIMIZADO
                    txs = txs_small_opt;
                end
                freq_OK = checkFreq(txs,evalin('base', 'propModel'));

                if (freq_OK == 1) && (pm_OK == 1)
                    clc
                    ld = uiprogressdlg(f1,'Title','Perfil Atraso Potência - Small Cells','Icon',path+"img\"+'tab_logo.png','Message','A calcular os valores de perfil de atraso de potência ...');

                    if evalin('base', 'exist(''fig_power_delay'',''var'')')
                        evalin('base', 'close(fig_power_delay)');
                    end

                    assignin('base','fig_power_delay',                                     ...
                        figure("Name","Perfil Atraso Potência",   ...
                        'NumberTitle',"off",                                                ...
                        "WindowState","maximized")                                          ...
                        );
                    for i = 1:1:length(txs)
                        rays(i) = raytrace(txs(i),rxs_small,pm,'Animation','none');
                    end
                    assignin('base','rays',rays);

                    delay = zeros(length(txs),length(rays{1,1}));
                    pl    = zeros(length(txs),length(rays{1,1}));
                    power = zeros(length(txs),length(rays{1,1}));
                    for k = 1:1:length(txs)
                        for i = 1:1:length(rays{1,k})
                            delay(k,i) = rays{1,k}(1,i).PropagationDelay;
                            pl(k,i)    = rays{1,k}(1,i).PathLoss;
                            power(k,i) = 10*log10(txs(1).TransmitterPower/ 1e-3) - pl(k,i);     %dB
                        end
                    end

                    count = 1;
                    for i = 1:1:length(txs)
                        subplot(length(txs),2,count);
                        y(i) = 10*log10(txs(i).TransmitterPower/ 1e-3);
                        stem(0,y(i),'filled')
                        title(['TX' num2str(i)])
                        xlabel('Atraso [us]')
                        ylabel('P_TX [dBm]')
                        xlim([-0.1e-6 1e-6])
                        ylim([0 45])
                        count = count + 1;

                        subplot(length(txs),2,count);
                        for k = 1:1:size(delay,2)
                            if power(i,k) ~= 0
                                stem(delay(i,k), power(i,k),'filled','Color','red')
                                hold on
                            end
                        end
                        title('RX')
                        xlabel('Atraso [us]')
                        ylabel('P_RX [dBm]')
                        d = delay(i,:);
                        xlim([min(d(d>0))-0.001*min(d(d>0)) max(delay(i,:))+0.001*max(delay(i,:))])
                        ylim([-100 0])
                        count = count + 1;
                    end
                    sgtitle('Perfil de atraso de potência - Small Cells')

                    vec_power = [];
                    count = 1;
                    for i = 1:1:length(txs)
                        for k = 1:1:size(power,2)
                            if power(i,k) ~= 0
                                vec_power{1,i}(1,count) = power(i,k);
                                vec_delay{1,i}(1,count) = delay(i,k);
                                count = count + 1;
                            end
                        end
                        count = 1;
                    end
                    assignin('base','vec_power',vec_power);
                    assignin('base','vec_delay',vec_delay);
                    assignin('base','power',power);
                    assignin('base','delay',delay);

                    % TX 1
                    power_W{1,1} = 10 .^ ((vec_power{1,1} - 30) / 10);
                    mean_exc_delay(1) = sum(vec_delay{1,1} * power_W{1,1} ) / sum(power_W{1,1});
                    mean_rms_delay(1) = sum(vec_delay{1,1}^2 * power_W{1,1} ) / sum(power_W{1,1});
                    rms_delay_spread(1) = sqrt(vpa(mean_rms_delay(1)) - (vpa(mean_exc_delay(1)))^2 );
                    rms_delay_s(1) = double(rms_delay_spread(1));

                    % TX 5
                    power_W{1,5} = 10 .^ ((vec_power{1,5} - 30) / 10);
                    mean_exc_delay(5) = sum(vec_delay{1,5} * power_W{1,5} ) / sum(power_W{1,5});
                    mean_rms_delay(5) = sum(vec_delay{1,5}^2 * power_W{1,5} ) / sum(power_W{1,5});
                    rms_delay_spread(5) = sqrt(vpa(mean_rms_delay(5)) - (vpa(mean_exc_delay(5)))^2 );
                    rms_delay_s(5) = double(rms_delay_spread(5));

                    assignin('base','mean_exc_delay',mean_exc_delay);
                    assignin('base','mean_rms_delay',mean_rms_delay);
                    assignin('base','rms_delay_s',rms_delay_s);

                    fprintf(['TX 1 -> Atraso Excedente Médio:   ' num2str(mean_exc_delay(1)*1e6) '  us\n     -> Atraso Eficaz:            ' num2str(rms_delay_s(1)*1e15) '  fs\n'])
                    fprintf(['TX 2 -> Atraso Excedente Médio:   ' num2str(mean_exc_delay(5)*1e6) '  us\n     -> Atraso Eficaz:            ' num2str(rms_delay_s(5)*1e15) '   fs\n'])

                    ld.Value = 1;
                    ld.Message = 'A terminar ...';
                    pause(1);
                    close(ld);

                elseif (freq_OK == 0)
                    uialert(f1,'A frequência usada para as small cells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
                end
            else
                uialert(f1,'Este cálculo só funciona com modelo de propagação Raytracing!','Erro','Icon','error');
            end
        elseif (cb_delay_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb_delay_OK = 1;
    end


%% HANDOVER
    function cb_handover(~,~)
        c4.BackgroundColor = 'red';
        c4.ForegroundColor = 'white';
        if evalin('base', 'exist(''propModel'',''var'')') && cb_handover_OK == 1
            cb_handover_OK = 0;
            [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));
            freq_OK    = checkFreq(txs_post,evalin('base', 'propModel'));

            if (freq_OK == 1) && (pm_OK == 1)
                if evalin('base', 'exist(''viewer5'',''var'')')
                    evalin('base', 'close(viewer5)');
                end

                ld = uiprogressdlg(f1,'Title','Teste de Handover','Icon',path+"img\"+'tab_logo.png','Message','A carregar ficheiro .osm dos edíficios de Leiria ...');
                % Teste Handover
                assignin('base','viewer5', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Mapa de Teste Handover", ...
                    "Position"            ,[0 0 1920 1050],          ...
                    "Basemap"             ,"openstreetmap",          ...
                    "Terrain"             ,"gmted2010",              ...
                    "Buildings"           ,building_map)             ...
                    );

                ld.Value = 1;
                ld.Message = 'A terminar cálculos ...';
                pause(1);
                close(ld);
            elseif (freq_OK == 0)
                uialert(f1,'A frequência usada para as small cells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
            end
        elseif (cb_handover_OK == 0)
            uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
        cb_handover_OK = 1;
    end

    function cb_handover_plus(~,~)
        if evalin('base', 'exist(''fig_small_handover'',''var'')')
            evalin('base', 'close(fig_small_handover)');
        end

        if evalin('base', 'exist(''viewer5'',''var'')')

            if evalin('base', 'exist(''propModel'',''var'')') && cb_handover_OK == 1
                cb_handover_OK = 0;
                [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));
                freq_OK    = checkFreq(txs_post,evalin('base', 'propModel'));

                if (freq_OK == 1) && (pm_OK == 1)

                    if car_loc_now+1 < length(txs_post)
                        ld = uiprogressdlg(f1,'Title','Teste de Handover','Icon',path+"img\"+'tab_logo.png','Message','A obter posição do veículo ...');

                        car_loc_now = car_loc_now + 1;
                        clearMap(evalin('base', 'viewer5'))

                        p1value = uicontrol(t_handover,'Style','text','ForegroundColor','blue','fontweight','bold');
                        p1value.Position = [140 90 20 15];       % x, y , size_x, size y
                        p1value.String = num2str(car_loc_now);

                        if car_loc_now+1 == length(txs_post)
                            c3.BackgroundColor = 'red';
                            c3.ForegroundColor = 'white';
                        elseif car_loc_now <= 1
                            c4.BackgroundColor = 'red';
                            c4.ForegroundColor = 'white';
                        else
                            c3.BackgroundColor = 'white';
                            c3.ForegroundColor = 'black';
                            c4.BackgroundColor = 'white';
                            c4.ForegroundColor = 'black';
                        end

                        ld.Message = 'A calcular distâncias entre small cells, azimute e recetores de teste entre estações base ...';
                        res = 100;
                        loc = car_loc_now;
                        alfa = angle(txs_post(loc),txs_post(loc+1));
                        d_max = distance(txs_post(loc),txs_post(loc+1));
                        d_vec = 0:d_max/(res-1):d_max;
                        for i = 1:1:res
                            [cellLats(i),cellLons(i)] = location(txs_post(loc), d_vec(i), alfa);
                        end

                        assignin('base','d_max',d_max);
                        assignin('base','d_vec',d_vec);

                        SRx = -78; % dBm
                        for i = 1:1:res
                            name = "Test Site " + num2str(i);
                            rx_test(i) = rxsite("Name",name, ...
                                'Latitude',cellLats(i), ...
                                'Longitude',cellLons(i), ...
                                'ReceiverSensitivity',SRx);
                        end

                        show(txs_post(loc),'Map',evalin('base', 'viewer5'));
                        show(txs_post(loc+1),'Map',evalin('base', 'viewer5'));

                        if evalin('base', 'simMode') == '0'        % RUN

                            if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                                ld.Message = 'A calcular a perdas de percurso nos pontos envolventes às small cells ...';
                                if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                                    d0 = 100;
                                    n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                                    pl_logdist_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        pl_logdist_A(i) = m_logdist(txs_post(loc).TransmitterFrequency,d_vec(i),d0,n);
                                    end
                                    pl_logdist_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        pl_logdist_B(i) = m_logdist(txs_post(loc+1).TransmitterFrequency,d_vec(i),d0,n);
                                    end

                                    ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                    PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - m_free(txs_post(loc).TransmitterFrequency,d_vec(i)) - pl_logdist_A(i); % Budget Link
                                    end
                                    PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - m_free(txs_post(loc+1).TransmitterFrequency,d_vec(i)) - pl_logdist_B(i); % Budget Link
                                    end
                                elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                                    d0 = 100;
                                    n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                                    sigma = evalin('base', 'propModel_LogNormal_Variance');
                                    pl_lognorm_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        pl_lognorm_A(i) = m_lognorm(txs_post(loc).TransmitterFrequency,d_vec(i),d0,n,sigma);
                                    end
                                    pl_lognorm_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        pl_lognorm_B(i) = m_lognorm(txs_post(loc+1).TransmitterFrequency,d_vec(i),d0,n,sigma);
                                    end

                                    ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                    PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - m_free(txs_post(loc).TransmitterFrequency,d_vec(i)) - pl_lognorm_A(i); % Budget Link
                                    end
                                    PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - m_free(txs_post(loc+1).TransmitterFrequency,d_vec(i)) - pl_lognorm_B(i); % Budget Link
                                    end
                                elseif strcmpi(evalin('base', 'propModel'), "hata")
                                    areaType = evalin('base', 'propModel_Hata_AreaType');
                                    pl_hata_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        pl_hata_A(i) = m_hata(txs_post(loc).TransmitterFrequency,d_vec(i),txs_post(loc).AntennaHeight,rx_test(i).AntennaHeight,areaType);
                                    end
                                    pl_hata_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        pl_hata_B(i) = m_hata(txs_post(loc+1).TransmitterFrequency,d_vec(i),txs_post(loc+1).AntennaHeight,rx_test(i).AntennaHeight,areaType);
                                    end

                                    ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                    PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - pl_hata_A(i); % Budget Link
                                    end
                                    PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - pl_hata_B(i); % Budget Link
                                    end
                                end
                                PRx_A(1) = 10*log10(txs_post(loc).TransmitterPower/1e-3);
                                PRx_B(1) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3);
                                assignin('base','PRx_A',PRx_A);
                                assignin('base','PRx_B',PRx_B);
                            else % modelos MATLAB
                                ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                for i = 1:1:length(rx_test)
                                    PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - pathloss(pm,rx_test(i),txs_post(loc)); % Budget Link
                                end
                                PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                for i = 1:1:length(rx_test)
                                    PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - pathloss(pm,rx_test(i),txs_post(loc+1)); % Budget Link
                                end
                                PRx_A(1) = PRx_A(2);
                                PRx_B = fliplr(PRx_B);
                                PRx_B(1) = PRx_B(2);
                                assignin('base','PRx_A',PRx_A);
                                assignin('base','PRx_B',PRx_B);
                            end

                            % PLOT GRAPH POWER TX
                            assignin('base','fig_small_handover',                  ...
                                figure("Name","Teste de Handover - Small Cells",   ...
                                'NumberTitle',"off",                               ...
                                "WindowState","maximized")                         ...
                                );

                            yyaxis left
                            plot(d_vec,PRx_A,'Color','blue');
                            xlim([-1 d_max+1])
                            title(['Handover (TX ', num2str(loc), ' & TX ', num2str(loc+1), ')'])
                            xlabel('Distância [m]')
                            ylabel(['PRx TX ',num2str(loc)])
                            hold on
                            yyaxis right
                            plot(fliplr(d_vec),PRx_B,'Color','red');
                            ylabel(['PRx TX ',num2str(loc+1)])
                            hold off

                            [xi,yi] = polyxpoly(d_vec,PRx_A,fliplr(d_vec),PRx_B);    % Deteta a interseção entre as funções
                            [~,idx] = min(abs(d_vec-xi));                            % Deteta o valor de d_vec mais próximo de xi
                            minVal1    = d_vec(idx);
                            minVal2    = d_vec(idx+1);
                            diff_1 = abs(minVal1 - xi);
                            diff_2 = abs(minVal2 - xi);

                            if diff_1 > diff_2
                                pos = idx+1;
                            elseif diff_1 <= diff_2
                                pos = idx;
                            end

                            if (loc == 1)
                                cLat = rx_test(pos).Latitude;
                                cLon = rx_test(pos).Longitude;
                            elseif loc == 2
                                [cLat,cLon] = location(rx_test(pos), 5, alfa+90);
                            elseif loc == 3
                                [cLat,cLon] = location(rx_test(pos), 3, alfa+90);
                            end
                            car = rxsite("Name","Veículo", ...
                                'Latitude',cLat,               ...
                                'Longitude',cLon,              ...
                                'ReceiverSensitivity',SRx);

                            show(car);
                            [az,el] = angle(txs_post(loc), car);
                            txs_post(loc).AntennaAngle = [az,el];
                            [az,el] = angle(txs_post(loc+1), car);
                            txs_post(loc+1).AntennaAngle = [az,el];

                            if evalin('base', 'genMode') == '0'
                                pattern(txs_post(loc),txs_post(loc).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer5'))
                                pattern(txs_post(loc+1),txs_post(loc+1).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer5'))
                                pattern(car,txs_post(loc).TransmitterFrequency,'Size',1,'Map',evalin('base', 'viewer5'))
                            end
                        end

                        ld.Value = 1;
                        ld.Message = 'A terminar ...';
                        pause(1);
                        close(ld);
                    else
                        uialert(f1,'Já não existem mais posições a incrementar para o carro!','Aviso','Icon','warning');
                    end

                elseif (freq_OK == 0)
                    uialert(f1,'A frequência usada para as small cells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
                end
            elseif (cb_handover_OK == 0)
                uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
            else
                uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
            end
            cb_handover_OK = 1;
        end
    end


    function cb_handover_minus(~,~)
        if evalin('base', 'exist(''viewer5'',''var'')')

            if evalin('base', 'exist(''propModel'',''var'')') && cb_handover_OK == 1
                cb_handover_OK = 0;
                [pm_OK,pm] = checkPM(f1,evalin('base', 'propModel'));
                freq_OK    = checkFreq(txs_post,evalin('base', 'propModel'));

                if (freq_OK == 1) && (pm_OK == 1)

                    if car_loc_now > 1
                        ld = uiprogressdlg(f1,'Title','Teste de Handover','Icon',path+"img\"+'tab_logo.png','Message','A obter posição do veículo ...');

                        car_loc_now = car_loc_now - 1;
                        clearMap(evalin('base', 'viewer5'))

                        p1value = uicontrol(t_handover,'Style','text','ForegroundColor','blue','fontweight','bold');
                        p1value.Position = [140 90 20 15];       % x, y , size_x, size y
                        p1value.String = num2str(car_loc_now);

                        if car_loc_now == length(txs_post)
                            c3.BackgroundColor = 'red';
                            c3.ForegroundColor = 'white';
                        elseif car_loc_now <= 1
                            c4.BackgroundColor = 'red';
                            c4.ForegroundColor = 'white';
                        else
                            c3.BackgroundColor = 'white';
                            c3.ForegroundColor = 'black';
                            c4.BackgroundColor = 'white';
                            c4.ForegroundColor = 'black';
                        end

                        ld.Message = 'A calcular distâncias entre small cells, azimute e recetores de teste entre estações base ...';
                        res = 100;
                        loc = car_loc_now;
                        alfa = angle(txs_post(loc),txs_post(loc+1));
                        d_max = distance(txs_post(loc),txs_post(loc+1));
                        d_vec = 0:d_max/(res-1):d_max;
                        for i = 1:1:res
                            [cellLats(i),cellLons(i)] = location(txs_post(loc), d_vec(i), alfa);
                        end

                        assignin('base','d_max',d_max);
                        assignin('base','d_vec',d_vec);

                        SRx = -78; % dBm
                        for i = 1:1:res
                            name = "Test Site " + num2str(i);
                            rx_test(i) = rxsite("Name",name, ...
                                'Latitude',cellLats(i), ...
                                'Longitude',cellLons(i), ...
                                'ReceiverSensitivity',SRx);
                        end

                        show(txs_post(loc),'Map',evalin('base', 'viewer5'));
                        show(txs_post(loc+1),'Map',evalin('base', 'viewer5'));

                        if evalin('base', 'simMode') == '0'        % RUN

                            if strcmpi(evalin('base', 'propModel'), "log-distance") || strcmpi(evalin('base', 'propModel'), "log-normal") || strcmpi(evalin('base', 'propModel'), "hata")
                                ld.Message = 'A calcular a perdas de percurso nos pontos envolventes às small cells ...';
                                if strcmpi(evalin('base', 'propModel'), "log-distance") % Free-Space + Log-Distance
                                    d0 = 100;
                                    n  = evalin('base', 'propModel_LogDistance_PathLossExp');
                                    pl_logdist_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        pl_logdist_A(i) = m_logdist(txs_post(loc).TransmitterFrequency,d_vec(i),d0,n);
                                    end
                                    pl_logdist_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        pl_logdist_B(i) = m_logdist(txs_post(loc+1).TransmitterFrequency,d_vec(i),d0,n);
                                    end

                                    ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                    PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - m_free(txs_post(loc).TransmitterFrequency,d_vec(i)) - pl_logdist_A(i); % Budget Link
                                    end
                                    PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - m_free(txs_post(loc+1).TransmitterFrequency,d_vec(i)) - pl_logdist_B(i); % Budget Link
                                    end
                                elseif strcmpi(evalin('base', 'propModel'), "log-normal") % Free-Space + Log-Normal
                                    d0 = 100;
                                    n  = evalin('base', 'propModel_LogNormal_PathLossExp');
                                    sigma = evalin('base', 'propModel_LogNormal_Variance');
                                    pl_lognorm_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        pl_lognorm_A(i) = m_lognorm(txs_post(loc).TransmitterFrequency,d_vec(i),d0,n,sigma);
                                    end
                                    pl_lognorm_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        pl_lognorm_B(i) = m_lognorm(txs_post(loc+1).TransmitterFrequency,d_vec(i),d0,n,sigma);
                                    end

                                    ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                    PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - m_free(txs_post(loc).TransmitterFrequency,d_vec(i)) - pl_lognorm_A(i); % Budget Link
                                    end
                                    PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - m_free(txs_post(loc+1).TransmitterFrequency,d_vec(i)) - pl_lognorm_B(i); % Budget Link
                                    end
                                elseif strcmpi(evalin('base', 'propModel'), "hata")
                                    areaType = evalin('base', 'propModel_Hata_AreaType');
                                    pl_hata_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        pl_hata_A(i) = m_hata(txs_post(loc).TransmitterFrequency,d_vec(i),txs_post(loc).AntennaHeight,rx_test(i).AntennaHeight,areaType);
                                    end
                                    pl_hata_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        pl_hata_B(i) = m_hata(txs_post(loc+1).TransmitterFrequency,d_vec(i),txs_post(loc+1).AntennaHeight,rx_test(i).AntennaHeight,areaType);
                                    end

                                    ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                    PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                    for i = 1:1:length(rx_test)
                                        PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - pl_hata_A(i); % Budget Link
                                    end
                                    PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                    for i = length(rx_test):-1:1
                                        PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - pl_hata_B(i); % Budget Link
                                    end
                                end
                                PRx_A(1) = 10*log10(txs_post(loc).TransmitterPower/1e-3);
                                PRx_B(1) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3);
                                assignin('base','PRx_A',PRx_A);
                                assignin('base','PRx_B',PRx_B);
                            else % modelos MATLAB
                                ld.Message = 'A calcular a potência nos pontos envolventes às small cells ...';
                                PRx_A = zeros(length(txs_post(loc)),length(rx_test));
                                for i = 1:1:length(rx_test)
                                    PRx_A(i) = 10*log10(txs_post(loc).TransmitterPower/1e-3) - pathloss(pm,rx_test(i),txs_post(loc)); % Budget Link
                                end
                                PRx_B = zeros(length(txs_post(loc+1)),length(rx_test));
                                for i = 1:1:length(rx_test)
                                    PRx_B(i) = 10*log10(txs_post(loc+1).TransmitterPower/1e-3) - pathloss(pm,rx_test(i),txs_post(loc+1)); % Budget Link
                                end
                                PRx_A(1) = PRx_A(2);
                                PRx_B = fliplr(PRx_B);
                                PRx_B(1) = PRx_B(2);
                                assignin('base','PRx_A',PRx_A);
                                assignin('base','PRx_B',PRx_B);
                            end

                            % PLOT GRAPH POWER TX
                            assignin('base','fig_small_handover',                  ...
                                figure("Name","Teste de Handover - Small Cells",   ...
                                'NumberTitle',"off",                               ...
                                "WindowState","maximized")                         ...
                                );

                            yyaxis left
                            plot(d_vec,PRx_A,'Color','blue');
                            xlim([-1 d_max+1])
                            title(['Handover (TX ', num2str(loc), ' & TX ', num2str(loc+1), ')'])
                            xlabel('Distância [m]')
                            ylabel(['PRx TX ',num2str(loc)])
                            hold on
                            yyaxis right
                            plot(fliplr(d_vec),PRx_B,'Color','red');
                            ylabel(['PRx TX ',num2str(loc+1)])
                            hold off

                            [xi,yi] = polyxpoly(d_vec,PRx_A,fliplr(d_vec),PRx_B);    % Deteta a interseção entre as funções
                            [~,idx] = min(abs(d_vec-xi));                            % Deteta o valor de d_vec mais próximo de xi
                            minVal1    = d_vec(idx);
                            minVal2    = d_vec(idx+1);
                            diff_1 = abs(minVal1 - xi);
                            diff_2 = abs(minVal2 - xi);

                            if diff_1 > diff_2
                                pos = idx+1;
                            elseif diff_1 <= diff_2
                                pos = idx;
                            end

                            if (loc == 1)
                                cLat = rx_test(pos).Latitude;
                                cLon = rx_test(pos).Longitude;
                            elseif loc == 2
                                [cLat,cLon] = location(rx_test(pos), 5, alfa+90);
                            elseif loc == 3
                                [cLat,cLon] = location(rx_test(pos), 3, alfa+90);
                            end
                            car = rxsite("Name","Veículo", ...
                                'Latitude',cLat,               ...
                                'Longitude',cLon,              ...
                                'ReceiverSensitivity',SRx);

                            show(car);
                            [az,el] = angle(txs_post(loc), car);
                            txs_post(loc).AntennaAngle = [az,el];
                            [az,el] = angle(txs_post(loc+1), car);
                            txs_post(loc+1).AntennaAngle = [az,el];

                            if evalin('base', 'genMode') == '0'
                                pattern(txs_post(loc),txs_post(loc).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer5'))
                                pattern(txs_post(loc+1),txs_post(loc+1).TransmitterFrequency,'Size',5,'Map',evalin('base', 'viewer5'))
                                pattern(car,txs_post(loc).TransmitterFrequency,'Size',1,'Map',evalin('base', 'viewer5'))
                            end
                        end

                        ld.Value = 1;
                        ld.Message = 'A terminar ...';
                        pause(1);
                        close(ld);
                    else
                        uialert(f1,'Já não existem mais posições a decrementar para o carro!','Aviso','Icon','warning');
                    end

                elseif (freq_OK == 0)
                    uialert(f1,'A frequência usada para as picocells está fora do intervalo de frequência do modelo de propagação!','Erro','Icon','error');
                end
            elseif (cb_handover_OK == 0)
                uialert(f1,'Já existe um mapa a ser gerado ou houve um erro a meio da criação do mesmo! Reinicie o simulador se necessário!','Erro','Icon','error');
            else
                uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
            end
            cb_handover_OK = 1;
        end
    end

%% VERIFICAÇÃO GLOBAL
    function cb_finalCheck(~,~)
        if evalin('base', 'exist(''propModel'',''var'')')
            all_fig = findall(groot,'Type','uifigure');
            if evalin('base', 'exist(''fig_final_check'',''var'')')
                evalin('base', 'close(fig_final_check)');
            end

            fig_final_check = uifigure("Name","Verificação Final - Macrocells (Modelo Otimizado)", ...
                "NumberTitle","off"',                              ...
                "WindowState","maximized",                         ...
                "ToolBar","none");

            txs = txs_hex_fix;
            
            finalReport(fig_final_check,path2,txs);
        else
            uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
        end
    end

%% CELL BREATHING
    function cb_cellBreath(~,~)
        if evalin('base', 'exist(''propModel'',''var'')')
            if strcmpi(evalin('base', 'propModel'), "freespace")
                if evalin('base', 'exist(''viewer_breath'',''var'')')
                    evalin('base', 'close(viewer_breath)');
                end

                assignin('base','viewer_breath', ...
                    siteviewer("Name","Simulador de Rede 5G Urbana - Cell Breathing", ...
                    "Position"            ,[0 0 1920 1050],          ...
                    "Basemap"             ,"openstreetmap",          ...
                    "Terrain"             ,"gmted2010",              ...
                    "Buildings"           ,building_map)             ...
                    );

                testCell_1 = txsite('Name','TX','Latitude', 39.74470,'Longitude',-8.80825, ...
                    "Antenna"               ,design(dipole,3500e6),           ...
                    "TransmitterFrequency"  ,3500e6,                             ...
                    "TransmitterPower"      ,10 ^ ((40 - 30) / 10));
                show(testCell_1,'Animation','none','Map',evalin('base', 'viewer_breath'))

                testCell_2 = txsite('Name','TX','Latitude', 39.74470,'Longitude',-8.80825, ...
                    "Antenna"               ,design(dipole,3500e6),           ...
                    "TransmitterFrequency"  ,3500e6,                             ...
                    "TransmitterPower"      ,10 ^ ((35 - 30) / 10));
                show(testCell_2,'Animation','none','Map',evalin('base', 'viewer_breath'))

                testCell_3 = txsite('Name','TX','Latitude', 39.74470,'Longitude',-8.80825, ...
                    "Antenna"               ,design(dipole,3500e6),           ...
                    "TransmitterFrequency"  ,3500e6,                               ...
                    "TransmitterPower"      ,10 ^ ((30 - 30) / 10));
                show(testCell_3,'Animation','none','Map',evalin('base', 'viewer_breath'))

                
                %coverageData = coverage(testCell_1,'PropagationModel','freespace',"SignalStrengths",-85:10:-5,'Transparency',0.5); % display coverage
                filename = path2 + "files/cellBreath/cell_1.mat";   % guarda dados em .mat
                fileData = load(convertStringsToChars(filename),'coverageData');
                pd = propagationData(fileData.coverageData.Data);
                legendTitle = "Power" + newline + "(dBm)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",-85:1:-5,"ColorLimits",[-85 -5],"Transparency",0.5,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_breath'));
                pause(10)
                clearMap(evalin('base', 'viewer_breath'))


                %coverageData = coverage(testCell_2,'PropagationModel','freespace',"SignalStrengths",-85:10:-5,'Transparency',0.5); % display coverage
                filename = path2 + "files/cellBreath/cell_2.mat";   % guarda dados em .mat
                fileData = load(convertStringsToChars(filename),'coverageData');
                pd = propagationData(fileData.coverageData.Data);
                legendTitle = "Power" + newline + "(dBm)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",-85:1:-5,"ColorLimits",[-85 -5],"Transparency",0.5,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_breath'));
                pause(10)
                clearMap(evalin('base', 'viewer_breath'))


                %coverageData = coverage(testCell_3,'PropagationModel','freespace',"SignalStrengths",-85:10:-5,'Transparency',0.5); % display coverage
                filename = path2 + "files/cellBreath/cell_3.mat";   % guarda dados em .mat
                fileData = load(convertStringsToChars(filename),'coverageData');
                pd = propagationData(fileData.coverageData.Data);
                legendTitle = "Power" + newline + "(dBm)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",-85:1:-5,"ColorLimits",[-85 -5],"Transparency",0.5,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_breath'));
                pause(10)
                clearMap(evalin('base', 'viewer_breath'))


                filename = path2 + "files/cellBreath/cell_2.mat";   % guarda dados em .mat
                fileData = load(convertStringsToChars(filename),'coverageData');
                pd = propagationData(fileData.coverageData.Data);
                legendTitle = "Power" + newline + "(dBm)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",-85:1:-5,"ColorLimits",[-85 -5],"Transparency",0.5,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_breath'));
                pause(10)
                clearMap(evalin('base', 'viewer_breath'))


                filename = path2 + "files/cellBreath/cell_1.mat";   % guarda dados em .mat
                fileData = load(convertStringsToChars(filename),'coverageData');
                pd = propagationData(fileData.coverageData.Data);
                legendTitle = "Power" + newline + "(dBm)";
                contour(pd, "LegendTitle",legendTitle,"Type","custom","Levels",-85:1:-5,"ColorLimits",[-85 -5],"Transparency",0.5,'ValidateColorConflicts',false,'Map',evalin('base', 'viewer_breath'));
                pause(10)
                clearMap(evalin('base', 'viewer_breath'))
                
            else
                uialert(f1,'Modelo errado! Só funciona para freespace!','Erro','Icon','error');
            end
            else
                uialert(f1,'Não foi selecionado um modelo de propagação!','Erro','Icon','error');
            end
        end
    end
