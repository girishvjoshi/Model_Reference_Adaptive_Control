classdef MRAC < ReferenceModel
    
    properties (Access = 'public')
        gain = [];
        netWeight = [];
        phi = [];
        feedBack_gainP = [];
        feedBack_gainD = [];
        feedForward_gain = [];
        Aref = [];
        B = [];
        Q = []
        P = [];
        recordCNTRL = [];
        recordADPTCNTRL = [];
        
    end
    
    methods(Access = 'public')
        function obj = MRAC(gain)
            if nargin == 0
                obj.gain = 10;
            else
                obj.gain = gain;
            end
            
            obj.netWeight = zeros(5,1);
            obj.feedBack_gainP = -obj.naturalFreq^2;
            obj.feedBack_gainD = -2*obj.damping*obj.naturalFreq;
            obj.feedForward_gain = obj.naturalFreq^2;
            obj.Aref = [0 1;obj.feedBack_gainP obj.feedBack_gainD];
            obj.B = [0;1];
            obj.Q = 100*eye(length(obj.state));
            obj.P = lyap(obj.Aref',obj.Q);
            obj.recordCNTRL = 0;
            obj.recordADPTCNTRL = 0;
        end
        
        function total_CNTRL = MRAC_CNTRL(obj,state,refSignal)
            feedBack_CNTRL = [obj.feedBack_gainP obj.feedBack_gainD]*state;
            feedForward_CNTRL = obj.feedForward_gain*refSignal;
            obj.updateBasis(state);
            obj.weightUpdate(state);
            adaptive_CNTRL = obj.netWeight'*obj.phi;
            total_CNTRL = feedBack_CNTRL + feedForward_CNTRL - adaptive_CNTRL;
            obj.recordCNTRL = [obj.recordCNTRL,total_CNTRL];
            obj.recordADPTCNTRL = [obj.recordADPTCNTRL,adaptive_CNTRL];
            
            
        end
       
    end
    methods (Access = 'private')
        function updateBasis(obj,state)
            obj.phi = [state(1);state(2);abs(state(1))*state(2);abs(state(2))*state(2);state(1)^3];
        end
        function weightUpdate(obj,state)
            error = obj.state - state;
            obj.netWeight = obj.netWeight + obj.timeStep*(-obj.gain*obj.phi*error'*obj.P*obj.B);
        end
    end
end


