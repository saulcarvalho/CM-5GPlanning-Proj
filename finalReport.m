function finalReport(fig_final_check,path2,txs)

% ficheiros a ler para gerar o relatório final <- Deve-se alterar para verficar os ficheiro em questão
file_coverage = "PO_longley-rice_coverage_macro_23-May-2022.mat";
file_SINR     = "PO_longley-rice_sinr_macro_23-May-2022.mat";
file_capacity = "PO_capacity_macro_30-May-2022.mat";
path_coverage = path2 + "files/macro/coverage/" + file_coverage;
path_SINR     = path2 + "files/macro/sinr/"     + file_SINR;
path_capacity = path2 + "files/macro/capacity/" + file_capacity;

dataCoverage = load(convertStringsToChars(path_coverage));
dataSINR     = load(convertStringsToChars(path_SINR));
dataCapacity = load(convertStringsToChars(path_capacity));

if contains(file_coverage, evalin('base', 'propModel')) && contains(file_SINR, evalin('base', 'propModel'))
    m = uicontrol(fig_final_check,'Style','text','fontweight','bold','HorizontalAlignment','center','FontSize',12);
    m.Position = [760 875 400 22];
    m.String = {'Verificação Global - Macrocells (Modelo Otimizado)'};

    panel1 = uipanel(fig_final_check,'Position',[20 360 930 500]);
    panel2 = uipanel(fig_final_check,'Position',[970 360 930 500]);
    panel3 = uipanel(fig_final_check,'Position',[20 -90 1880 430]);

    c = uicontrol(panel2,'Style','slider','SliderStep',[1/25, 0.5],'BackgroundColor',[0.3686 0.3686 0.3686]);
    c.Position = [30 450 140 22];            % x, y , size_x, size y
    c.Min = 0;
    c.Value = 5;
    c.Max = 25;
    c.Callback = @cb1;

    c1 = uicontrol(panel2,'Style','slider','SliderStep',[1/100, 0.5],'BackgroundColor',[0.3686 0.3686 0.3686]);
    c1.Position = [30 400 140 22];            % x, y , size_x, size y
    c1.Min = 0;
    c1.Value = 25;
    c1.Max = 100;
    c1.Callback = @cb2;


    d = uicontrol(panel2,'Style','slider','SliderStep',[1/70, 0.5],'BackgroundColor',[0.3686 0.3686 0.3686]);
    d.Position = [250 450 140 22];            % x, y , size_x, size y
    d.Min = -120;
    d.Value = -85;
    d.Max = -50;
    d.Callback = @cb4;


    cgen = uicontrol(panel2,"Style","pushbutton",'fontweight','bold','FontSize', 14,'ForegroundColor','black','BackgroundColor','white');
    cgen.InnerPosition = [390 10 150 40];
    cgen.String = 'Gerar relatório';
    cgen.Tooltip = sprintf('Gera o relatório de dados.');
    cgen.Callback = @cb_genReport;

    p1 = uicontrol(panel2,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
    p1.Position = [30 470 140 22];         % x, y , size_x, size y
    p1.String = {'SINR Mínimo: '};
    p1min = uicontrol(panel2,'Style','text','ForegroundColor','black');
    p1min.Position = [10 445 10 22];       % x, y , size_x, size y
    p1min.String = {'0'};
    p1max = uicontrol(panel2,'Style','text','ForegroundColor','black');
    p1max.Position = [170 445 40 22];      % x, y , size_x, size y
    p1max.String = {'25'};
    p1value = uicontrol(panel2,'Style','text','ForegroundColor','blue','fontweight','bold');
    p1value.Position = [160 470 60 22];     % x, y , size_x, size y
    default = 5;
    p1value.String = num2str(default);
    assignin('base','FR_minSINR',default);

    p2 = uicontrol(panel2,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
    p2.Position = [30 420 140 22];         % x, y , size_x, size y
    p2.String = {'Taxa Penetração: '};
    p2min = uicontrol(panel2,'Style','text','ForegroundColor','black');
    p2min.Position = [10 395 10 22];       % x, y , size_x, size y
    p2min.String = {'0'};
    p2max = uicontrol(panel2,'Style','text','ForegroundColor','black');
    p2max.Position = [170 395 40 22];      % x, y , size_x, size y
    p2max.String = {'100'};
    p2value = uicontrol(panel2,'Style','text','ForegroundColor','blue','fontweight','bold');
    p2value.Position = [160 420 60 22];     % x, y , size_x, size y
    default = 25;
    p2value.String = num2str(default);
    assignin('base','FR_PenRate',default);

    p1a = uicontrol(panel2,'Style','text','ForegroundColor','black','HorizontalAlignment','left');
    p1a.Position = [250 470 140 22];         % x, y , size_x, size y
    p1a.String = {'Sensibilidade Padrão: '};
    p1amin = uicontrol(panel2,'Style','text','ForegroundColor','black');
    p1amin.Position = [215 445 25 22];       % x, y , size_x, size y
    p1amin.String = {'-120'};
    p1amax = uicontrol(panel2,'Style','text','ForegroundColor','black');
    p1amax.Position = [390 445 40 22];      % x, y , size_x, size y
    p1amax.String = {'-50'};
    p1avalue = uicontrol(panel2,'Style','text','ForegroundColor','blue','fontweight','bold');
    p1avalue.Position = [380 470 60 22];     % x, y , size_x, size y
    default = -85;
    p1avalue.String = num2str(default);
    assignin('base','FR_Sensitivity',default);

    m = uicontrol(panel3,'Style','text','fontweight','bold','HorizontalAlignment','center','FontSize',12);
    m.Position = [10 400 300 22];
    m.String = {'Indicadores de Desempenho (KPI)'};

    assignin('base', "fig_final_check", fig_final_check);

else
    uialert(evalin('base', 'f1'),'O modelo selecionado não corresponde ao dos ficheiros escolhidos!','Erro','Icon','error');
    pause(3);
    if evalin('base', 'exist(''fig_final_check'',''var'')')
        evalin('base', 'close(fig_final_check)');
    end
end

    function cb1(~,~)
        delete(p1value);
        value   = round(c.Value,0); % to integer

        p1value = uicontrol(panel2,'Style','text','ForegroundColor','blue','fontweight','bold');
        p1value.Position = [160 470 60 22];      % x, y , size_x, size y
        p1value.String = num2str(value);
        assignin('base','FR_pop_density',value);
    end


    function cb2(~,~)
        delete(p2value);
        value   = round(c1.Value,0); % to integer

        p2value = uicontrol(panel2,'Style','text','ForegroundColor','blue','fontweight','bold');
        p2value.Position = [160 420 60 22];      % x, y , size_x, size y
        p2value.String = num2str(value);
        assignin('base','FR_PenRate',value);
    end


    function cb4(~,~)
        delete(p1avalue);
        value   = round(d.Value,0); % to integer

        p1avalue = uicontrol(panel2,'Style','text','ForegroundColor','blue','fontweight','bold');
        p1avalue.Position = [380 470 60 22];      % x, y , size_x, size y
        p1avalue.String = num2str(value);
        assignin('base','FR_Sensitivity',value);
    end


    function cb_genReport(~,~)
        clc;
        delete(panel1);
        delete(panel3);
        panel1 = uipanel(fig_final_check,'Position',[20 471 930 500]);
        panel3 = uipanel(fig_final_check,'Position',[20 20 1880 430]);

        m = uicontrol(panel3,'Style','text','fontweight','bold','HorizontalAlignment','center','FontSize',12);
        m.Position = [10 400 300 22];
        m.String = {'Indicadores de Desempenho (KPI)'};

        %         ax = uiaxes(panel1,'Position',[20 10 850 450]);
        %         ax.XLim = [0 24];
        %         ax.YLim = [0 10000];
        %         A = 1:1:10;
        %         plot(ax,A, A,'Color','blue')
       
        % get valid coverage region
        LOC = [39.7249 39.7593 -8.830639 -8.783397];
        count = 1;
        new_coverage = table(0,0,0);
        for i = 1:1:length(dataCoverage.coverageData.Data.Latitude)
            if dataCoverage.coverageData.Data.Latitude(i) >= LOC(1) && dataCoverage.coverageData.Data.Latitude(i) <= LOC(2)
                if dataCoverage.coverageData.Data.Longitude(i) >= LOC(3) && dataCoverage.coverageData.Data.Longitude (i) <= LOC(4)
                    new_coverage(count,:) = dataCoverage.coverageData.Data(i,:);
                    count = count + 1;
                end
            end
        end
        assignin("base","new_coverage",new_coverage);

        angle_inc   = new_coverage.Var1(1) - new_coverage.Var1(2);
        dist_inc    = angle_inc * 110574; % incremento de distância matricial em metros
        total_area  = dist_inc * length(new_coverage.Var3); % area total em metros^2
        ignore_area = 0.1 * total_area; % área aproximada dos cantos da matriz -> não pertece à cidade
        
        counter = 1;
        for i = 1:1:length(new_coverage.Var3)
            if new_coverage.Var3(i) > evalin('base', 'FR_Sensitivity')
               counter = counter + 1;
            end
        end
        % KPI - Coverage Rate
        area_coverage = dist_inc * counter; % metros^2
        rateCoverage = area_coverage / (total_area-ignore_area);
        % KPI - Coverage Rate p/ Site
        numSites = 19;
        numCells = numSites * 3;
        area_coverage_site = (dist_inc * counter) / numSites; % metros^2
        rateCoverageSite = area_coverage_site / (total_area-ignore_area);
        % KPI - Coverage Rate p/ célula
        area_coverage_cell = (dist_inc * counter) / numCells; % metros^2
        rateCoverageCell = area_coverage_cell / (total_area-ignore_area);
        % KPI - Coverage Média
        meanCoverage = mean(new_coverage.Var3);
        
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 350 300 22];        % x, y , size_x, size y
        m.String = ['Taxa de Cobertura (> ' num2str(evalin('base', 'FR_Sensitivity')) ' dBm): ' num2str(round(rateCoverage*100,2)) ' %'];
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 320 400 22];        % x, y , size_x, size y
        m.String = ['Taxa de Cobertura por Site (> ' num2str(evalin('base', 'FR_Sensitivity')) ' dBm): ' num2str(round(rateCoverageSite*100,2)) ' %'];
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 290 400 22];        % x, y , size_x, size y
        m.String = ['Taxa de Cobertura por Célula/Setor (> ' num2str(evalin('base', 'FR_Sensitivity')) ' dBm): ' num2str(round(rateCoverageCell*100,2)) ' %'];
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 260 300 22];        % x, y , size_x, size y
        m.String = ['Média de Cobertura: ' num2str(round(meanCoverage,2)) ' dBm'];


        % get valid sinr region
        LOC = [39.7249 39.7593 -8.830639 -8.783397];
        count = 1;
        new_sinr = table(0,0,0);
        for i = 1:1:length(dataSINR.sinrData.Data.Latitude)
            if dataSINR.sinrData.Data.Latitude(i) >= LOC(1) && dataSINR.sinrData.Data.Latitude(i) <= LOC(2)
                if dataSINR.sinrData.Data.Longitude(i) >= LOC(3) && dataSINR.sinrData.Data.Longitude (i) <= LOC(4)
                    new_sinr(count,:) = dataSINR.sinrData.Data(i,:);
                    count = count + 1;
                end
            end
        end
        assignin("base","new_sinr",new_sinr);

        angle_inc  = new_sinr.Var1(1) - new_sinr.Var1(2);
        dist_inc   = angle_inc * 110574; % incremento de distância matricial em metros
        total_area = dist_inc * length(new_sinr.Var3); % area total em metros^2
        
        counter = 1;
        for i = 1:1:length(new_sinr.Var3)
            if new_sinr.Var3(i) > evalin('base', 'FR_minSINR')
               counter = counter + 1;
            end
        end

        % KPI - SINR Rate
        area_sinr = dist_inc * counter; % metros^2
        rateSINR = area_sinr / (total_area-ignore_area);
        % KPI - SINR Médio
        meanSINR = mean(new_sinr.Var3);
        % KPI - PTX Médio
        for i = 1:1:length(txs)
            PTx_W(i) = mean(txs(1,i).TransmitterPower);
        end
        meanPTx_W = mean(PTx_W);
        meanPTx   = 10*log10(meanPTx_W/1e-3);

        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 230 300 22];        % x, y , size_x, size y
        m.String = ['Taxa de SINR (> ' num2str(evalin('base', 'FR_minSINR')) ' dBm): ' num2str(round(rateSINR*100,2)) ' %'];
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 200 300 22];        % x, y , size_x, size y
        m.String = ['Média de SINR: ' num2str(round(meanSINR,2)) ' dBm'];
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 170 300 22];        % x, y , size_x, size y
        m.String = ['Média de PTx: ' num2str(round(meanPTx,2)) ' dBm'];

        %get valid capacity
        count = 1;
        new_capacity = table(0,0,0);
        for i = 1:1:length(dataCapacity.capacityData.Data.Latitude)
            if dataCapacity.capacityData.Data.Latitude(i) >= LOC(1) && dataCapacity.capacityData.Data.Latitude(i) <= LOC(2)
                if dataCapacity.capacityData.Data.Longitude(i) >= LOC(3) && dataCapacity.capacityData.Data.Longitude (i) <= LOC(4)
                    new_capacity(count,:) = dataCapacity.capacityData.Data(i,:);
                    count = count + 1;
                end
            end
        end
        assignin("base","new_capacity",new_capacity);
        
        % KPI - Média de utilizadores
        real_multiplier = 0.99;
        meanUsers = mean(real_multiplier * new_capacity.Var3) * (evalin('base', 'FR_PenRate') * 0.01);
        maxUsers  = max(real_multiplier * new_capacity.Var3) * (evalin('base', 'FR_PenRate') * 0.01);
        % KPI - Média de utilizadores p/ célula
        
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 140 550 22];        % x, y , size_x, size y
        m.String = ['Máximo de Utilizadores (Taxa de Penetração = ' num2str(evalin('base', 'FR_PenRate')) '%): ' num2str(round(maxUsers,0)) ' utilizadores/s*célula'];
        m = uicontrol(panel3,'Style','text','ForegroundColor','black','HorizontalAlignment','left','FontSize',10);
        m.Position = [30 110 550 22];        % x, y , size_x, size y
        m.String = ['Média de Utilizadores (Taxa de Penetração = ' num2str(evalin('base', 'FR_PenRate')) '%): ' num2str(round(meanUsers,0)) ' utilizadores/s*célula'];
    end

end