function [freq_OK] = checkFreq(txs,propModel)

if strcmpi(propModel, "freespace") || strcmpi(propModel, "log-distance") || strcmpi(propModel, "log-normal") || strcmpi(propModel, "hata")
    freq_OK = 1;
elseif strcmpi(propModel, "rain")
    if (txs(1).TransmitterFrequency >= 1e9) && (txs(1).TransmitterFrequency <= 1000e9)
        freq_OK = 1;
    else
        freq_OK = 0;
    end
elseif strcmpi(propModel, "gas")
    if (txs(1).TransmitterFrequency >= 1e9) && (txs(1).TransmitterFrequency <= 1000e9)
        freq_OK = 1;
    else
        freq_OK = 0;
    end

elseif strcmpi(propModel, "fog")
    if (txs(1).TransmitterFrequency >= 10e9) && (txs(1).TransmitterFrequency <= 1000e9)
        freq_OK = 1;
    else
        freq_OK = 0;
    end
elseif strcmpi(propModel, "close-in")
    freq_OK = 1;
elseif strcmpi(propModel, "longley-rice")
    if (txs(1).TransmitterFrequency >= 20e6) && (txs(1).TransmitterFrequency <= 20e9)
        freq_OK = 1;
    else
        freq_OK = 0;
    end
elseif strcmpi(propModel, "tirem")
    if (txs(1).TransmitterFrequency >= 1e6) && (txs(1).TransmitterFrequency <= 1000e9)
        freq_OK = 1;
    else
        freq_OK = 0;
    end
elseif strcmpi(propModel, "raytracing")
    if (txs(1).TransmitterFrequency >= 100e6) && (txs(1).TransmitterFrequency <= 100e9)
        freq_OK = 1;
    else
        freq_OK = 0;
    end
else
    freq_OK = 0;
end

end