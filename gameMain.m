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

%If the fuel gauge exists
fuelGaugeExists = 0;


%% Create Sprites
rocket = createRocket(Const);
cow = createCow(Const);

%% Run Game
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

%Set up the key buffering system
G.onKeyPress = {@bufferKeys, rocket};

%Show the title text if in the title game state.
if rocket.gameState == "title"
    titleText = text(Const.windowSize(1)/2, Const.windowSize(2)/2,...
    "Farm Equipment Simulator 2021");
end

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
            
            titleText.Visible = 'on'; %Show title text
            
            %Hide fuel gauge
            fuelGaugeRect.Visible = 'off';
            fuelFillRect.Visible = 'off';
            fuelText.Visible = 'off';
            
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
            
            %Hide title text
            titleText.Visible = 'off';

            %Make fuel gauge visible
            fuelGaugeRect.Visible = 'on';
            fuelFillRect.Visible = 'on';
            fuelText.Visible = 'on';
            
            %% Rocket Physics
            rocket.State = 'rocket1'; %Show the rocket
            
            %Check for pausing the game.
            if rocket.specialBuffer == 1
                rocket.gameState = 'pause';
                rocket.specialBuffer = 0;
            end
            
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
end
end
