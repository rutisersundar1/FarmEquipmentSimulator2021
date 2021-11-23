function spawnCow(rocket, cow)
    if cow.State == "off"
        cow.State = 'on';
        
        %If the rocket is moving to the right, spawn on the right side
        if rocket.velocity(1) <= 0
            %Spawn on the right side of the screen
            cow.Location = [Const.windowSize(1) - Const.cowSpawnMargin, Const.cowSpawnY];
        else %If it's moving to the left, spawn on the left side
            %Spawn on the left side of the screen
            cow.Location = [Const.cowSpawnMargin, Const.cowSpawnY];
        end
        
        cow.xToNextCow = randi(Const.cowRandVals); %reset cow-nter
    end
end