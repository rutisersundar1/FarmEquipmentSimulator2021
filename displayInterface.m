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

game_figure = figure('Color', 'blue');

set(game_figure, 'KeyPressFcn', @keyPressHandler)

function keyPressHandler(source, event)
   
    switch event.Key
        case 97
            disp("a");
        case 100
            disp("d");
    end
end
