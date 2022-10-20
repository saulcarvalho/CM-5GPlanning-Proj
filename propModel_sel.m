function propModel = propModel_sel(fig)
% INPUTS:
% fig -> figura
% OUTPUTS:
% propModel -> Modelo de Propagação

a = uicontrol(fig,'Style','text','fontweight','bold');
a.Position = [11 990 140 22];
a.String = {' '};
a = uicontrol(fig,'Style','text','fontweight','bold');
a.Position = [0 975 140 22];
a.String = {'Modelo de Propagação'};

c = uicontrol(fig,'Style','slider');       % slider parametros #1
c.Position = [11 960 140 22];
ca = uicontrol(fig,'Style','popupmenu');   % slider parametros #1
ca.Position = [11 960 140 22];
ca.String = {' '};
d = uicontrol(fig,'Style','slider');       % slider parametros #2
d.Position = [11 960 140 22];
da = uicontrol(fig,'Style','popupmenu');   % slider parametros #2
da.Position = [11 960 140 22];
da.String = {' '};
e = uicontrol(fig,'Style','slider');       % slider parametros #3
e.Position = [11 960 140 22];
ea = uicontrol(fig,'Style','popupmenu');   % slider parametros #3
ea.Position = [11 960 140 22];
ea.String = {' '};
f = uicontrol(fig,'Style','slider');       % slider parametros #4
f.Position = [11 960 140 22];
fa = uicontrol(fig,'Style','popupmenu');   % slider parametros #4
fa.Position = [11 960 140 22];
fa.String = {' '};
g = uicontrol(fig,'Style','slider');       % slider parametros #5
g.Position = [11 960 140 22];
h = uicontrol(fig,'Style','slider');       % slider parametros #6
h.Position = [11 960 140 22];
i = uicontrol(fig,'Style','slider');       % slider parametros #7
i.Position = [11 960 140 22];
j = uicontrol(fig,'Style','slider');       % slider parametros #8
j.Position = [11 960 140 22];
k = uicontrol(fig,'Style','slider');       % slider parametros #9
k.Position = [11 960 140 22];
l = uicontrol(fig,'Style','slider');       % slider parametros #10
l.Position = [11 960 140 22];
m = uicontrol(fig,'Style','slider');       % slider parametros #11
m.Position = [11 960 140 22];
n = uicontrol(fig,'Style','slider');       % slider parametros #12
n.Position = [11 960 140 22];
o = uicontrol(fig,'Style','slider');       % slider parametros #13
o.Position = [11 960 140 22];

a = uicontrol(fig,'Style','popupmenu');
a.Position = [11 960 160 22];      % x, y , size_x, size y
a.String = {'- selecionar modelo -','freespace','rain','gas','fog','close-in','longley-rice','tirem','raytracing','log-distance','log-normal','hata'};
a.Tooltip = sprintf(['Permite selecionar o modelo de propagação para todas as funções usadas ao longo do programa.\n\n' ...
    'Os parâmetros para cada modelo devem ser definidos para ser possível criar os respetivos mapas.']);
a.Callback = @cb;

b       = uicontrol(fig,'Style','text');    % texto parametros
p1      = uicontrol(fig,'Style','text');    % texto param #1
p1min   = uicontrol(fig,'Style','text');    % texto param min #1
p1max   = uicontrol(fig,'Style','text');    % texto param max #1
p1value = uicontrol(fig,'Style','text');    % texto param value #1
p2      = uicontrol(fig,'Style','text');    % texto param #2
p2min   = uicontrol(fig,'Style','text');    % texto param min #2
p2max   = uicontrol(fig,'Style','text');    % texto param max #2
p2value = uicontrol(fig,'Style','text');    % texto param value #2
p3      = uicontrol(fig,'Style','text');    % texto param #3
p3min   = uicontrol(fig,'Style','text');    % texto param min #3
p3max   = uicontrol(fig,'Style','text');    % texto param max #3
p3value = uicontrol(fig,'Style','text');    % texto param value #3
p4      = uicontrol(fig,'Style','text');    % texto param #4
p4min   = uicontrol(fig,'Style','text');    % texto param min #4
p4max   = uicontrol(fig,'Style','text');    % texto param max #4
p4value = uicontrol(fig,'Style','text');    % texto param value #4
p5      = uicontrol(fig,'Style','text');    % texto param #5
p5min   = uicontrol(fig,'Style','text');    % texto param min #5
p5max   = uicontrol(fig,'Style','text');    % texto param max #5
p5value = uicontrol(fig,'Style','text');    % texto param value #5
p6      = uicontrol(fig,'Style','text');    % texto param #6
p6min   = uicontrol(fig,'Style','text');    % texto param min #6
p6max   = uicontrol(fig,'Style','text');    % texto param max #6
p6value = uicontrol(fig,'Style','text');    % texto param value #6
p7      = uicontrol(fig,'Style','text');    % texto param #7
p7min   = uicontrol(fig,'Style','text');    % texto param min #7
p7max   = uicontrol(fig,'Style','text');    % texto param max #7
p7value = uicontrol(fig,'Style','text');    % texto param value #7
p8      = uicontrol(fig,'Style','text');    % texto param #8
p8min   = uicontrol(fig,'Style','text');    % texto param min #8
p8max   = uicontrol(fig,'Style','text');    % texto param max #8
p8value = uicontrol(fig,'Style','text');    % texto param value #8
p9      = uicontrol(fig,'Style','text');    % texto param #9
p9min   = uicontrol(fig,'Style','text');    % texto param min #9
p9max   = uicontrol(fig,'Style','text');    % texto param max #9
p9value = uicontrol(fig,'Style','text');    % texto param value #9
p10      = uicontrol(fig,'Style','text');   % texto param #10
p10min   = uicontrol(fig,'Style','text');   % texto param min #10
p10max   = uicontrol(fig,'Style','text');   % texto param max #10
p10value = uicontrol(fig,'Style','text');   % texto param value #10
p11      = uicontrol(fig,'Style','text');   % texto param #11
p11min   = uicontrol(fig,'Style','text');   % texto param min #11
p11max   = uicontrol(fig,'Style','text');   % texto param max #11
p11value = uicontrol(fig,'Style','text');   % texto param value #11
p12      = uicontrol(fig,'Style','text');   % texto param #12
p12min   = uicontrol(fig,'Style','text');   % texto param min #12
p12max   = uicontrol(fig,'Style','text');   % texto param max #12
p12value = uicontrol(fig,'Style','text');   % texto param value #12
p13      = uicontrol(fig,'Style','text');   % texto param #13
p13min   = uicontrol(fig,'Style','text');   % texto param min #13
p13max   = uicontrol(fig,'Style','text');   % texto param max #13
p13value = uicontrol(fig,'Style','text');   % texto param value #13

    function cb(~,~)
        clc;
        delete(b);
        delete(p1);
        delete(p1min);
        delete(p1max);
        delete(p1value);
        delete(p2);
        delete(p2min);
        delete(p2max);
        delete(p2value);
        delete(p3);
        delete(p3min);
        delete(p3max);
        delete(p3value);
        delete(p4);
        delete(p4min);
        delete(p4max);
        delete(p4value);
        delete(p5);
        delete(p5min);
        delete(p5max);
        delete(p5value);
        delete(p6);
        delete(p6min);
        delete(p6max);
        delete(p6value);
        delete(p7);
        delete(p7min);
        delete(p7max);
        delete(p7value);
        delete(p8);
        delete(p8min);
        delete(p8max);
        delete(p8value);
        delete(p9);
        delete(p9min);
        delete(p9max);
        delete(p9value);
        delete(p10);
        delete(p10min);
        delete(p10max);
        delete(p10value);
        delete(p11);
        delete(p11min);
        delete(p11max);
        delete(p11value);
        delete(p12);
        delete(p12min);
        delete(p12max);
        delete(p12value);
        delete(p13);
        delete(p13min);
        delete(p13max);
        delete(p13value);
        delete(c);
        delete(ca);
        delete(d);
        delete(da);
        delete(e);
        delete(ea);
        delete(f);
        delete(fa);
        delete(g);
        delete(h);
        delete(i);
        delete(j);
        delete(k);
        delete(l);
        delete(m);
        delete(n);
        delete(o);
        selString = a.String{a.Value};
        cprintf('*blue', [' > Modelo Propagação: ' selString newline]);

        switch selString
            case {'- selecionar modelo -', 'freespace'}
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

            case 'rain'
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [10 915 90 15];       % x, y , size_x, size y
                p1.String = {'Rain Rate [mm/h]:'};
                p1min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1min.Position = [11 892 10 15];       % x, y , size_x, size y
                p1min.String = {'0'};
                p1max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1max.Position = [171 892 20 15];       % x, y , size_x, size y
                p1max.String = {'300'};
                p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p1value.Position = [100 915 20 15];       % x, y , size_x, size y
                default = 16;
                p1value.String = num2str(default);
                assignin('base','propModel_Rain_RainRate',default);

                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [6 870 70 15];       % x, y , size_x, size y
                p2.String = {'Rain Tilt [º]:'};
                p2min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2min.Position = [11 847 10 15];       % x, y , size_x, size y
                p2min.String = {'0'};
                p2max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2max.Position = [169 847 20 15];       % x, y , size_x, size y
                p2max.String = {'75'};
                p2value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p2value.Position = [70 870 20 15];       % x, y , size_x, size y
                default = 0;
                p2value.String = num2str(default);
                assignin('base','propModel_Rain_Tilt',default);


                c = uicontrol(fig,'Style','slider','SliderStep',[1/300, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider rain rate
                c.Position = [25 890 140 20];            % x, y , size_x, size y
                c.Min = 0;
                c.Value = 16;
                c.Max = 300;
                c.Callback = @cb1;

                d = uicontrol(fig,'Style','slider','SliderStep',[1/75, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);    % slider rain tilt
                d.Position = [25 845 140 20];            % x, y , size_x, size y
                d.Min = 0;
                d.Value = 0;
                d.Max = 75;
                d.Callback = @cb2;

            case 'gas'
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [10 915 90 15];
                p1.String = {'Temperatura [ºC]:'};
                p1min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1min.Position = [10 892 20 15];
                p1min.String = {'-60'};
                p1max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1max.Position = [180 892 20 15];
                p1max.String = {'60'};
                p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p1value.Position = [100 915 20 15];       % x, y , size_x, size y
                default = 15;
                p1value.String = num2str(default);
                assignin('base','propModel_Gas_Temp',default);

                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [8 870 140 15];
                p2.String = {'Pressão Atmosférica [hPa]:'};
                p2min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2min.Position = [10 847 20 15];
                p2min.String = {'870'};
                p2max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2max.Position = [178 847 30 15];
                p2max.String = {'1085'};
                p2value = uicontrol(fig,'Style','text','ForegroundColor', 'blue','fontweight','bold');
                p2value.Position = [145 870 30 15];       % x, y , size_x, size y
                default = 1013;
                p2value.String = num2str(default);
                assignin('base','propModel_Gas_Pres',default*100);

                p3 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3.Position = [10 825 150 15];
                p3.String = {'Densidade Vapor Água [g/m3]:'};
                p3min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3min.Position = [15 802 20 15];
                p3min.String = {'0'};
                p3max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3max.Position = [172 802 30 15];
                p3max.String = {'200'};
                p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                default = 7.5;
                p3value.Position = [160 825 30 15];       % x, y , size_x, size y
                p3value.String = num2str(default);
                assignin('base','propModel_Gas_WaterDens',default);


                c = uicontrol(fig,'Style','slider','SliderStep',[1/120, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);   % slider temperatura
                c.Position = [35 890 140 20];
                c.Min = -60;
                c.Value = 15;
                c.Max = 60;
                c.Callback = @cb1;

                d = uicontrol(fig,'Style','slider','SliderStep',[0.1/21.5, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);   % slider pressao atmosferica
                d.Position = [35 845 140 20];
                d.Min = 87;
                d.Value = 101.3;
                d.Max = 108.5;
                d.Callback = @cb2;

                e = uicontrol(fig,'Style','slider','SliderStep',[1/200, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);   % slider densidade agua
                e.Position = [35 800 140 20];
                e.Min = 0;
                e.Value = 7.5;
                e.Max = 200;
                e.Callback = @cb3;

            case 'fog'
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [10 915 90 15];
                p1.String = {'Temperatura [ºC]:'};
                p1min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1min.Position = [10 892 20 15];
                p1min.String = {'-60'};
                p1max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1max.Position = [180 892 20 15];
                p1max.String = {'60'};
                p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p1value.Position = [100 915 20 15];       % x, y , size_x, size y
                default = 15;
                p1value.String = num2str(default);
                assignin('base','propModel_Gas_Temp',default);

                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [8 870 160 15];
                p2.String = {'Densidade Líquida Água [g/m3]:'};
                p2min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2min.Position = [15 847 20 15];
                p2min.String = {'0'};
                p2max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2max.Position = [180 847 30 15];
                p2max.String = {'7000'};
                p2value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p2value.Position = [160 870 50 15];       % x, y , size_x, size y
                default = 0.5;
                p2value.String = num2str(default);
                assignin('base','propModel_Fog_WaterDens',default);

                c = uicontrol(fig,'Style','slider','SliderStep',[1/120, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);   % slider temperatura
                c.Position = [35 890 140 20];
                c.Min = -60;
                c.Value = 15;
                c.Max = 60;
                c.Callback = @cb1;

                d = uicontrol(fig,'Style','slider','SliderStep',[1/7000, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);   % slider densidade agua
                d.Position = [35 845 140 20];
                d.Min = 0;
                d.Value = 0.5;
                d.Max = 7000;
                d.Callback = @cb2;

            case 'close-in'
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [12 915 120 15];       % x, y , size_x, size y
                p1.String = {'Distância Referência [m]:'};
                p1min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1min.Position = [14 892 20 15];       % x, y , size_x, size y
                p1min.String = {'0'};
                p1max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1max.Position = [174 892 50 15];       % x, y , size_x, size y
                p1max.String = {'100000'};
                p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p1value.Position = [130 915 50 15];       % x, y , size_x, size y
                default = 1;
                p1value.String = num2str(default);
                assignin('base','propModel_CloseIn_DistRef',default);

                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [6 870 180 15];       % x, y , size_x, size y
                p2.String = {'Exponencial Perdas Percurso [dB]:'};
                p2min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2min.Position = [14 847 20 15];       % x, y , size_x, size y
                p2min.String = {'2'};
                p2max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2max.Position = [172 847 30 15];       % x, y , size_x, size y
                p2max.String = {'6'};
                p2value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p2value.Position = [180 870 30 15];       % x, y , size_x, size y
                default = 2.9;
                p2value.String = num2str(default);
                assignin('base','propModel_CloseIn_ExpPL',default);

                p3 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3.Position = [10 825 100 15];       % x, y , size_x, size y
                p3.String = {'Desvio Padrão [dB]:'};
                p3min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3min.Position = [14 802 20 15];       % x, y , size_x, size y
                p3min.String = {'3'};
                p3max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3max.Position = [172 802 30 15];       % x, y , size_x, size y
                p3max.String = {'12'};
                p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p3value.Position = [110 825 30 15];       % x, y , size_x, size y
                default = 5.7;
                p3value.String = num2str(default);
                assignin('base','propModel_CloseIn_Sigma',default);


                c = uicontrol(fig,'Style','slider','SliderStep',[1/100000, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider distancia ref.
                c.Position = [35 890 140 20];            % x, y , size_x, size y
                c.Min = 0;
                c.Value = 1;
                c.Max = 100000;
                c.Callback = @cb1;

                d = uicontrol(fig,'Style','slider','SliderStep',[0.1/4, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);   % slider exp. perdas percurso
                d.Position = [35 845 140 20];            % x, y , size_x, size y
                d.Min = 2;
                d.Value = 2.9;
                d.Max = 6;
                d.Callback = @cb2;

                e = uicontrol(fig,'Style','slider','SliderStep',[0.1/9, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider desvio padrao
                e.Position = [35 800 140 20];            % x, y , size_x, size y
                e.Min = 3;
                e.Value = 5.7;
                e.Max = 12;
                e.Callback = @cb3;

            case 'longley-rice'
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [2 915 115 15];       % x, y , size_x, size y
                p1.String = {'Polarização Antena:'};

                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [4 870 90 15];       % x, y , size_x, size y
                p2.String = {'Zona Climática:'};

                p3 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3.Position = [10 825 150 15];       % x, y , size_x, size y
                p3.String = {'Condutividade da terra [mS/m]:'};
                p3min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3min.Position = [12 802 20 15];       % x, y , size_x, size y
                p3min.String = {'0.5'};
                p3max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3max.Position = [172 802 30 15];       % x, y , size_x, size y
                p3max.String = {'30'};
                p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p3value.Position = [160 825 30 15];       % x, y , size_x, size y
                default = 5;
                p3value.String = num2str(default);
                assignin('base','propModel_LongleyRice_GroundCondutivity',default/1000);

                p4 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p4.Position = [6 780 160 15];       % x, y , size_x, size y
                p4.String = {'Permitividade Relativa da terra:'};
                p4min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p4min.Position = [14 757 20 15];       % x, y , size_x, size y
                p4min.String = {'1'};
                p4max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p4max.Position = [174 757 30 15];       % x, y , size_x, size y
                p4max.String = {'100'};
                p4value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p4value.Position = [160 780 30 15];       % x, y , size_x, size y
                default = 15;
                p4value.String = num2str(default);
                assignin('base','propModel_LongleyRice_GroundPermittivity',default);

                p5 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5.Position = [7 735 190 15];       % x, y , size_x, size y
                p5.String = {'Refratividade Atmosférica da terra [N]:'};
                p5min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5min.Position = [12 712 20 15];       % x, y , size_x, size y
                p5min.String = {'200'};
                p5max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5max.Position = [174 712 30 15];       % x, y , size_x, size y
                p5max.String = {'450'};
                p5value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p5value.Position = [195 735 30 15];       % x, y , size_x, size y
                default = 301;
                p5value.String = num2str(default);
                assignin('base','propModel_LongleyRice_AtmosphericRefractivity',default);

                p6 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p6.Position = [8 690 180 15];       % x, y , size_x, size y
                p6.String = {'Tolerância Variabilidade de Tempo:'};
                p6min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p6min.Position = [4 667 30 15];       % x, y , size_x, size y
                p6min.String = {'0.001'};
                p6max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p6max.Position = [178 667 30 15];       % x, y , size_x, size y
                p6max.String = {'0.999'};
                p6value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p6value.Position = [190 690 30 15];       % x, y , size_x, size y
                default = 0.5;
                p6value.String = num2str(default);
                assignin('base','propModel_LongleyRice_TimeTolVar',default);

                p7 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p7.Position = [12 647 180 15];       % x, y , size_x, size y
                p7.String = {'Tolerância Variabilidade de Situação:'};
                p7min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p7min.Position = [4 626 30 15];       % x, y , size_x, size y
                p7min.String = {'0.001'};
                p7max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p7max.Position = [178 626 30 15];       % x, y , size_x, size y
                p7max.String = {'0.999'};
                p7value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p7value.Position = [190 647 30 15];       % x, y , size_x, size y
                default = 0.5;
                p7value.String = num2str(default);
                assignin('base','propModel_LongleyRice_SituationTolVar',default);


                ca = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');  % slider polarizacao antena
                ca.Position = [10 890 160 20];            % x, y , size_x, size y
                ca.String = {'- selecionar polarização -','horizontal','vertical'};
                ca.Value = 2;
                assignin('base','propModel_LongleyRice_PolAnt','horizontal');
                ca.Callback = @cb1;

                da = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');   % slider zona climatica
                da.Position = [10 845 160 20];            % x, y , size_x, size y
                da.String = {'- selecionar clima -','continental-temperate','equatorial','continental-subtropical','maritime-subtropical','desert','maritime-over-land','maritime-over-sea'};
                da.Value = 2;
                assignin('base','propModel_LongleyRice_Climate','continental-temperate');
                da.Callback = @cb2;

                e = uicontrol(fig,'Style','slider','SliderStep',[0.1/29.5, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider condutividade terra
                e.Position = [35 800 140 20];            % x, y , size_x, size y
                e.Min = 0.5; % [mS/m]  -> 0.0005
                e.Value = 5;
                e.Max = 30;
                e.Callback = @cb3;

                f = uicontrol(fig,'Style','slider','SliderStep',[1/99, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider permitividade relativa terra
                f.Position = [35 755 140 20];            % x, y , size_x, size y
                f.Min = 1;
                f.Value = 15;
                f.Max = 100;
                f.Callback = @cb4;

                g = uicontrol(fig,'Style','slider','SliderStep',[0.1/25, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider refratividade atmosférica terra
                g.Position = [35 710 140 20];            % x, y , size_x, size y
                g.Min = 20;    % -> 200
                g.Value = 30.1;
                g.Max = 45;    % -> 450
                g.Callback = @cb5;

                h = uicontrol(fig,'Style','slider','SliderStep',[0.1/0.998, 0.01],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider tolerância de variabilidade de tempo
                h.Position = [35 665 140 20];            % x, y , size_x, size y
                h.Min = 0.001;
                h.Value = 0.5;
                h.Max = 0.999;
                h.Callback = @cb6;

                i = uicontrol(fig,'Style','slider','SliderStep',[0.1/0.998, 0.01],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider tolerância de variabilidade de situação
                i.Position = [35 625 140 20];            % x, y , size_x, size y
                i.Min = 0.001;
                i.Value = 0.5;
                i.Max = 0.999;
                i.Callback = @cb7;

            case 'tirem'
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [2 915 115 15];       % x, y , size_x, size y
                p1.String = {'Polarização Antena:'};

                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [4 870 160 15];       % x, y , size_x, size y
                p2.String = {'Humidade Absoluta Ar [g/m3]:'};
                p2min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2min.Position = [16 847 20 15];       % x, y , size_x, size y
                p2min.String = {'0'};
                p2max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2max.Position = [174 847 30 15];       % x, y , size_x, size y
                p2max.String = {'110'};
                p2value = uicontrol(fig,'Style','text','ForegroundColor', 'blue','fontweight','bold');
                p2value.Position = [155 870 30 15];       % x, y , size_x, size y
                default = 9;
                p2value.String = num2str(default);
                assignin('base','propModel_TIREM_HumAbs',default);

                p3 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3.Position = [10 825 150 15];       % x, y , size_x, size y
                p3.String = {'Condutividade da terra [mS/m]:'};
                p3min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3min.Position = [12 802 20 15];       % x, y , size_x, size y
                p3min.String = {'0.5'};
                p3max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3max.Position = [172 802 30 15];       % x, y , size_x, size y
                p3max.String = {'30'};
                p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p3value.Position = [160 825 30 15];       % x, y , size_x, size y
                default = 5;
                p3value.String = num2str(default);
                assignin('base','propModel_TIREM_GroundCondutivity',default/1000);

                p4 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p4.Position = [6 780 160 15];       % x, y , size_x, size y
                p4.String = {'Permitividade Relativa da terra:'};
                p4min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p4min.Position = [14 757 20 15];       % x, y , size_x, size y
                p4min.String = {'1'};
                p4max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p4max.Position = [174 757 30 15];       % x, y , size_x, size y
                p4max.String = {'100'};
                p4value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p4value.Position = [160 780 30 15];       % x, y , size_x, size y
                default = 15;
                p4value.String = num2str(default);
                assignin('base','propModel_TIREM_GroundPermitivity',default);

                p5 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5.Position = [7 735 190 15];       % x, y , size_x, size y
                p5.String = {'Refratividade Atmosférica da terra [N]:'};
                p5min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5min.Position = [12 712 20 15];       % x, y , size_x, size y
                p5min.String = {'200'};
                p5max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5max.Position = [174 712 30 15];       % x, y , size_x, size y
                p5max.String = {'450'};
                p5value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p5value.Position = [195 735 30 15];       % x, y , size_x, size y
                default = 301;
                p5value.String = num2str(default);
                assignin('base','propModel_TIREM_AtmosphericRefractivity',default);


                ca = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');  % slider polarizacao antena
                ca.Position = [10 890 160 20];            % x, y , size_x, size y
                ca.String = {'- selecionar polarização -','horizontal','vertical'};
                ca.Value = 2;
                assignin('base','propModel_TIREM_PolAnt','horizontal');
                ca.Callback = @cb1;

                d = uicontrol(fig,'Style','slider','SliderStep',[1/110, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);   % humidade absoluta ar
                d.Position = [35 845 140 20];            % x, y , size_x, size y
                d.Min = 0;
                d.Value = 9;
                d.Max = 110;
                d.Callback = @cb2;

                e = uicontrol(fig,'Style','slider','SliderStep',[0.1/29.5, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider condutividade terra
                e.Position = [35 800 140 20];            % x, y , size_x, size y
                e.Min = 0.5; % [mS/m]  -> 0.0005
                e.Value = 5;
                e.Max = 30;
                e.Callback = @cb3;

                f = uicontrol(fig,'Style','slider','SliderStep',[1/99, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider permitividade relativa terra
                f.Position = [35 755 140 20];            % x, y , size_x, size y
                f.Min = 1;
                f.Value = 15;
                f.Max = 100;
                f.Callback = @cb4;

                g = uicontrol(fig,'Style','slider','SliderStep',[0.1/25, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % slider refratividade atmosférica terra
                g.Position = [35 710 140 20];            % x, y , size_x, size y
                g.Min = 20;    % -> 200
                g.Value = 30.1;
                g.Max = 45;    % -> 450
                g.Callback = @cb5;

            case 'raytracing'
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [4 915 100 15];       % x, y , size_x, size y
                p1.String = {'Material Edíficios:'};

                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [4 870 100 15];       % x, y , size_x, size y
                p2.String = {'Material Terreno:'};

                p3 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p3.Position = [8 825 50 15];       % x, y , size_x, size y
                p3.String = {'Método:'};

                p4 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p4.Position = [8 780 100 15];       % x, y , size_x, size y
                p4.String = {'Ângulo Separação:'};

                p5 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5.Position = [7 735 140 15];       % x, y , size_x, size y
                p5.String = {'Número Máximo Reflexões:'};
                p5min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5min.Position = [12 712 20 15];       % x, y , size_x, size y
                p5min.String = {'0'};
                p5max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p5max.Position = [174 712 30 15];       % x, y , size_x, size y
                p5max.String = {'10'};
                p5value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p5value.Position = [145 735 30 15];       % x, y , size_x, size y
                default = 2;
                p5value.String = num2str(default);
                assignin('base','propModel_RayTrac_MaxNumReflections',default);

                p6 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p6.Position = [8 690 160 15];       % x, y , size_x, size y
                p6.String = {'Permitividade Material Edíficios:'};
                p6min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p6min.Position = [4 667 30 15];       % x, y , size_x, size y
                p6min.String = {'1'};
                p6max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p6max.Position = [178 667 30 15];       % x, y , size_x, size y
                p6max.String = {'100'};
                p6value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p6value.Position = [165 690 30 15];       % x, y , size_x, size y
                default = 5.31;
                p6value.String = num2str(default);
                assignin('base','propModel_RayTrac_PermitivityMatBuilding',default);

                p7 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p7.Position = [8 645 200 15];       % x, y , size_x, size y
                p7.String = {'Condutividade Material Edíficios [mS/m]:'};
                p7min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p7min.Position = [4 622 30 15];       % x, y , size_x, size y
                p7min.String = {'0.5'};
                p7max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p7max.Position = [178 622 30 15];       % x, y , size_x, size y
                p7max.String = {'30'};
                p7value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p7value.Position = [205 645 30 15];       % x, y , size_x, size y
                default = 5.48;
                p7value.String = num2str(default);
                assignin('base','propModel_RayTrac_CondutivityMatBuilding',default/1000);

                p8 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p8.Position = [6 600 160 15];       % x, y , size_x, size y
                p8.String = {'Permitividade Material Terreno:'};
                p8min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p8min.Position = [4 576 30 15];       % x, y , size_x, size y
                p8min.String = {'1'};
                p8max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p8max.Position = [178 576 30 15];       % x, y , size_x, size y
                p8max.String = {'100'};
                p8value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p8value.Position = [165 600 30 15];       % x, y , size_x, size y
                default = 5.31;
                p8value.String = num2str(default);
                assignin('base','propModel_RayTrac_PermitivityMatTerrain',default);

                p9 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p9.Position = [10 555 190 15];       % x, y , size_x, size y
                p9.String = {'Condutividade Material Terreno [mS/m]:'};
                p9min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p9min.Position = [4 530 30 15];       % x, y , size_x, size y
                p9min.String = {'0.5'};
                p9max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p9max.Position = [178 530 30 15];       % x, y , size_x, size y
                p9max.String = {'30'};
                p9value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p9value.Position = [205 555 30 15];       % x, y , size_x, size y
                default = 5.48;
                p9value.String = num2str(default);
                assignin('base','propModel_RayTrac_CondutivityMatTerrain',default/1000);


                ca = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');  %
                ca.Position = [10 890 160 20];            % x, y , size_x, size y
                ca.String = {'- selecionar material -','concrete','perfect-reflector','brick','wood','glass','metal'};
                ca.Value = 2;
                assignin('base','propModel_RayTrac_MatBuild','concrete');
                ca.Callback = @cb1;

                da = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');   %
                da.Position = [10 845 160 20];            % x, y , size_x, size y
                da.String = {'- selecionar material -','concrete','perfect-reflector','brick','water','desert','vegetation','loam'};
                da.Value = 2;
                assignin('base','propModel_RayTrac_MatTerr','concrete');
                da.Callback = @cb2;

                ea = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');   %
                ea.Position = [10 800 160 20];            % x, y , size_x, size y
                ea.String = {'- selecionar método -','sbr','image'};
                ea.Value = 2;
                assignin('base','propModel_RayTrac_Method','sbr');
                ea.Callback = @cb3;

                fa = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');   %
                fa.Position = [10 755 160 20];            % x, y , size_x, size y
                fa.String = {'- selecionar ângulo -','low','medium','high'};
                fa.Value = 3;
                assignin('base','propModel_RayTrac_SeparationAngle','medium');
                fa.Callback = @cb4;

                g = uicontrol(fig,'Style','slider','SliderStep',[1/11, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  % nº max reflexões
                g.Position = [35 710 140 20];            % x, y , size_x, size y
                g.Min = 0;
                g.Value = 2;
                g.Max = 10;
                g.Callback = @cb5;

                h = uicontrol(fig,'Style','slider','SliderStep',[0.1/99, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  %
                h.Position = [35 665 140 20];            % x, y , size_x, size y
                h.Min = 1;
                h.Value = 5.31;
                h.Max = 100;
                h.Callback = @cb6;

                i = uicontrol(fig,'Style','slider','SliderStep',[0.1/29.5, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  %
                i.Position = [35 620 140 20];            % x, y , size_x, size y
                i.Min = 0.5;
                i.Value = 5.48;
                i.Max = 30;
                i.Callback = @cb7;

                j = uicontrol(fig,'Style','slider','SliderStep',[0.1/99, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  %
                j.Position = [35 575 140 20];            % x, y , size_x, size y
                j.Min = 1;
                j.Value = 5.31;
                j.Max = 100;
                j.Callback = @cb8;

                k = uicontrol(fig,'Style','slider','SliderStep',[0.1/29.5, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]);  %
                k.Position = [35 530 140 20];            % x, y , size_x, size y
                k.Min = 0.5;
                k.Value = 5.48;
                k.Max = 30;
                k.Callback = @cb9;

            case {'log-distance'}
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [12 915 140 15];       % x, y , size_x, size y
                p1.String = {'Exp. Perdas de Percurso:'};
                p1min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1min.Position = [14 892 20 15];       % x, y , size_x, size y
                p1min.String = {'2'};
                p1max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1max.Position = [174 892 30 15];       % x, y , size_x, size y
                p1max.String = {'6'};
                p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p1value.Position = [150 915 30 15];       % x, y , size_x, size y
                default = 2;
                p1value.String = num2str(default);
                assignin('base','propModel_LogDistance_PathLossExp',default);

                c = uicontrol(fig,'Style','slider','SliderStep',[1/40, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]); 
                c.Position = [35 890 140 20];            % x, y , size_x, size y
                c.Min = 2;
                c.Value = 2;
                c.Max = 6;
                c.Callback = @cb1;


            case {'log-normal'}
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_Hata_AreaType' );

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [12 915 140 15];       % x, y , size_x, size y
                p1.String = {'Exp. Perdas de Percurso:'};
                p1min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1min.Position = [14 892 20 15];       % x, y , size_x, size y
                p1min.String = {'2'};
                p1max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1max.Position = [174 892 30 15];       % x, y , size_x, size y
                p1max.String = {'6'};
                p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
                p1value.Position = [150 915 30 15];       % x, y , size_x, size y
                default = 2;
                p1value.String = num2str(default);
                assignin('base','propModel_LogNormal_PathLossExp',default);
                
                p2 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2.Position = [4 870 80 15];       % x, y , size_x, size y
                p2.String = {'Variância:'};
                p2min = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2min.Position = [16 847 20 15];       % x, y , size_x, size y
                p2min.String = {'0'};
                p2max = uicontrol(fig,'Style','text','ForegroundColor','black');
                p2max.Position = [174 847 30 15];       % x, y , size_x, size y
                p2max.String = {'100'};
                p2value = uicontrol(fig,'Style','text','ForegroundColor', 'blue','fontweight','bold');
                p2value.Position = [80 870 30 15];       % x, y , size_x, size y
                default = 0;
                p2value.String = num2str(default);
                assignin('base','propModel_LogNormal_Variance',default);

                c = uicontrol(fig,'Style','slider','SliderStep',[1/40, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]); 
                c.Position = [35 890 140 20];            % x, y , size_x, size y
                c.Min = 2;
                c.Value = 2;
                c.Max = 6;
                c.Callback = @cb1;
                
                d = uicontrol(fig,'Style','slider','SliderStep',[1/1000, 0.1],'BackgroundColor',[0.3686 0.3686 0.3686]); 
                d.Position = [35 845 140 20];            % x, y , size_x, size y
                d.Min = 0;
                d.Value = 0;
                d.Max = 100;
                d.Callback = @cb2;


            case {'hata'}
                evalin( 'base', 'clear propModel_Rain_RainRate' );
                evalin( 'base', 'clear propModel_Rain_Tilt' );
                evalin( 'base', 'clear propModel_Gas_Temp' );
                evalin( 'base', 'clear propModel_Gas_Pres' );
                evalin( 'base', 'clear propModel_Gas_WaterDens' );
                evalin( 'base', 'clear propModel_Fog_Temp' );
                evalin( 'base', 'clear propModel_Fog_WaterDens' );
                evalin( 'base', 'clear propModel_CloseIn_DistRef' );
                evalin( 'base', 'clear propModel_CloseIn_ExpPL' );
                evalin( 'base', 'clear propModel_CloseIn_Sigma' );
                evalin( 'base', 'clear propModel_LongleyRice_PolAnt' );
                evalin( 'base', 'clear propModel_LongleyRice_Climate' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundCondutivity' );
                evalin( 'base', 'clear propModel_LongleyRice_GroundPermittivity' );
                evalin( 'base', 'clear propModel_LongleyRice_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_LongleyRice_TimeTolVar' );
                evalin( 'base', 'clear propModel_LongleyRice_SituationTolVar' );
                evalin( 'base', 'clear propModel_TIREM_PolAnt' );
                evalin( 'base', 'clear propModel_TIREM_HumAbs' );
                evalin( 'base', 'clear propModel_TIREM_GroundCondutivity' );
                evalin( 'base', 'clear propModel_TIREM_GroundPermitivity' );
                evalin( 'base', 'clear propModel_TIREM_AtmosphericRefractivity' );
                evalin( 'base', 'clear propModel_RayTrac_MatBuild' );
                evalin( 'base', 'clear propModel_RayTrac_MatTerr' );
                evalin( 'base', 'clear propModel_RayTrac_Method' );
                evalin( 'base', 'clear propModel_RayTrac_SeparationAngle' );
                evalin( 'base', 'clear propModel_RayTrac_MaxNumReflections' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatBuilding' );
                evalin( 'base', 'clear propModel_RayTrac_PermitivityMatTerrain' );
                evalin( 'base', 'clear propModel_RayTrac_CondutivityMatTerrain' );
                evalin( 'base', 'clear propModel_LogDistance_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_PathLossExp' );
                evalin( 'base', 'clear propModel_LogNormal_Variance' );
                

                b = uicontrol(fig,'Style','text','ForegroundColor','magenta','fontweight','bold');
                b.Position = [8 935 70 15];       % x, y , size_x, size y
                b.String = {'Parâmetros:'};
                p1 = uicontrol(fig,'Style','text','ForegroundColor','black');
                p1.Position = [8 915 60 15];       % x, y , size_x, size y
                p1.String = {'Tipo Área:'};
                
                ca = uicontrol(fig,'Style','popupmenu','BackgroundColor',[0.3686 0.3686 0.3686],'ForegroundColor','white');  %
                ca.Position = [10 890 160 20];            % x, y , size_x, size y
                ca.String = {'- selecionar tipo área -','Urbana','Suburbana','Rural'};
                ca.Value = 2;
                assignin('base','propModel_Hata_AreaType','Urbana');
                ca.Callback = @cb1;


            otherwise
                fprintf([' > «!» Modelo de propagação não reconhecido «!»' newline]);
        end
        assignin('base','propModel',selString);
    end

    function cb1(~,~)
        delete(p1value);
        model   = a.String{a.Value};
        if strcmpi(model, "longley-rice") || strcmpi(model, "tirem") || strcmpi(model, "raytracing") || strcmpi(model, "hata")
            string1 = ca.String{ca.Value};
        else
            value   = round(c.Value,0); % to integer
            value2  = round(c.Value,1); % to float .1
        end

        if strcmpi(model, "rain") % rain rate
            fprintf(['     -> Rain Rate:   ' num2str(value) ' mm/h']);
            if c.Value >= 0 && c.Value < 2.5
                fprintf([' (Light Rain)' newline]);
            elseif  c.Value >= 2.5 && c.Value < 10
                fprintf([' (Moderate Rain)' newline]);
            elseif  c.Value >= 10 && c.Value < 50
                fprintf([' (Heavy Rain)' newline]);
            elseif  c.Value > 50 && c.Value <= 300
                fprintf([' (Violent Rain)' newline]);
            else
                fprintf([' > «!» Parâmatro RainRate não reconhecido «!»' newline])
            end

            p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p1value.Position = [100 915 20 15];       % x, y , size_x, size y
            p1value.String = num2str(value);
            assignin('base','propModel_Rain_RainRate',value);

        elseif strcmpi(model, "gas") % temperatura gas
            fprintf(['     -> Temperatura:           ' num2str(value) ' ºC' newline]);
            p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p1value.Position = [100 915 20 15];       % x, y , size_x, size y
            p1value.String = num2str(value);
            assignin('base','propModel_Gas_Temp',value);

        elseif strcmpi(model, "fog") % temperatura fog
            fprintf(['     -> Temperatura:      ' num2str(value) ' ºC' newline]);
            p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p1value.Position = [100 915 20 15];       % x, y , size_x, size y
            p1value.String = num2str(value);
            assignin('base','propModel_Fog_Temp',value);

        elseif strcmpi(model, "close-in") % distancia seguranca
            fprintf(['     -> Distância Referência:          ' num2str(value) ' m' newline]);
            p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p1value.Position = [130 915 50 15];       % x, y , size_x, size y
            p1value.String = num2str(value);
            assignin('base','propModel_CloseIn_DistRef',value);

        elseif strcmpi(model, "longley-rice") % Polarizacao antena longley-rice
            if strcmpi(string1, "- selecionar polarização -") ~= 1 %
                fprintf(['     -> Polarização Antena:                         ' string1 newline]);
                assignin('base','propModel_LongleyRice_PolAnt',string1);
            end

        elseif strcmpi(model, "tirem") % Polarizacao antena tirem
            if strcmpi(string1, "- selecionar polarização -") ~= 1 %
                fprintf(['     -> Polarização Antena:     ' string1 newline]);
                assignin('base','propModel_TIREM_PolAnt',string1);
            end

        elseif strcmpi(model, "raytracing") %
            if strcmpi(string1, "- selecionar material -") ~= 1 %
                fprintf(['     -> Material Edíficios:                   ' string1 newline]);
                assignin('base','propModel_RayTrac_MatBuild',string1);
            end

        elseif strcmpi(model, "log-distance") %
            fprintf(['     -> Exp. Perdas Percurso:          ' num2str(value2) ' m' newline]);
            p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p1value.Position = [150 915 30 15];       % x, y , size_x, size y
            p1value.String = num2str(value2);
            assignin('base','propModel_LogDistance_PathLossExp',value2);

        elseif strcmpi(model, "log-normal") %
            fprintf(['     -> Exp. Perdas Percurso:          ' num2str(value2) newline]);
            p1value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p1value.Position = [150 915 30 15];       % x, y , size_x, size y
            p1value.String = num2str(value2);
            assignin('base','propModel_LogNormal_PathLossExp',value2);

        elseif strcmpi(model, "hata") %
            if strcmpi(string1, "- selecionar tipo área -") ~= 1 %
                fprintf(['     -> Tipo Área:                   ' string1 newline]);
                assignin('base','propModel_Hata_AreaType',string1);
            end
        end
    end

    function cb2(~,~)
        delete(p2value);
        model  = a.String{a.Value};
        if strcmpi(model, "longley-rice") || strcmpi(model, "raytracing")
            string1 = da.String{da.Value};
        else
            value  = round(d.Value,0); % to integer
            value2 = round(d.Value,1); % to float .1
        end

        if strcmpi(model, "rain") % rain tilt
            fprintf(['     -> Rain Tilt:   ' num2str(value) ' º' newline]);
            p2value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p2value.Position = [70 870 20 15];       % x, y , size_x, size y
            p2value.String = num2str(value);
            assignin('base','propModel_Rain_Tilt',value);

        elseif strcmpi(model, "gas") % pressao atmosferica
            fprintf(['     -> Pressão Atmosférica:   ' num2str(value2*10) ' hPa' newline]);
            p2value = uicontrol(fig,'Style','text','ForegroundColor', 'blue','fontweight','bold');
            p2value.Position = [145 870 30 15];       % x, y , size_x, size y
            p2value.String = num2str(value2*10);
            assignin('base','propModel_Gas_Pres',value2*1000);

        elseif strcmpi(model, "fog") % densidade agua fog
            fprintf(['     -> Densidade Líquida Água:   ' num2str(value2) ' g/m3' newline]);
            p2value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p2value.Position = [160 870 50 15];       % x, y , size_x, size y
            p2value.String = num2str(value2);
            assignin('base','propModel_Fog_WaterDens',value2);

        elseif strcmpi(model, "close-in") % exponencial de perda percurso
            fprintf(['     -> Exponencial Perdas Percurso:   ' num2str(value2) ' dB' newline]);
            p2value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p2value.Position = [180 870 30 15];       % x, y , size_x, size y
            p2value.String = num2str(value2);
            assignin('base','propModel_CloseIn_ExpPL',value2);

        elseif strcmpi(model, "longley-rice") % zona climatica longley-rice
            if strcmpi(string1, "- selecionar clima -") ~= 1 %
                fprintf(['     -> Zona Climática:                             ' string1 newline]);
                assignin('base','propModel_LongleyRice_Climate',string1);
            end

        elseif strcmpi(model, "tirem") %
            fprintf(['     -> Humidade Absoluta Ar:   ' num2str(value) ' hPa' newline]);
            p2value = uicontrol(fig,'Style','text','ForegroundColor', 'blue','fontweight','bold');
            p2value.Position = [155 870 30 15];       % x, y , size_x, size y
            p2value.String = num2str(value);
            assignin('base','propModel_TIREM_HumAbs',value);

        elseif strcmpi(model, "raytracing") %
            if strcmpi(string1, "- selecionar material -") ~= 1 %
                fprintf(['     -> Material Terreno:                     ' string1 newline]);
                assignin('base','propModel_RayTrac_MatTerr',string1);
            end
        elseif strcmpi(model, "log-normal") %
            fprintf(['     -> Variância:   ' num2str(value2) newline]);
            p2value = uicontrol(fig,'Style','text','ForegroundColor', 'blue','fontweight','bold');
            p2value.Position = [80 870 30 15];       % x, y , size_x, size y
            p2value.String = num2str(value2);
            assignin('base','propModel_LogNormal_Variance',value2);
        end
    end

    function cb3(~,~)
        delete(p3value);
        model  = a.String{a.Value};
        if strcmpi(model, "raytracing")
            string1 = ea.String{ea.Value};
        else
            value  = round(e.Value,0); % to integer
            value2 = round(e.Value,1); % to float .1
        end

        if strcmpi(model, "gas") % densidade agua
            fprintf(['     -> Densidade Vapor Água:        ' num2str(value) ' g/m3' newline]);
            p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p3value.Position = [160 825 30 15];       % x, y , size_x, size y
            p3value.String = num2str(value);
            assignin('base','propModel_Gas_WaterDens',value);

        elseif strcmpi(model, "close-in") % desvio padrao
            fprintf(['     -> Desvio Padrão:          ' num2str(value2) ' dB' newline]);
            p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p3value.Position = [110 825 30 15];       % x, y , size_x, size y
            p3value.String = num2str(value2);
            assignin('base','propModel_CloseIn_Sigma',value2);

        elseif strcmpi(model, "longley-rice") % condutividade terra
            fprintf(['     -> Condutividade da terra:                     ' num2str(value2) ' mS/m' newline]);
            p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p3value.Position = [160 825 30 15];       % x, y , size_x, size y
            p3value.String = num2str(value2);
            assignin('base','propModel_LongleyRice_GroundCondutivity',value2/1000);

        elseif strcmpi(model, "tirem") % condutividade terra
            fprintf(['     -> Condutividade da terra:                     ' num2str(value2) ' mS/m' newline]);
            p3value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p3value.Position = [160 825 30 15];       % x, y , size_x, size y
            p3value.String = num2str(value2);
            assignin('base','propModel_TIREM_GroundCondutivity',value2/1000);

        elseif strcmpi(model, "raytracing") %
            if strcmpi(string1, "- selecionar método -") ~= 1 %
                fprintf(['     -> Método:                               ' string1 newline]);
                assignin('base','propModel_RayTrac_Method',string1);
            end
        end
    end

    function cb4(~,~)
        delete(p4value);
        model  = a.String{a.Value};
        if strcmpi(model, "raytracing")
            string1 = fa.String{fa.Value};
        else
            value  = round(f.Value,0); % to integer
            value2 = round(f.Value,1); % to float .1
        end

        if strcmpi(model, "longley-rice") % «
            fprintf(['     -> Permitividade Relativa da terra:            ' num2str(value) newline]);
            p4value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p4value.Position = [160 780 30 15];       % x, y , size_x, size y
            p4value.String = num2str(value);
            assignin('base','propModel_LongleyRice_GroundPermittivity',value);

        elseif strcmpi(model, "tirem") % «
            fprintf(['     -> Permitividade Relativa da terra:            ' num2str(value) newline]);
            p4value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p4value.Position = [160 780 30 15];       % x, y , size_x, size y
            p4value.String = num2str(value);
            assignin('base','propModel_TIREM_GroundPermitivity',value);

        elseif strcmpi(model, "raytracing") %
            if strcmpi(string1, "- selecionar ângulo -") ~= 1 %
                fprintf(['     -> Ângulo Separação:                     ' string1 newline]);
                assignin('base','propModel_RayTrac_SeparationAngle',string1);
            end
        end
    end

    function cb5(~,~)
        delete(p5value);
        model  = a.String{a.Value};
        value  = round(g.Value,0); % to integer
        value2 = round(g.Value,1); % to float .1

        if strcmpi(model, "longley-rice") % «
            fprintf(['     -> Refratividade Atmosférica da terra:         ' num2str(value2*10) ' N' newline]);
            p5value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p5value.Position = [195 735 30 15];       % x, y , size_x, size y
            p5value.String = num2str(value2*10);
            assignin('base','propModel_LongleyRice_AtmosphericRefractivity',value2*10);

        elseif strcmpi(model, "tirem") % «
            fprintf(['     -> Refratividade Atmosférica da terra:         ' num2str(value2*10) ' N' newline]);
            p5value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p5value.Position = [195 735 30 15];       % x, y , size_x, size y
            p5value.String = num2str(value2*10);
            assignin('base','propModel_TIREM_AtmosphericRefractivity',value2*10);

        elseif strcmpi(model, "raytracing") % «
            fprintf(['     -> Número Máximo Reflexões:              ' num2str(value) newline]);
            p5value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p5value.Position = [145 735 30 15];       % x, y , size_x, size y
            p5value.String = num2str(value);
            assignin('base','propModel_RayTrac_MaxNumReflections',value);

        end
    end

    function cb6(~,~)
        delete(p6value);
        model  = a.String{a.Value};
        value  = round(h.Value,0); % to integer
        value2 = round(h.Value,1); % to float .1
        value3 = round(h.Value,3); % to float .001

        if strcmpi(model, "longley-rice") % desvio padrao
            fprintf(['     -> Tolerância Variabilidade de Tempo:          ' num2str(value3) newline]);
            p6value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p6value.Position = [190 690 30 15];       % x, y , size_x, size y
            p6value.String = num2str(value3);
            assignin('base','propModel_LongleyRice_TimeTolVar',value3);

        elseif strcmpi(model, "raytracing") % «
            fprintf(['     -> Permitividade Material Edíficios:     ' num2str(value2) newline]);
            p6value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p6value.Position = [165 690 30 15];       % x, y , size_x, size y
            p6value.String = num2str(value2);
            assignin('base','propModel_RayTrac_PermitivityMatBuilding',value2);

        end

    end

    function cb7(~,~)
        delete(p7value);
        model  = a.String{a.Value};
        value  = round(i.Value,0); % to integer
        value2 = round(i.Value,1); % to float .1
        value3 = round(i.Value,3); % to float .001

        if strcmpi(model, "longley-rice") % «
            fprintf(['     -> Tolerância Variabilidade de Situação:       ' num2str(value3) newline]);
            p7value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p7value.Position = [190 647 30 15];       % x, y , size_x, size y
            p7value.String = num2str(value3);
            assignin('base','propModel_LongleyRice_SituationTolVar',value3);

        elseif strcmpi(model, "raytracing") % «
            fprintf(['     -> Condutividade Material Edíficios:     ' num2str(value2) ' mS/m' newline]);
            p7value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p7value.Position = [205 645 30 15];       % x, y , size_x, size y
            p7value.String = num2str(value2);
            assignin('base','propModel_RayTrac_CondutivityMatBuilding',value2/1000);

        end
    end

    function cb8(~,~)
        delete(p8value);
        model  = a.String{a.Value};
        value  = round(j.Value,0); % to integer
        value2 = round(j.Value,1); % to float .1

        if strcmpi(model, "raytracing") % «
            fprintf(['     -> Permitividade Material Terreno:       ' num2str(value2) newline]);
            p8value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p8value.Position = [165 600 30 15];       % x, y , size_x, size y
            p8value.String = num2str(value2);
            assignin('base','propModel_RayTrac_PermitivityMatTerrain',value2);

        end
    end

    function cb9(~,~)
        delete(p9value);
        model  = a.String{a.Value};
        value  = round(k.Value,0); % to integer
        value2 = round(k.Value,1); % to float .1

        if strcmpi(model, "raytracing") % «
            fprintf(['     -> Condutividade Material Terreno:       ' num2str(value2) ' mS/m' newline]);
            p9value = uicontrol(fig,'Style','text','ForegroundColor','blue','fontweight','bold');
            p9value.Position = [205 555 30 15];       % x, y , size_x, size y
            p9value.String = num2str(value2);
            assignin('base','propModel_RayTrac_CondutivityMatTerrain',value2/1000);

        end
    end

end