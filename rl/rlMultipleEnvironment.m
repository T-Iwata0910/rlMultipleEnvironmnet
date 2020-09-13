function env = rlMultipleEnvironment(subEnv, contextSequence)
arguments
    subEnv (1, :) cell
    contextSequence (:, 1) double {mustBePositive, mustBeInteger}
end
env = rl.env.rlMultipleEnvironment(subEnv, contextSequence);
end