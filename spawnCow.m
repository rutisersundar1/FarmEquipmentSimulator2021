%Spawns the cow on screen. When not enabled, the cow is just invisible and
%intangible, and it continues to be moved. This sets it to be visible and
%places it on screen where needed.
function spawnCow(rocket, cow)
    if cow.State == "off"
        if rand() <= Const.cowFlyChance
            cow.State = 'fly';
            cow_init_alt = randi(Const.cowFlyRandAlts);
            cow_init_y = Const.zeroAlt + cow_init_alt * Const.pixelsPerMeter;
        else
            cow.State = 'on';        
            cow_init_y = Const.zeroAlt + Const.cowSpawnAlt * Const.pixelsPerMeter;
        end
        
        %This method is no longer used since vertical scrolling is
        %disabled.
        %Rocket altitude over the ground in pixels
        %rocket_alt_px = rocket.altitude * Const.pixelsPerMeter;
        %Pizel location of the zero altitude
        %zero_alt_px = rocket.Location(2) - rocket_alt_px;
        %Cow initial y, pixels
        %cow_init_y = zero_alt_px + (Const.cowSpawnAlt * Const.pixelsPerMeter);

        %Set the initial y value


        %The cow should always spawn in the direction the rocket is moving-
        %otherwise, it would just be scrolled off screen immediately. 

        %If the rocket is moving to the right, spawn on the right side
        if rocket.velocity(1) <= 0
            %Spawn on the right side of the screen
            cow.Location = [Const.windowSize(1) - Const.cowSpawnMargin, cow_init_y];
        else %If it's moving to the left, spawn on the left side
            %Spawn on the left side of the screen
            cow.Location = [Const.cowSpawnMargin, cow_init_y];
        end
        
        %The cow-nter tracks how far the rocket has moved since the last
        %cow was spawned. When it reaches zero, it's time to spawn a new
        %cow. This resets it to a random value between the cow random
        %values defined in Const.
        cow.xToNextCow = randi(Const.cowRandVals); %reset cow-nter
    end
end