function helpSim(f)
% INPUTS:
% f -> figura
a = uicontrol(f,'Style','text','fontweight','bold');
a.Position = [11 990 140 22];
a.String = {' '};
a = uicontrol(f,'Style','text','fontweight','bold');
a.Position = [0 975 140 22];       % x, y , size_x, size y
a.String = {'Modelo de Propagação'};

pos1 = [
    [11 960 420 22]
    [11 945 420 22]
    [11 930 420 22]
    [11 915 420 22]
    [11 900 420 22]
    [11 885 420 22]
    [10 855 420 22]
    [11 825 330 22]
    ];
str1 = [
    {'- Modelo FreeSpace '};
    {'- Modelo Rain'};
    {'- Modelo Gas'};
    {'- Modelo Fog'};
    {'- Modelo CloseIn'};
    {'- Modelo LongleyRice'};
    {'- Modelo TIREM'};
    {'- Modelo RayTracing'};
    {' Computa múltiplos percursos. Suporta ambientes indoor e outdoor.'}
    ];

for i = 1:length(pos1)
    a = uicontrol(f,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
    a.Position = pos1(i,:);
    a.String   = str1(i);
end

pos2 = [
    [135 960 420 22]
    [135 945 420 22]
    [135 930 420 22]
    [135 915 420 22]
    [135 900 420 22]
    [135 885 420 22]
    [135 870 420 22]
    [135 855 420 22]
    [135 840 420 22]
    [135 825 420 22]
    [135 810 420 22]
    ];

str2 = [
    {'-> Só tem que se garantir LoS.'};
    {'-> Só funciona entre 1 e 1000GHz. Tem que se garantir LoS.'};
    {'-> Só funciona entre 1 e 1000GHz. Tem que se garantir LoS.'};
    {'-> Só funciona entre 10 e 1000GHz. Tem que se garantir LoS.'};
    {'-> Sem restrições de frequência.'};
    {'-> Só funciona entre 20MHz e 20GHz.'};
    {'    Usa obstáculos, difração, reflexões, refrações e espalhamento.'};
    {'-> Só funciona entre 1MHz e 1000GHz.'};
    {'    Usa obstáculos, difração, reflexões, refrações e espalhamento.'};
    {'-> Só funciona entre 100MHz e 100GHz.'};
    {'    Computa múltiplos percursos. Suporta ambientes indoor e outdoor.'}
    ];

for i = 1:length(pos2)
    a = uicontrol(f,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
    a.Position = pos2(i,:);
    a.String   = str2(i);
end

end