classdef ReferenceModel < handle
    
    properties (Access = 'public')
        state = [];
        timeStep = [];
        substeps = [];
        naturalFreq = [];
        damping = [];
        recordSTATE = [];
        
    end
    
    methods (Access = 'public')
        
        function obj = ReferenceModel(startPoint)
            
            if nargin == 0
                obj.state = [0;0];
            else
                obj.state = startPoint;
            end
            obj.timeStep = 0.05;
            obj.naturalFreq = 2;
            obj.damping = 0.5;
            obj.substeps = 1;
            obj.recordSTATE = obj.state;
        end
        
        function propogateRefModel(obj, refSignal)
            obj.state = obj.simModel(refSignal);
            obj.recordSTATE = [obj.recordSTATE,obj.state];
        end
    end
    methods (Access = 'private')
        function Xdot = dynamicsRefModel(obj,state,refSignal)
            
            x1Dot = state(2);
            x2Dot =  -obj.naturalFreq^2*state(1)-2*obj.damping*obj.naturalFreq*state(2) + obj.naturalFreq^2*refSignal;
            Xdot = [x1Dot;x2Dot];
            
        end
        
        function Xstep = simModel(obj,refSignal)
            
            for i = 1:obj.substeps
                k1 = obj.dynamicsRefModel(obj.state,refSignal);
                k2 = obj.dynamicsRefModel(obj.state+obj.timeStep/2*k1,refSignal);
                k3 = obj.dynamicsRefModel(obj.state+obj.timeStep/2*k2,refSignal);
                k4 = obj.dynamicsRefModel(obj.state+obj.timeStep*k3,refSignal);
                
                Xstep = obj.state + obj.timeStep/6*(k1 + 2*k2 + 2*k3 + k4);
                
            end
        end
    end
end



