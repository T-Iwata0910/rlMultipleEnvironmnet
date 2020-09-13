function env = rlMultipleEnvironment(subEnv)
arguments
    subEnv (1, :) cell
end
env = rl.env.rlMultipleEnvironment(subEnv);
end