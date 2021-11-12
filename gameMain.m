%Display and interface code for FES21.
%Should manage inputs from user
%Probably don't use the simpleGameEngine key input methods, as they pause
%execution of the entire program to wait for input.
%OOh matlab has a nice way to do things

%key definitions
%a = 97
%d = 100
%s = 73
%w = 119

keybuffer = keyBuffer(); %Buffer buffered keys with a key buffer.

game_figure = figure('Color', 'blue'); %Initialize the game figure.
set(game_figure, 'KeyPressFcn', @bufferKeys); %Assign the key buffer to handle key presses.

gameState = "paused";

while gameState ~= "paused"
    throttleinputs = getThrottleInput(keybuffer);
    rotInput = getRotInput(keybuffer);
end

%Just because I can't pass arguments in through a callback. Sigh.
function bufferKeys(~, event)
    bufferKeyInputs(keyBuffer, event);
end





