classdef rlMultipleEnvironment < rl.env.MATLABEnvironment
% RLMULTIPLEENVIRONMENT: 

    properties
        SubEnvironments (1, :) cell
    end
    properties(Access=protected)
        StepNum (1, 1) double {mustBeNonnegative}
        State
        ContextSequence (:, 1) double {mustBePositive, mustBeInteger}
    end
    
    methods
        function this = rlMultipleEnvironment(subEnvs, contextSequence)
            arguments
                subEnvs (1, :) cell
                contextSequence (:, 1) double {mustBePositive, mustBeInteger}
            end
            
            % Validate subEnvs
            % subEnvsがすべて同じクラスであることを検証
            envNum = length(subEnvs);
            for i = 1 : envNum
                if ~isa(subEnvs{i}, class(subEnvs{1}))
                    error("subEnvs error! different env in context")
                end
            end
            
            % Validate contextSequence
            if (max(contextSequence) > envNum)
                error("Context Squence is out of range!!");
            end
            
            ObservationInfo = getObservationInfo(subEnvs{1});
            ActionInfo = getActionInfo(subEnvs{1});
            
            this = this@rl.env.MATLABEnvironment(ObservationInfo, ActionInfo);
            
            this.SubEnvironments = subEnvs;
            this.ContextSequence = contextSequence;
        end
        
        function [Observation,Reward,IsDone,LoggedSignals] = step(this,Action)
            activeEnv = this.SubEnvironments{this.ContextSequence(this.StepNum+1)};
            
            activeEnv.State = this.State;
            [Observation,Reward,IsDone,LoggedSignals] = step(activeEnv, Action);
            
            this.StepNum = this.StepNum + 1;
            this.State = Observation;
            
            % (optional) use notifyEnvUpdated to signal that the
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
        
        function initialObservation = reset(this)
            % REVISIT: 初期状態観測はコンテキスト1のものでいいのか?
            initialObservation = this.SubEnvironments{1}.reset();
            for i = 2 : length(this.SubEnvironments)
                this.SubEnvironments{i}.reset();
            end
            this.StepNum = 0;
            this.State = initialObservation;
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
    end
end