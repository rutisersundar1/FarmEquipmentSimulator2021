
%% FARMING EQUIPMENT SIMULATOR 3021
%% A GAME ABOUT FARMING WITH... HEAVIER EQUIPMENT
%% 

%CONSTANTS
%orbit_altitude_required = 100000; %karman line, meters
%orbit_horiz_speed_required = 7800; %orbit speed meters per second. might be used


gravity = 9.806; %gravity, meters per second squared
dry_mass = 100000; %dry mass, kilograms
starting_prop_mass = 300000; %default prop mass, kilograms
isp = 350; %specific impulse, seconds

%%
%CHANGING VALUES
points = 0; %game score

engine_force = [0,0];
gravity_force = [0,0];

%% 
%INITIALIZE GAME
prop_mass = starting_prop_mass;
mass = prop_mass + dry_mass;
altitude = 0;


