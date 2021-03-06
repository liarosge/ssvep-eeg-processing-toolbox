classdef PYAR_Transformer < ssveptoolkit.transformer.FeatureTransformerBase
    
    properties (Access = public)
        channel;
        seconds;
        order;
        nfft;
    end
    
    methods (Access = public)
        function mAR = PYAR_Transformer(trials, seconds, channel,m_ord, nfft)
            if nargin == 0
                mAR.seconds = 0;
                mAR.channel = 126;
                mAR.order = 2;
                mAR.nfft = 512;
            elseif nargin == 1
                mAR.trials = trials;
                mAR.seconds = 0;
                mAR.channel = 126;
                mAR.order = 2;
                mAR.nfft = 512;
            elseif nargin == 2
                mAR.trials = trials;
                mAR.channel = 126;
                mAR.seconds = seconds;
                mAR.order = 2;
                mAR.nfft = 512;
            elseif nargin == 3
                mAR.trials = trials;
                mAR.channel = channel;
                mAR.seconds = seconds;
                mAR.order=2;
                mAR.nfft = 512;
            elseif nargin == 4
                mAR.trials = trials;
                mAR.channel = channel;
                mAR.seconds = seconds;
                mAR.order = m_ord;
                mAR.nfft = 512;
            elseif nargin == 5
                mAR.trials = trials;
                mAR.channel = channel;
                mAR.seconds = seconds;
                mAR.order = m_ord;
                mAR.nfft = nfft;
            else
                error('invalid number of arguments');
            end
        end
        
        function transform(mAR)
            NUM_FEATURES = mAR.nfft/2+1;
            numTrials = length(mAR.trials);
            instances = zeros(numTrials, NUM_FEATURES);
            labels = zeros(numTrials,1);
            for i=1:numTrials
                numsamples = mAR.trials{i}.samplingRate * mAR.seconds;
                if(numsamples == 0)
                    y = mAR.trials{i}.signal(mAR.channel,:);
                else
                    y = mAR.trials{i}.signal(mAR.channel, 1:numsamples);
                end                
                [pyy pff] = pyulear(y,mAR.order,mAR.nfft,mAR.trials{i}.samplingRate);
                instances(i,:) = pyy;
                labels(i,1) = floor(mAR.trials{i}.label);
            end
            mAR.instanceSet = ssveptoolkit.util.InstanceSet(instances,labels);
        end
        
        function configInfo = getConfigInfo(mAR)
            configInfo = sprintf('PYAR_Transformer\tchannel:%d\tseconds:%d\tnfft:%d\torder:%d',mAR.channel,mAR.seconds,mAR.nfft,mAR.order);
        end
    end
   
end

