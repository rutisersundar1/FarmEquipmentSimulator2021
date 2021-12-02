%This function is called as a keyPressFcn callback whenever the user
%presses a key. It will assign different values to the rocket's three key
%buffers depending on what key was pressed. The main code can then read
%these values and decide what to do based on them - for example, rotate the
%rocket if the a key was pressed. It then needs to set the buffer back to
%zero, or else it will read it again next frame.
function bufferKeys(~, event, rocket)
            %Rotation keys
            switch event.Key
                case 'a' %a
                    rocket.rotBuffer = 1; %a key
                case 'd' %d
                    rocket.rotBuffer = 2; %d key
            end
            
            %Throttle keys
            switch event.Key
                case 'z' %z
                    rocket.throttleBuffer = 1; %z key
                case 'x' %x
                    rocket.throttleBuffer = 2; %x key
                case 'w' %w
                    rocket.throttleBuffer = 3; %w key
                case 's' %s
                    rocket.throttleBuffer = 4; %s key
            end
            
            switch event.Key
                case 'escape'
                    rocket.specialBuffer = 1; %pause
                case 'space'
                    rocket.specialBuffer = 2; %space to start game
                case 'q'
                    rocket.specialBuffer = 3; %quit game in pause menu
                case 'c'
                    rocket.specialBuffer = 99; %debug
            end
end