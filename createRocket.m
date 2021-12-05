%Sets up and returns a Sprite object for the rocket.
function rocket = createRocket()
    %Create rocket Sprite object
    rocket = SpriteKit.Sprite('rocket');

    %Set up the default state for the rocket and give it its image
    rocket.initState('hide', Const.noneImg, true); %hide rocket if needed
    rocket.initState('crash', Const.crashedRocketImg, true); %exploded rocket
    
    %Different throttle states. These allow displaying a different sized
    %frame depending on the thrust value.
    rocket.initState('thrust0', Const.rocketImg, true); %Cut throttle (no flame)
    rocket.initState('thrust1', Const.rocketThrust1Img, true); %Low throttle 
    rocket.initState('thrust2', Const.rocketThrust2Img, true); %Mid throttle
    rocket.initState('thrust3', Const.rocketThrust3Img, true); %High throttle
    
    %Give the rocket its necessary properties. These are per rocket in case
    %multiplayer is wanted in the future or in case multiple rocket models
    %would be wanted.
    addprop(rocket, 'velocity'); %1x2 velocity meters per second
    addprop(rocket, 'propMass'); %propellant mass kg
    addprop(rocket, 'dryMass'); %dry mass kg
    addprop(rocket, 'mass'); %total mass, kilograms
    addprop(rocket, 'fuelRate'); %fuel rate at max throttle kg/s
    addprop(rocket, 'maxThrust'); %maximum thrust, N
    addprop(rocket, 'throttle'); %throttle, 0 to 1
    addprop(rocket, 'throttleBuffer'); %key buffer for throttle keys
    addprop(rocket, 'rotBuffer'); %key buffer for rotation keys
    addprop(rocket, 'altitude'); %altitude, meters
    addprop(rocket, 'maxPropMass'); %maximum prop mass, kg
    addprop(rocket, 'specialBuffer'); %key buffer for pause, etc. keys
    %Game state is stored in the rocket so that it is easier to access for
    %other functions. As they are being passed the rocket anyway, it allows
    %them to read the game state without needing to pass it in explicitly.
    %Game state is stored as a string and regulates whether physics are
    %processed and what is shown on screen.
    addprop(rocket, 'gameState'); %game state: "play" "pause" "crash" "title" "tut1"
    addprop(rocket, 'zeroAltLocPx'); %zero altitude location in pixels
    addprop(rocket, 'score'); %game score
    
    %Initialize rocket physics and give it its values
    rocket.Location = Const.startingPosition;
    rocket.velocity = Const.startingVelocity;
    rocket.State = 'thrust0';
    rocket.Scale = Const.rocketScale;
    rocket.altitude = Const.startingAltitude;
    rocket.propMass = Const.startingPropMass;
    rocket.dryMass = Const.dryMass;
    rocket.mass = Const.startingPropMass + Const.dryMass;
    rocket.fuelRate = Const.fuelRate;
    rocket.maxThrust = Const.maxThrust;
    rocket.throttle = Const.startingThrottle;
    rocket.maxPropMass = Const.maxPropMass;
    rocket.gameState = Const.startingGameState;
    rocket.zeroAltLocPx = rocket.Location(2) - rocket.altitude * Const.pixelsPerMeter; 
    rocket.score = 0;
    rocket.Depth = Const.foregroundDepth;
    
    %These need to be initialized to 0 (empty) because they store control
    %inputs.
    rocket.throttleBuffer = 0;
    rocket.rotBuffer = 0;
    rocket.specialBuffer = 0;
end