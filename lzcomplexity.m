function [LZC,meanLZC]=lzcomplexity(myEEG,epochLength,overlap)
% Inputs
if epochLength==0
    n_epochs=1;
    epochLength=length(myEEG);
    overlap=0;
else
    n_epochs=fix((length(myEEG)-epochLength)/(epochLength*(1-overlap))+1);
end

% LZC algorithm
for l=1:n_epochs
    if l==n_epochs
        epoch=myEEG((1+(l-1)*epochLength*(1-overlap)):end);
    else
        epoch=myEEG((1+(l-1)*epochLength*(1-overlap)):((l-1)*epochLength*(1-overlap)+epochLength));
    end
    
    n=length(epoch);
    
    % Binarization
    s=double(epoch>median(epoch));
    epoch=s;
    
    c=1;
    S=epoch(1);
    Q=epoch(2);
    
    for i=2:epochLength
        SQ=[S,Q];
        SQ_pi=[SQ(1:(length(SQ)-1))];
        
        indice=findstr(Q,SQ_pi);
        
        if length(indice)==0
            c = c+1;
            if (i+1)>epochLength
                break;
            else
                S=[S,Q];
                Q=epoch(i+1);
            end
        else

            if (i+1)>epochLength
                break;
            else
                Q=[Q,epoch(i+1)];
            end
        end
    end

    b=n/log2(n);
    LZC(l)=c/b;
    meanLZC=mean(LZC);
end

