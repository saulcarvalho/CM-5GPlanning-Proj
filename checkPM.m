function [pm_OK,pm] = checkPM(f1, propModel)

if strcmpi(propModel, "freespace")
    pm = propagationModel("freespace");
    pm_OK = 1;
elseif strcmpi(propModel, "rain")
    if evalin('base', 'exist(''propModel_Rain_RainRate'',''var'')') && evalin('base', 'exist(''propModel_Rain_Tilt'',''var'')')
        pm = propagationModel(propModel,"RainRate",evalin('base', 'propModel_Rain_RainRate'),"Tilt",evalin('base', 'propModel_Rain_Tilt'));
        assignin('base',"pm",pm);
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "gas")
    if evalin('base', 'exist(''propModel_Gas_Temp'',''var'')') && evalin('base', 'exist(''propModel_Gas_Pres'',''var'')') && evalin('base', 'exist(''propModel_Gas_WaterDens'',''var'')')
        pm = propagationModel(propModel,"Temperature",evalin('base', 'propModel_Gas_Temp'),"AirPressure",evalin('base', 'propModel_Gas_Pres'),"WaterDensity",evalin('base', 'propModel_Gas_WaterDens'));
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "fog")
    if evalin('base', 'exist(''propModel_Fog_Temp'',''var'')') && evalin('base', 'exist(''propModel_Fog_WaterDens'',''var'')')
        pm = propagationModel(propModel,"Temperature",evalin('base', 'propModel_Fog_Temp'),"WaterDensity",evalin('base', 'propModel_Fog_WaterDens'));
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "close-in")
    if evalin('base', 'exist(''propModel_CloseIn_DistRef'',''var'')') && evalin('base', 'exist(''propModel_CloseIn_ExpPL'',''var'')') && evalin('base', 'exist(''propModel_CloseIn_Sigma'',''var'')')
        pm = propagationModel(propModel,"ReferenceDistance",evalin('base', 'propModel_CloseIn_DistRef'),"PathLossExponent",evalin('base', 'propModel_CloseIn_ExpPL'),"Sigma",evalin('base', 'propModel_CloseIn_Sigma'));
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "longley-rice")
    if evalin('base', 'exist(''propModel_LongleyRice_PolAnt'',''var'')') && evalin('base', 'exist(''propModel_LongleyRice_Climate'',''var'')') ...
            && evalin('base', 'exist(''propModel_LongleyRice_GroundCondutivity'',''var'')') && evalin('base', 'exist(''propModel_LongleyRice_GroundPermittivity'',''var'')') ...
            && evalin('base', 'exist(''propModel_LongleyRice_AtmosphericRefractivity'',''var'')') && evalin('base', 'exist(''propModel_LongleyRice_TimeTolVar'',''var'')') ...
            && evalin('base', 'exist(''propModel_LongleyRice_SituationTolVar'',''var'')')
        pm = propagationModel(propModel,"AntennaPolarization",evalin('base', 'propModel_LongleyRice_PolAnt'), ...
            "ClimateZone",evalin('base', 'propModel_LongleyRice_Climate'), ...
            "GroundConductivity",evalin('base', 'propModel_LongleyRice_GroundCondutivity'), ...
            "GroundPermittivity",evalin('base', 'propModel_LongleyRice_GroundPermittivity'), ...
            "AtmosphericRefractivity",evalin('base', 'propModel_LongleyRice_AtmosphericRefractivity'), ...
            "TimeVariabilityTolerance",evalin('base', 'propModel_LongleyRice_TimeTolVar'), ...
            "SituationVariabilityTolerance",evalin('base', 'propModel_LongleyRice_SituationTolVar'));
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "tirem")
    %if evalin('base', 'exist(''propModel_TIREM_PolAnt'',''var'')') && evalin('base', 'exist(''propModel_TIREM_HumAbs'',''var'')') ...
    % && evalin('base', 'exist(''propModel_TIREM_GroundCondutivity'',''var'')') && evalin('base', 'exist(''propModel_TIREM_GroundPermitivity'',''var'')') ...
    %  && evalin('base', 'exist(''propModel_TIREM_AtmosphericRefractivity'',''var'')')
    % pm = propagationModel(propModel,"AntennaPolarization",evalin('base', 'propModel_TIREM_PolAnt'),"Humidity",evalin('base', 'propModel_TIREM_HumAbs'), ...
    % "GroundConductivity",evalin('base', 'propModel_TIREM_GroundCondutivity'),"GroundPermittivity",evalin('base', 'propModel_TIREM_GroundPermitivity'), ...
    %  "AtmosphericRefractivity",evalin('base', 'propModel_TIREM_AtmosphericRefractivity'));
    %  pm_OK = 1;
    uialert(f1,['Para usar este modelo de propagação precisa de adquirir o DLL (libtirem3.dll ou tirem3.dll)!'],'Aviso','Icon','warning');
    pm = 0;
    pm_OK = 0;

    %else
    % uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
    % pm_OK = 0;
    %end
elseif strcmpi(propModel, "raytracing")
    if evalin('base', 'exist(''propModel_RayTrac_MatBuild'',''var'')') && evalin('base', 'exist(''propModel_RayTrac_MatTerr'',''var'')') && evalin('base', 'exist(''propModel_RayTrac_Method'',''var'')') ...
        && evalin('base', 'exist(''propModel_RayTrac_SeparationAngle'',''var'')') && evalin('base', 'exist(''propModel_RayTrac_MaxNumReflections'',''var'')') ...
        && evalin('base', 'exist(''propModel_RayTrac_PermitivityMatBuilding'',''var'')') && evalin('base', 'exist(''propModel_RayTrac_CondutivityMatBuilding'',''var'')') ...
        && evalin('base', 'exist(''propModel_RayTrac_PermitivityMatTerrain'',''var'')')  && evalin('base', 'exist(''propModel_RayTrac_CondutivityMatTerrain'',''var'')')

        pm = propagationModel(propModel,"BuildingsMaterial",evalin('base', 'propModel_RayTrac_MatBuild'),"TerrainMaterial",evalin('base', 'propModel_RayTrac_MatTerr'), ...
            "Method",evalin('base', 'propModel_RayTrac_Method'),"AngularSeparation",evalin('base', 'propModel_RayTrac_SeparationAngle'), ...
            "MaxNumReflections",evalin('base', 'propModel_RayTrac_MaxNumReflections'), ...
            "BuildingsMaterialPermittivity",evalin('base', 'propModel_RayTrac_PermitivityMatBuilding'), "BuildingsMaterialConductivity",evalin('base', 'propModel_RayTrac_CondutivityMatBuilding'), ...
            "TerrainMaterialPermittivity",evalin('base', 'propModel_RayTrac_PermitivityMatTerrain'), "TerrainMaterialConductivity",evalin('base', 'propModel_RayTrac_CondutivityMatTerrain'));
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "log-distance")
    if evalin('base', 'exist(''propModel_LogDistance_PathLossExp'',''var'')')
        pm = 0;
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "log-normal")
    if evalin('base', 'exist(''propModel_LogNormal_PathLossExp'',''var'')') && evalin('base', 'exist(''propModel_LogNormal_Variance'',''var'')')
        pm = 0;
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
elseif strcmpi(propModel, "hata")
    if evalin('base', 'exist(''propModel_Hata_AreaType'',''var'')')
        pm = 0;
        pm_OK = 1;
    else
        uialert(f1,['Os parâmetros do modelo de propagação não foram todos introduzidos!'],'Aviso','Icon','warning');
        pm_OK = 0;
    end
else

    uialert(f1,['Modelo de propagação não reconhecido!'],'Erro','Icon','error');
    pm_OK = 0;
end

end