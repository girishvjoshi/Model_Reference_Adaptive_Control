classdef WingRock < handle
    
    properties (Access = 'public')
        state = [];
        timeStep = [];
        substeps = [];
        trueWeights = [];
        lDelta = [];
        recordSTATE = [];
        recordTRUE_UNCERTAINTY = [];
        
    end
    
    methods (Access = 'public')
        
        function obj = WingRock(startPoint)
            
            if nargin == 0
                obj.state = [0;0];
            else
                obj.state = startPoint;
            end
            obj.timeStep = 0.05;
            obj.trueWeights = [0.2314 0.6918 -0.6245 0.0095 0.0214]';
            obj.lDelta = 1;
            obj.substeps = 1;
            obj.recordSTATE = obj.state;
            obj.recordTRUE_UNCERTAINTY = 0;
        end
        
        function applyControl(obj, control)
            obj.state = obj.simModel(control);
            obj.recordSTATE = [obj.recordSTATE,obj.state];
            obj.recordTRUE_UNCERTAINTY = [obj.recordTRUE_UNCERTAINTY,obj.trueWeights'*[obj.state(1);obj.state(2);abs(obj.state(1))*obj.state(2);abs(obj.state(2))*obj.state(2);obj.state(1)^3]];
            
        end
    end
    methods (Access = 'private')
        function Xdot = dynamicsWingRock(obj,state,action)
            
            phi = [state(1);state(2);abs(state(1))*state(2);abs(state(2))*state(2);state(1)^3];
            dx1 = obj.trueWeights'*phi
            x1Dot = state(2);
            x2Dot =  dx1 + obj.lDelta*action;
            Xdot = [x1Dot;x2Dot];
            
        end
        
        function Xstep = simModel(obj,control)
            
            for i = 1:obj.substeps
                k1 = obj.dynamicsWingRock(obj.state,control);
                k2 = obj.dynamicsWingRock(obj.state+obj.timeStep/2*k1,control);
                k3 = obj.dynamicsWingRock(obj.state+obj.timeStep/2*k2,control);
                k4 = obj.dynamicsWingRock(obj.state+obj.timeStep*k3,control);
                
                Xstep = obj.state + obj.timeStep/6*(k1 + 2*k2 + 2*k3 + k4);
                
            end
        end
    end
end

