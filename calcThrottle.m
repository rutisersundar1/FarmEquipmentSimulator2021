%Handles throttle inputs and constrains throttle between 0 and 1.
function calcThrottle(rocket)
    %w is increase, s is decrease
    switch(rocket.throttleBuffer)
        case 1 %z key, max throttle
            throttleVal = 1;
        case 2 %x key, cut throttle
            throttleVal = 0;
        case 3 %w key, increase throttle
            throttleVal = rocket.throttle + Const.throttleInc * Const.frameTime;
        case 4 %s key, reduce throttle
            throttleVal = rocket.throttle - Const.throttleInc * Const.frameTime;
        otherwise
            throttleVal = rocket.throttle;
    end

    %Constrain throttle between 0 and 1.
    if throttleVal > 1
        throttleVal = 1;
    end

    if throttleVal < 0
        throttleVal = 0;
    end

    %Assign the working value to the output
    rocket.throttle = throttleVal;
    rocket.throttleBuffer = 0; %Clear the throttle buffer
end