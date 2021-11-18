%Handles throttle inputs and constrains throttle between 0 and 1.
function throttleOut = calcThrottle(throttleInput, throttle, throttleInc, frameTime)
    %w is increase, s is decrease
    switch(throttleInput)
        case 1 %z key, max throttle
            throttleVal = 1;
        case 2 %x key, cut throttle
            throttleVal = 0;
        case 3 %w key, increase throttle
            throttleVal = throttle + throttleInc * frameTime;
        case 4 %s key, reduce throttle
            throttleVal = throttle - throttleInc * frameTime;
        otherwise
            throttleVal = throttle;
    end

    %Constrain throttle between 0 and 1.
    if throttleVal > 1
        throttleVal = 1;
    end

    if throttleVal < 0
        throttleVal = 0;
    end

    %Assign the working value to the output
    throttleOut = throttleVal;
end