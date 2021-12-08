# FarmEquipmentSimulator2021
A game written in MatLab that simulates rather expensive farm equipment.

Supports:
Windows 10 or 11 x64
MATLAB R2021b

Welcome to Farm Equipment Simulator 2021!

Gameplay instructions:
You are a farmer flying your rocket to plow a field. To get more points, fly closer to the ground or at a larger angle from vertical.
The game ends when you crash, so try to fly for as long as possible!

Using the A and D keys, rotate your rocket left and right.
The Z key sets full throttle and the X key will cut your throttle.

Keep an eye on your fuel with the meter on the left. If your fuel runs out, you will fall and crash!
To replenish your fuel, hit cows that are wandering around your field to get more methane to burn!
Remember that when you have more fuel, your rocket is heavier and will accelerate more slowly with the same amount of thrust.

To pause, press the escape key. When paused, crashed, or in the title screen, press the Q key to close the game.

Farm Equipment Simulator 2021 was made by Adam Rike, Jonah Robles, and Ranga Rutiser Sundar.

Farm Equipment Simulator 2021 uses Steve McClure's SpriteKit Framework for sprites, background, and collision:
Steve McClure (2021). SpriteKit Framework (https://www.mathworks.com/matlabcentral/fileexchange/46643-spritekit-framework), MATLAB Central File Exchange. Retrieved November 29, 2021.

Farm Equipment Simulator 2021 was created for the Software Design Project as part of The Ohio State University's ENGR 1181 Fundamentals of Engineering course. The software comes with no warranty and will not be supported past its due date.

Main functions:
gameMain handles all game logic, physics, scoring, etc.
Const is an object to store game constants, such as gravity, the maximum number of particles drawn, the rocket's dry mass, and the like.
ExhaustMgr is an admittedly clunky object-oriented weirdness that should have been written procedurally. I'm sorry. -Ranga. Oh, and it does everything the exhaust system needs. All exhaust particles are children of this object.
Seriously, I'm questioning why I wrote this as an object in the first place. It doesn't represent anything real that the user interacts with so OOP makes no sense here. 
I would rewrite it in a better way but I have finals to study for, so we'll leave it in its clunky but functional form for now.
bufferKeys is assigned as a keyPressFcn callback. This means it is called every time the user presses a key. It stores this key press to the rocket's key buffer. gameMain can then read it when needed.

The "Assets" folder contains all .png images used for the various sprites, title screens, and backgrounds for the game.
The "GIMP files" folder contains the .xcf files used to create these, which makes editing them more convenient.
The "Old" folder contains several older files from before the game was rewritten to use the SpriteKit Framework. They are not likely to function correctly, as pretty much all the code has been rewritten since then.
The "Docs" folder contains some documentation regarding the game, though the most accurate documentation will likely be that on the website, u.osu.edu/fe1181au21sec28321g/.

