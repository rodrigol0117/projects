function wildfire_simulation_mean(p, n, maxt, maxr, windDir, windIntensity)
    % Initialize the matrix
    Mmean = zeros(n,n,maxt);
    %wildfire_analysis('init', [], [], n, maxt, maxr);
    
    for iter = 1:maxr
        % Initialize the matrix
        M = zeros(n);
        M(round(n/2), round(n/2)) = 1; % Start the fire in the center
        % Example of setting an initial fire, adjust as needed

        for k=1:maxt
            Mnew = propagate_onestep(M, p, n, windDir, windIntensity);
            M = Mnew;
            Mmean(:,:,k) = Mmean(:,:,k) + M;
            %wildfire_analysis('collect', M, k, n, maxt, maxr);
            
           
        end
    end
  
    Mmean = Mmean / maxr; % Average the results over all runs
    %Mmean

    %wildfire_analysis('analyze', [], [], n, maxt, maxr);
    
     for t = 1:maxt
        imagesc(Mmean(:,:,t)); colormap('default'); axis square; colorbar;
        title(sprintf('Time Step: %d', t));
        drawnow;
     end
     

end

function Mnew = propagate_onestep(M, p, n, windDir, windIntensity)
    Mnew = M; % Copy the current state to the new state
    for i=1:n
        for j=1:n
            if M(i,j) == 1 % If the cell is burning
                % Adjust probabilities based on wind direction and intensity
                for di = -1:1
                    for dj = -1:1
                        if i+di > 0 && i+di <= n && j+dj > 0 && j+dj <= n && M(i+di,j+dj) == 0
                            spreadProb = adjustProb(p, di, dj, windDir, windIntensity);
                            if rand() < spreadProb
                                Mnew(i+di,j+dj) = 1; % Catch fire
                            end
                        end
                    end
                end
            end
        end
    end
end

function spreadProb = adjustProb(p, di, dj, windDir, windIntensity)
    % Adjust the base probability based on wind direction and intensity
    adjustment = 0;
    % Cardinal directions
    if strcmp(windDir, 'N') && di == -1
        adjustment = windIntensity;
    elseif strcmp(windDir, 'S') && di == 1
        adjustment = windIntensity;
    elseif strcmp(windDir, 'E') && dj == 1
        adjustment = windIntensity;
    elseif strcmp(windDir, 'W') && dj == -1
        adjustment = windIntensity;
    % Intercardinal directions
    elseif strcmp(windDir, 'NW') && (di == -1 || dj == -1)
        adjustment = windIntensity / 2; % Adjusted for both axes, so intensity is halved
    elseif strcmp(windDir, 'NE') && (di == -1 || dj == 1)
        adjustment = windIntensity / 2;
    elseif strcmp(windDir, 'SW') && (di == 1 || dj == -1)
        adjustment = windIntensity / 2;
    elseif strcmp(windDir, 'SE') && (di == 1 || dj == 1)
        adjustment = windIntensity / 2;
    end
    spreadProb = min(1, max(0, p + adjustment)); % Ensure probability is between 0 and 1
end

