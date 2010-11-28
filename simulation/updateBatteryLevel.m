function [B, rad] = updateBatteryLevel(B_0, task_demand)
% this function calculates the battery charge based on weather condition
% and the task energy demand

% input variables: current battery charge (B_0), task energy demand
% (task_demand)

% solar radiation intensity states (W/m^2)

G = [50 100 200];

% output current of the solar cell (A), based on SimElectronics model and
% aforentioned radiation intensity levels

I_c = [0.190 0.380 0.760];

% probability transition matrix

R = [0.70 0.15 0.15
    0.15 0.70 0.15
    0.15 0.15 0.70];

% initial weather condition
persistent radiation;           % keep persistent across function calls
if isempty(radiation)
    %initialize at first function call (if "clear functions" was called)
    initial_weather = randi(3);
    radiation = G(initial_weather);
end

% weather transition based on R

transition = rand();

if radiation == G(1)
        if (transition <= 0.7)
            radiation = G(1);                           % no transition 
            output_current = I_c(1);
        end
        if (transition > 0.7) && (transition <= 0.85)
            radiation = G(2);                           % transition from low to medium radiation
            output_current = I_c(2);
        end
        if (transition > 0.85)
            radiation = G(3);                           % transition from low to high radiation
            output_current = I_c(3);                    
        end
elseif radiation == G(2)
        if (transition <= 0.7)
            radiation = G(2);                           % no transition
            output_current = I_c(2);
        end
        if (transition > 0.7) && (transition <= 0.85)   
            radiation = G(1);                           % transition from medium to low radiation
            output_current = I_c(1);
        end
        if (transition > 0.85)          
            radiation = G(3);                           % transition from medium to high radiation
            output_current = I_c(2);
        end
elseif radiation == G(3)
        if (transition <= 0.7)                         
            radiation = G(3);                           % no transition
            output_current = I_c(3);
        end
        if (transition > 0.7) && (transition <= 0.85)  
            radiation = G(1);                           % transition from high to low radiation
            output_current = I_c(1);
        end
        if (transition > 0.85)                         
            radiation = G(2);                           % transition from high to medium radiation
            output_current = I_c(2);
        end
end 

% battery charge (considering delta_t = 1s)

B = B_0 + output_current;

% cap on battery charge level

if B >= 12
    B = 12;
end
      
% battery discharge due to task execution (considering delta_t = 1s)

B = B - task_demand;
rad = radiation;

end

    




