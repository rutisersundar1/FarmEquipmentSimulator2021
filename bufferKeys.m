function bufferKeys(~, event)
            %Rotation keys
            switch event.Key
                case 97 %a
                    rocket.rotBuffer = 1; %a key
                case 100 %d
                    rocket.rotBuffer = 2; %d key
            end
            
            %Throttle keys
            switch event.Key
                case 122 %z
                    rocket.throttleBuffer = 1; %z key
                case 120 %x
                    rocket.throttleBuffer = 2; %x key
                case 119 %w
                    rocket.throttleBuffer = 3; %w key
                case 115 %s
                    rocket.throttleBuffer = 4; %s key
            end

end