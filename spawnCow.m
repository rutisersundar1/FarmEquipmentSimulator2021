function spawnCow(rocket, cow)
    if cow.State == "off"
        cow.State = 'on';
        
        %Rocket altitude over the ground in pixels
        rocket_alt_px = rocket.altitude * Const.pixelsPerMeter;
        %Cow initial y (may be off screen)
        cow_init_y = rocket.Location(2) - rocket_alt_px + Const.cowSpawnAlt;        
        
        %If the rocket is moving to the right, spawn on the right side
        if rocket.velocity(1) <= 0
            %Spawn on the right side of the screen
            cow.Location = [Const.windowSize(1) - Const.cowSpawnMargin, cow_init_y];
        else %If it's moving to the left, spawn on the left side
            %Spawn on the left side of the screen
            cow.Location = [Const.cowSpawnMargin, cow_init_y];
        end
        
        cow.xToNextCow = randi(Const.cowRandVals); %reset cow-nter
    end
end