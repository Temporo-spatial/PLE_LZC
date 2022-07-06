function [pp1,power_data,power_freq,r_resi]=powerlaw(time_series,TR,low_range,high_range,varargin)
%     HS = spectrum.welch;
    Fs = 1/TR;
%     nfft = 2^nextpow2(length(time_series));
    
    [pxx,f] = pwelch(time_series,[],[],2^10,Fs);
%     power_spec = psd(HS,time_series,'NFFT',nfft,'Fs',Fs);
    power_data = pxx;
    power_freq = f;
    
    slope_index = find(power_freq > low_range & power_freq < high_range);
    p = polyfit(log(power_freq(slope_index)),log(power_data(slope_index)),1);
    pp1 = -p(1);
    
    
    if length(varargin) > 0 && any(varargin{1} == 'Plot')
        y = p(2) + p(1)*log(f(slope_index));
        plot(log(f(slope_index)),log(pxx(slope_index)));
        hold on;
        plot(log(f(slope_index)),y,'r--');
        xlabel('Log Frequency')
        ylabel('Log Power')
        title(['Estimated PLE is ' num2str(pp1)])
    end
    
    
    [b,bint,r,rint,stats] = regress(log(power_data(slope_index)),[ones(length(power_freq(slope_index)),1) log(power_freq(slope_index))*p(1)+ p(2)]);
    r_resi = stats(4);
    
    
