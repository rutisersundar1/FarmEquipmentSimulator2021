function bufferKeys(source, event)
            %Rotation keys
            switch event.Key
                case 97 %a
                    source.UserData.bufferedRot = 1; %a key
                case 100 %d
                    source.UserData.bufferedRot = 2; %d key
            end
            
            %Throttle keys
            switch event.Key
                case 122 %z
                    source.UserData.bufferedThrottle = 1; %z key
                case 120 %x
                    source.UserData.bufferedThrottle = 2; %x key
                case 119 %w
                    source.UserData.bufferedThrottle = 3; %w key
                case 115 %s
                    source.UserData.bufferedThrottle = 4; %s key
            end

end