
%% FARMING EQUIPMENT SIMULATOR 3021
%% A GAME ABOUT FARMING WITH... HEAVIER EQUIPMENT
clear
clc

%% 
%CONSTANTS
orbit_altitude_required = 100000; %karman line, meters
orbit_horiz_speed_required = 7800; %orbit speed meters per second. might be used

cow_prop_mass = 1000; %mass of propellant given by cow, kilograms
cow_avg_dist = 1000; %average distance between cows, meters
cow_rand_max = 100; %maximum deviation from this average distance, meters

gravity = 9.806; %gravity, meters per second squared
dry_mass = 100000; %dry mass, kilograms
starting_prop_mass = 300000; %default prop mass, kilograms
isp = 350; %specific impulse, seconds

%keys
pause_key = "esc";
rotate_right_key = "d";
rotate_left_key = "a";
throttle_inc_key = "shift";
throttle_dec_key = "ctrl";
throttle_max_key = "z";
throttle_cut_key = "x";

%%
%CHANGING VALUES
points = 0; %game score

%Rocket physics values
acceleration = [0,0]; %xy acceleration, meters per second squared.
velocity = [0,0]; %xy velocity, meters per second
position = [0,0]; %should not change since the rocket will be centered
rotation = 0; %degrees, positive is counterclockwise
throttle = 0; %0 to 1
altitude = 0; %meters above sea level
rocket_mass = 0; %kilograms
prop_mass = 0;

engine_force = [0,0];
gravity_force = [0,0];

game_state = "prelaunch";
%"prelaunch"
%"flight"
%"crashed"
%"paused"
%"orbit"

%% 
%INITIALIZE GAME
prop_mass = starting_prop_mass;
mass = prop_mass + dry_mass;
altitude = 0;


