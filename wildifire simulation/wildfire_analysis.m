%function wildfire_analysis(action, M, timestep, n, maxt, iter)
    persistent allFires allSpreadRates totalFiresPerRun;
    
    % Initialize persistent variables if they're empty
    if isempty(allSpreadRates)
        allSpreadRates = [];
    end
    if isempty(totalFiresPerRun)
        totalFiresPerRun = zeros(1, maxt);
    end
    if isempty(allFires)
        allFires = zeros(n, n, 0);
    end
    
    switch action
        case 'init'
            % Explicitly reset persistent variables on initialization
            allFires = zeros(n, n, 0);
            allSpreadRates = [];
            totalFiresPerRun = zeros(1, maxt);
            
        case 'collect'
            % Ensure M is not empty before proceeding
            if ~isempty(M)
                currentFireCount = sum(M(:) == 1);
                if timestep > 1
                    % Calculate the spread rate based on the difference from the previous timestep
                    previousFireCount = sum(allFires(:, :, end) == 1);
                    allSpreadRates = [allSpreadRates, currentFireCount - previousFireCount];
                end
                allFires(:,:,end+1) = M;
                totalFiresPerRun(timestep) = totalFiresPerRun(timestep) + currentFireCount;
            end
            
        case 'analyze'
            % Calculate and display average spread rate
            averageSpreadRate = mean(allSpreadRates);
            disp(['Average Spread Rate: ', num2str(averageSpreadRate), ' cells per timestep.']);
            
            % Calculate total and average fire count
            totalFireCount = sum(totalFiresPerRun);
            averageFireCount = totalFireCount / (iter * maxt);
            disp(['Total Fire Count: ', num2str(totalFireCount)]);
            disp(['Average Fire Count per Timestep: ', num2str(averageFireCount), ' cells.']);
            
            % Calculate the average number of fires per timestep across all runs
            averageFiresPerTimestep = totalFiresPerRun / iter;
            
            % Visualization of Fire Spread
            figure;
            imagesc(mean(allFires, 3));
            title('Average Fire Spread');
            colormap('hot'); colorbar;
            axis square;
            
            
            % Visualization of Spread Rate Over Time
            figure;
            plot(allSpreadRates);
            title('Spread Rate Over Time');
            xlabel('Time Step');
            ylabel('Cells');
            grid on;
            
            
          
            % Visualization of Average Fire Counts Over Time
            figure;
            plot(averageFiresPerTimestep);
            title('Average Fire Counts Over Time');
            xlabel('Time Step');
            ylabel('Average Fire Count');
            grid on;
            
            
            % Reset persistent variables for the next batch of runs
            allFires = zeros(n, n, 0);
            allSpreadRates = [];
            totalFiresPerRun = zeros(1, maxt);
    end
end

