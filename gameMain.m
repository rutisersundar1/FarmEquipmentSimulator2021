%FARM EQUIPMENT SIMULATOR 2021
%BUY NOW

clear
clc

%%
%--------VALUES--------
%Changing rocket physics values
acceleration = [0,0]; %xy acceleration, meters per second squared.
velocity = [0,0]; %xy velocity, meters per second
position = [0,0]; %should not change since the rocket will be centered
rotation = 0; %degrees, positive is clockwise
throttle = 0; %0 to 1
mass = 0; %mass, kilograms
altitude = 0; %meters above sea level
prop_mass = 0; %mass of propellant in kilograms
engine_force = [0,0]; %engine force in newtons
gravity_force = [0,0]; %force of gravity in newtons

%--------CONSTANTS--------
throttle_inc = 0.1; %per frame
rotation_inc = 5; %degrees per frame

%ROCKET CONSTANTS
gravity = 9.806; %gravity, meters per second squared
dry_mass = 100000; %dry mass, kilograms
starting_prop_mass = 300000; %default prop mass, kilograms
isp = 350; %specific impulse, seconds

%COW CONSTANTS
cow_prop_mass = 1000; %mass of propellant given by cow, kilograms
cow_avg_dist = 1000; %average distance between cows, meters
cow_rand_max = 100; %maximum deviation from this average distance, meters

%%
%INITIALIZE GAME

keybuffer = keyBuffer(); %Buffer buffered keys with a key buffer.

game_figure = figure('Color', 'blue'); %Initialize the game figure.
set(game_figure, 'KeyPressFcn', @bufferKeys); %Assign the key buffer to handle key presses.

gameState = "paused"; %game state
prop_mass = starting_prop_mass;
mass = prop_mass + dry_mass;
altitude = 0;
rotation = 270;

%% 
%RUN GAME

while gameState ~= "crashed"
    frameStart = tic(); %start frame timer
    throttleinputs = getThrottleInput(keybuffer);
    rotInput = getRotInput(keybuffer);
    
    %Handle throttle inputs. z is max. x is cut.
    %w is increase, s is decrease
    switch(throttleinputs)
        case "z"
            throttle = 1;
        case "x" 
            throttle = 0;
        case "w" 
            throttle = throttle + throttle_inc * toc(frameStart);
        case "s"
            throttle = throttle - throttle_inc * toc(frameStart);
    end
    
    %Handle rotation inputs. Right is d and left is a.
    switch(rotInput)
        case "d"
            rotation = rotation + rotation_inc * toc(frameStart);
        case "a"
            rotation = rotation - rotation_inc * toc(frameStart);
    end
   
    %Constrain rotation between 0 and 360 by adding or subtracting 360.
    while rotation > 360
        rotation = rotation - 360;
    end
    
    while rotation < 0
        rotation = rotation + 360;
    end
    
end

%Just because I can't pass arguments in through a callback. Sigh.
function bufferKeys(~, event)
    bufferKeyInputs(keyBuffer, event);
end





