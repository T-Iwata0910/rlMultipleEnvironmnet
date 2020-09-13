classdef rlMultipleEnvironment < rl.env.MATLABEnvironment
% RLMULTIPLEENVIRONMENT: 

    properties
        SubEnvironments (1, :) cell
    end
    properties(Access=protected)
        StepNum (1, 1) double {mustBeNonnegative}
        State
    end
    
    methods
        function this = rlMultipleEnvironment(subEnvs)
            arguments
                subEnvs (1, :) cell
            end
            
            % Validate subEnvs
            % subEnvsがすべて同じクラスであることを検証
            envNum = length(subEnvs);
            for i = 1 : envNum
                if ~isa(subEnvs{i}, class(subEnvs{1}))
                    error("subEnvs error! different env in context")
                end
            end
            
            ObservationInfo = getObservationInfo(subEnvs{1});
            ActionInfo = getActionInfo(subEnvs{1});
            
            this = this@rl.env.MATLABEnvironment(ObservationInfo, ActionInfo);
            
            this.SubEnvironments = subEnvs;
        end
        
        function [Observation,Reward,IsDone,LoggedSignals] = step(this,Action)
          
%             if this.StepNum <= 499
%                 [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{1}.step(Action);
%             elseif this.StepNum == 500
%                 this.SubEnvironments{2}.initState = this.State;
%                 this.SubEnvironments{2}.reset();
%                 [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{2}.step(Action);
%             elseif this.StepNum <= 999
%                 [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{2}.step(Action);
%             elseif this.StepNum == 1000
%                 this.SubEnvironments{1}.initState = this.State;
%                 this.SubEnvironments{1}.reset();
%                 [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{1}.step(Action);
%             elseif this.StepNum <= 1500
%                 [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{1}.step(Action);
%             end
            if this.StepNum <= 509
                [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{1}.step(Action);
            elseif this.StepNum == 510
                this.SubEnvironments{2}.initState = this.State;
                this.SubEnvironments{2}.reset();
                [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{2}.step(Action);
            elseif this.StepNum <= 1009
                [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{2}.step(Action);
            elseif this.StepNum == 1010
                this.SubEnvironments{1}.initState = this.State;
                this.SubEnvironments{1}.reset();
                [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{1}.step(Action);
            elseif this.StepNum <= 1500
                [Observation,Reward,IsDone,LoggedSignals] = this.SubEnvironments{1}.step(Action);
            end
            this.StepNum = this.StepNum + 1;
            this.State = Observation;
            
            % (optional) use notifyEnvUpdated to signal that the
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
        
        function initialObservation = reset(this)
            initialObservation = this.SubEnvironments{1}.reset();
            for i = 2 : length(this.SubEnvironments)
                this.SubEnvironments{i}.reset();
            end
            this.StepNum = 0;
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
    end
end