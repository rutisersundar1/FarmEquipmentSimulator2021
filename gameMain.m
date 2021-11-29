%FARM EQUIPMENT SIMULATOR 2021
%BUY NOW!

function gameMain
clear
clc

%All constants are in Const.m.

%% Initialize Game with SpriteKit
%Initialize Game object
G = SpriteKit.Game.instance('Title', 'Farm Equipment Simulator 2021', 'Size', Const.windowSize);

%Initialize Background object
bkg = SpriteKit.Background(Const.backgroundImg);
bkg.Scale = Const.backgroundScale;

%% Create Sprites
%Rocket and cow (gameplay sprites)
rocket = createRocket(Const);
cow = createCow(Const);

rocket.Depth = 10; %In the middle
cow.Depth = 0; %Behind the rocket

%Title/pause screen sprite
titleSprite = SpriteKit.Sprite('title');

titleSprite.initState('titleScreen', Const.titleScreenImg, true);
titleSprite.initState('pauseScreen', Const.pauseScreenImg, true);
titleSprite.initState('hide', Const.noneImg, true);

titleSprite.Depth = 100; %Make sure this is always on top

%% Create non-SpriteKit UI elements
%Create fuel gauge
%Outline rectangle that shows the maximum size
fuelGaugeRect = rectangle('Position',...
    [Const.fuelGaugeOffset, Const.fuelGaugeWidth,...
    Const.fuelGaugeMaxHeight]);

fuelGaugeHeight = Const.fuelGaugeMaxHeight *...
    rocket.propMass / rocket.maxPropMass;

%Fill rectangle that shows how much propellant you have
fuelFillRect = rectangle('Position',...
    [Const.fuelGaugeOffset, Const.fuelGaugeWidth,...
    fuelGaugeHeight]);

%Set colors for fill and edge and set line widths
fuelFillRect.FaceColor = Const.fuelGaugeFillColor;
fuelFillRect.EdgeColor = Const.fuelGaugeEdgeColor;
fuelFillRect.LineWidth = Const.fuelGaugeLineWidth;

fuelGaugeRect.EdgeColor = Const.fuelGaugeEdgeColor;
fuelGaugeRect.LineWidth = Const.fuelGaugeLineWidth;

%Draw the label for the fuel gauge
fuelText = text(Const.fuelTextX, Const.fuelTextY, "Fuel");
fuelText.FontSize = 14;

%Create throttle gauge
throtGaugeRect = rectangle('Position', Const.throtGaugeRectPos);
throtGaugeRect.EdgeColor = Const.throtGaugeEdgeColor;
throtGaugeRect.LineWidth = Const.throtGaugeLineWidth;

%Create throttle gauge fill rectangle
throtFillRect = rectangle('Position', Const.throtGaugeRectPos);
throtFillRect.Position(3) = rocket.throttle * Const.throtGaugeWidth;
throtFillRect.EdgeColor = Const.throtGaugeEdgeColor;
throtFillRect.FaceColor = Const.throtGaugeFillColor;
throtFillRect.LineWidth = Const.throtGaugeLineWidth;

%Throttle gauge label text
throtText = text(Const.throtTextX, Const.throtTextY, "Throttle");
throtText.FontSize = 16;

%Altitude text, initialized to blank.
altitudeText = text(Const.altTextX, Const.altTextY, "");
altitudeText.FontSize = 16;

%Debug text for debugging
debugText = text(Const.debugTextX, Const.debugTextY, "");

%% Run Game
%Set up the key buffering system
G.onKeyPress = {@bufferKeys, rocket};

titleSprite.State = 'hide';

G.play(@action); %Run game

%% Action to be run every frame
function action 
    
    %Different game states.
    %Valid game states: 'title', 'play', 'pause', 'crash'
    %Note that once title is left it is not designed to be returned to.
    switch rocket.gameState
     
        case 'title' %When on the title screen
            %% Title Screen
            rocket.State = 'hide'; %hide the rocket
            cow.State = 'off'; %hide the cow
            titleSprite.State = 'titleScreen'; %show title screen
            
            %Hide fuel gauge
            fuelGaugeRect.Visible = 'off';
            fuelFillRect.Visible = 'off';
            fuelText.Visible = 'off';
            
            throtGaugeRect.Visible = 'off';
            throtFillRect.Visible = 'off';
            throtText.Visible = 'off';
            
            altitudeText.Visible = 'off';
            
            %Take special buffer key inputs
            switch rocket.specialBuffer
                case 2 %Spacebar (start game)

                    
                    %Update fuel gauge fill height
                    fuelGaugeHeight = Const.fuelGaugeMaxHeight * rocket.propMass / rocket.maxPropMass;
                    fuelFillRect.Position(4) = fuelGaugeHeight;
                    
                    %Set the rocket's game state so that next frame the
                    %game will start
                    rocket.gameState = 'play';
                case 3 %q key, stop game
                    G.stop(); %stop gameplay execution
                    close(gcf); %Close the current figure (the game)
            end
        
            %Clear the key buffers
            rocket.throttleBuffer = 0;
            rocket.rotBuffer = 0;
            rocket.specialBuffer = 0;
            
        case 'pause' %When paused
            %% Pause Screen
            titleSprite.State = 'pauseScreen';
            %Check for resuming or quitting the game.
            switch rocket.specialBuffer
                case 1 %esc key, resume game
                    rocket.gameState = 'play';
                    rocket.specialBuffer = 0;
                    
                case 3 %q key, quit game
                    G.stop();
                    close(gcf);  
            end
            
        case 'play' %In gameplay
            
            %Hide title/pause screen
            titleSprite.State = 'hide';

            %Make fuel gauge visible
            fuelGaugeRect.Visible = 'on';
            fuelFillRect.Visible = 'on';
            fuelText.Visible = 'on';
            
            %Make throttle gauge visible
            throtGaugeRect.Visible = 'on';
            throtFillRect.Visible = 'on';
            throtText.Visible = 'on';
            
            altitudeText.Visible = 'on'; %altimeter text
            
            %% Rocket Physics
            rocket.State = 'rocket1'; %Show the rocket
            
            %Check for pausing the game.
            if rocket.specialBuffer == 1
                rocket.gameState = 'pause';
                rocket.specialBuffer = 0;
            end
            
            %Debug key handling
            if rocket.specialBuffer == 99
                %Forcibly spawn a cow to test spawning behavior
                if Const.debugForceSpawnCow
                    cow.State = 'off'; %turn the cow off so it can be respawned
                    spawnCow(rocket, cow);
                end
            end
            
            rocket.specialBuffer = 0;
            
            %Read key inputs from the buffer and update throttle and rotation.
            %calcThrottle and calcRotation handle constraining the throttle and
            %rotation between their needed values.
            calcThrottle(rocket);
            calcRotation(rocket);
            
            %Handle throttle: check for propellant out, calculate thrust vector,
            %and subtract propellant.
            if rocket.propMass <= 0
                rocket.propMass = 0;
                thrust_v = [0,0];
            else
                %Calculate thrust
                thrust_s = rocket.maxThrust * rocket.throttle; %scalar thrust value, Newtons
                thrust_v = [thrust_s * sind(rocket.Angle),...
                    thrust_s * cosd(rocket.Angle)]; %vector thrust force, Newtons
                
                %amount of propellant consumed this frame
                propConsumed = rocket.fuelRate * rocket.throttle * Const.frameTime;
                
                %subtract consumed propellant and set mass
                rocket.propMass = rocket.propMass - propConsumed; %kg
                
                if rocket.propMass < 0
                    rocket.propMass = 0;
                end
                
                %This was originally in a separate if statement, but for some
                %reason that completely destroyed performance at low fuel levels. I
                %have no clue why. FPS dropped to 8 to 20 from 30, but putting it
                %here fixes that.
                
                %draw fuel gauge
                fuelGaugeHeight = Const.fuelGaugeMaxHeight * rocket.propMass / rocket.maxPropMass;
                fuelFillRect.Position(4) = fuelGaugeHeight;
            end
            
            %Update altitude text
            altitudeText.String = sprintf("Altitude: %.0f m", rocket.altitude);
            
            %Update throttle gauge
            throtFillWidth = Const.throtGaugeWidth * rocket.throttle;
            throtFillRect.Position(3) = throtFillWidth;
            
            %Update the rocket's total mass.
            rocket.mass = rocket.propMass + rocket.dryMass; %kg
            %disp(rocket.mass);
            %Calculate the forces acting on the rocket
            gravityForce = [0, rocket.mass * Const.gravity]; %force of gravity, Newtons
            
            netForce = thrust_v + gravityForce; %net force, Newtons
            
            acceleration = netForce / rocket.mass; %acceleration, m/s^2
            
            rocket.velocity = rocket.velocity + acceleration * Const.frameTime; %m/s
            
            %Rough approximation of friction
            rocket.velocity = rocket.velocity * Const.frictionMultiplier; %m/s
            
            delta_pos = rocket.velocity * Const.frameTime; %change in position this frame, meters
            
            rocket.altitude = rocket.altitude + delta_pos(2); %increment altitude
            
            %% Background
            %Scroll the background horizontally. It requires a positive value, so we do this.
            if delta_pos(1) < 0
                bkg.scroll('right', abs(delta_pos(1) * Const.pixelsPerMeter));
            elseif delta_pos(1) > 0
                bkg.scroll('left', abs(delta_pos(1) * Const.pixelsPerMeter));
            end
            
            %Scroll the background vertically. It requires a positive value, so we do this.
            if delta_pos(2) < 0
                bkg.scroll('up', abs(delta_pos(2) * Const.pixelsPerMeter));
            elseif delta_pos(2) > 0
                bkg.scroll('down', abs(delta_pos(2) * Const.pixelsPerMeter));
            end
            
            %% Cow Handling            
            %Scroll the cow
            cow.Location = cow.Location + [1, -1] .* delta_pos * Const.pixelsPerMeter;
            %fprintf("cow location %i, %i", cow.Location(1), cow.Location(2));
            
            %Add the x-movement to the cow's counter
            cow.xToNextCow = cow.xToNextCow - abs(delta_pos(1));
            
            %If the rocket has travelled far enough since the last cow or is low on fuel,
            %spawn a new one
            if (cow.xToNextCow <= 0) || rocket.propMass < Const.propCowPity
                spawnCow(rocket, cow);
            end
            
            %Check that the cow is not way off screen
            %It's possible that the cow goes through the collision sprites around
            %the screen otherwise. Maybe.
            if cow.Location(1) < -Const.cowKillMargin
                cow.State = 'off';
            elseif cow.Location(1) > Const.windowSize(1) + Const.cowKillMargin
                cow.State = 'off';
            %Removed kill for above and below screen
            elseif cow.Location(2) > Const.windowSize(2) + Const.cowKillMargin
                cow.State = 'off';
            elseif cow.Location(2) < -Const.cowKillMargin
                cow.State = 'off';
            end
            
            %Check the cow's collisions
            [collide, target] = SpriteKit.Physics.hasCollision(cow);
            if collide
                switch target.ID
                    %Give the rocket propellant if it hits the cow
                    case 'rocket'
                        %Only give propellant if the cow is enabled (otherwise,
                        %it's a 1x1 transparent png and its position is irrelevant
                        if cow.State == "on"
                            %Give the rocket more propellant
                            rocket.propMass = rocket.propMass + cow.propAmt;
                            
                            %Make sure the rocket doesn't exceed its maximum
                            %propellant mass
                            if rocket.propMass > rocket.maxPropMass
                                rocket.propMass = rocket.maxPropMass;
                            end
                            
                            cow.xToNextCow = randi(Const.cowRandVals); %Reset the counter for next cow spawn
                            cow.State = 'off';
                        end
                end
            end

    case 'crash' %Rocket crashed/game over
        
    end 
    
    debugString = "";
    
    if Const.debugShowRocketPos
       debugString = sprintf("Rocket Position %.0f, %.0f \n ", rocket.Location(1), rocket.Location(2));
    end
    
    if Const.debugShowGameState
        debugString = debugString + "Game State " + rocket.gameState + " \n";
    end
    
    if Const.debugShowCowPos
        debugString = debugString + sprintf("Cow Position %.0f, %.0f \n", cow.Location(1), cow.Location(2));
    end
    
    debugText.String = debugString;
end
end
