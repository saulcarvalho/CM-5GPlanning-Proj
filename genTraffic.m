function [v_Traffic] = genTraffic(fig_gen_traffic)

m = uicontrol(fig_gen_traffic,'Style','text','fontweight','bold','HorizontalAlignment','center','FontSize',12);
m.Position = [870 875 200 22];
m.String = {'Gerador de Tráfego'};

panel = uipanel(fig_gen_traffic,'Position',[50 350 1810 500]);

c = uicontrol(fig_gen_traffic,'Style','slider','SliderStep',[1/100, 0.5],'BackgroundColor',[0.3686 0.3686 0.3686]);
c.Position = [100 300 140 22];            % x, y , size_x, size y
c.Min = 0;
c.Value = 5e6;
c.Max = 10e6;
c.Callback = @cb1;

c1 = uicontrol(fig_gen_traffic,'Style','slider','SliderStep',[1/100, 0.5],'BackgroundColor',[0.3686 0.3686 0.3686]);
c1.Position = [100 250 140 22];            % x, y , size_x, size y
c1.Min = 0;
c1.Value = 500;
c1.Max = 1000;
c1.Callback = @cb2;

c2 = uicontrol(fig_gen_traffic,'Style','slider','SliderStep',[1/100, 0.5],'BackgroundColor',[0.3686 0.3686 0.3686]);
c2.Position = [400 300 140 22];            % x, y , size_x, size y
c2.Min = 0;
c2.Value = 5e6;
c2.Max = 10e6;
c2.Callback = @cb3;

c3 = uicontrol(fig_gen_traffic,'Style','slider','SliderStep',[1/100, 0.5],'BackgroundColor',[0.3686 0.3686 0.3686]);
c3.Position = [400 250 140 22];            % x, y , size_x, size y
c3.Min = 0;
c3.Value = 500;
c3.Max = 1000;
c3.Callback = @cb4;

e1 = uicontrol(fig_gen_traffic,"Style","pushbutton",'fontweight','bold','FontSize', 10,'ForegroundColor','black','BackgroundColor','white');
e1.InnerPosition = [120 50 100 40];
e1.String  = 'Gerar ruído';
e1.Callback = @cb_noise;

p1 = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
p1.Position = [100 320 140 22];       % x, y , size_x, size y
p1.String = {'Valor:'};
p1min = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p1min.Position = [80 295 10 22];       % x, y , size_x, size y
p1min.String = {'0'};
p1max = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p1max.Position = [250 295 40 22];       % x, y , size_x, size y
p1max.String = {'10e6'};
p1value = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','blue','fontweight','bold');
p1value.Position = [140 320 60 22];       % x, y , size_x, size y
default = 5e6*1e-6;
p1value.String = num2str(default+"e6");

p2 = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
p2.Position = [100 270 140 22];       % x, y , size_x, size y
p2.String = {'Valor:'};
p2min = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p2min.Position = [80 245 10 22];       % x, y , size_x, size y
p2min.String = {'0'};
p2max = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p2max.Position = [250 245 40 22];       % x, y , size_x, size y
p2max.String = {'1000'};
p2value = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','blue','fontweight','bold');
p2value.Position = [140 270 40 22];       % x, y , size_x, size y
default = 500;
p2value.String = num2str(default);

p1b = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
p1b.Position = [400 320 140 22];       % x, y , size_x, size y
p1b.String = {'Valor:'};
p1bmin = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p1bmin.Position = [380 295 10 22];       % x, y , size_x, size y
p1bmin.String = {'0'};
p1bmax = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p1bmax.Position = [550 295 40 22];       % x, y , size_x, size y
p1bmax.String = {'10e6'};
p1bvalue = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','blue','fontweight','bold');
p1bvalue.Position = [440 320 60 22];       % x, y , size_x, size y
default = 5e6*1e-6;
p1bvalue.String = num2str(default+"e6");

p2b = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
p2b.Position = [400 270 140 22];       % x, y , size_x, size y
p2b.String = {'Valor:'};
p2bmin = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p2bmin.Position = [380 245 10 22];       % x, y , size_x, size y
p2bmin.String = {'0'};
p2bmax = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','black');
p2bmax.Position = [550 245 40 22];       % x, y , size_x, size y
p2bmax.String = {'1000'};
p2bvalue = uicontrol(fig_gen_traffic,'Style','text','ForegroundColor','blue','fontweight','bold');
p2bvalue.Position = [440 270 40 22];       % x, y , size_x, size y
default = 500;
p2bvalue.String = num2str(default);

time   = [0:0.001:24];        % em horas
traffic = zeros(size(time));

v_a  = 5e6;
v_a1 = 4000;
v_a2 = 500;
v_b  = 5e6;
v_b1 = 4000;
v_b2 = 500;

start = 7000;
ofs1  = 8000;
ofs2  = 9000;
ofs3  = 10000;
ofs4  = 11000;
ofs5  = 12000;
ofs6  = 13000;

calc();

ax = uiaxes(panel,'Position',[50 50 1700 400]);
ax.XLim = [0 24];
ax.YLim = [0 10000];
plot(ax,time, traffic,'Color','blue')

m = uicontrol(panel,'Style','text','fontweight','bold','HorizontalAlignment','center','FontSize',10);
m.Position = [820 10 200 22];
m.String = {'Tempo do dia [horas]'};

assignin('base', "fig_gen_traffic", fig_gen_traffic);

    function cb1(~,~)
        v_a = round(c.Value,0); % to integer
        p1value.String = num2str(v_a*1e-6)+"e6";
        
        calc();
        plot(ax,time, traffic,'Color','blue')
    end

    function cb2(~,~)
        v_a2 = round(c1.Value,0); % to integer
        p2value.String = num2str(v_a2);
        
        calc();
        plot(ax,time, traffic,'Color','blue')
    end

    function cb3(~,~)
        v_b = round(c2.Value,0); % to integer
        p1bvalue.String = num2str(v_b*1e-6)+"e6";
        
        calc();
        plot(ax,time, traffic,'Color','blue')
    end

    function cb4(~,~)
        v_b2 = round(c3.Value,0); % to integer
        p2bvalue.String = num2str(v_b2);
        
        calc();
        plot(ax,time, traffic,'Color','blue')
    end


    function calc()
        for i=1:v_a1
            traffic(i+ofs1) = v_a*normpdf(i,v_a1/2,v_a2) + traffic(ofs1);       % cálculo da primeira curva
        end

        for i=1:v_b1
            traffic(i+ofs5) = v_b*normpdf(i,v_b1/2,v_b2) + traffic(ofs5);       % cálculo da secunda curva 
        end

        for i=1:length(traffic)
            traffic(i) = round(traffic(i));                                     % Agregação das funções
        end
        assignin('base','traffic',traffic);
    end

    function cb_noise()
        sigma = 100;
        noise = sigma*randn(size(traffic));

        for i=1:length(traffic)
            traffic(i) = traffic(i) + noise(i);                               % Soma de ruido da distribuição
        end

        calc();
    end

end