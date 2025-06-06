% Define simulation parameters
p = 0.3; % Base probability of fire spread
n = 20; % Size of the grid (n x n)
maxt = 5; % Maximum number of time steps
maxr = 1000; % Number of runs for averaging

% Define wind parameters
windDir = 'NE'; % Wind direction ('N', 'S', 'E', 'W', 'NW', 'SW', 'NE','SE',)
windIntensity = 0.4; % Wind intensity, affects spread probability

% Run the wildfire simulation with specified parameters and wind conditions
wildfire_simulation_mean(p, n, maxt, maxr, windDir, windIntensity);
