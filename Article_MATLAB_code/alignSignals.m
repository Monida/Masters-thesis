function alignedS2=alignSignals(s1,s2)
s2=s2(1:length(s1));

[acor,lag]=xcorr(s1,s2);
inds = abs(lag) <= gcLength;    % limits the lags to be within one gait
                                % cycle of the start of x1

lag2 = lag(inds);               % select the lag values of interest
acor2 = acor(inds);             % select the corresponding xcorr values

[~,I] = max(abs(acor2));        % identify the maximum xcorr value within
                                % the range-of-interest

delay = lag2(I);   

if delay>0
    alignedS2=[zeros(1:delay,1);s2];
else if delay<0
        alignedS2=s2(abs(delay)+1:end);
    end
end
end