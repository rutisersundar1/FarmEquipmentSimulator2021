
%An object that handles key presses
classdef keyBuffer
    
    properties (Access = private)
        bufferedThrottle %buffered throttle, z x w s
        bufferedRot %buffered rotation, either a or d
    end
    
    methods
        function obj = keyBuffer()
            %Initialize the key buffer object
        end
        
        %Add key inputs to the buffer. This should be called as a
        %keyPressFcn callback.
        function bufferKeyInputs(source, event)
            %Rotation keys
            switch event.Key
                case 97 %a
                    obj.bufferedRot = "a";
                case 100 %d
                    obj.bufferedRot = "d";
            end
            
            %Throttle keys
            switch event.Key
                case 122 %z
                    obj.bufferedThrottle = "z";
                case 120 %x
                    obj.bufferedThrottle = "x";
                case 119 %w
                    obj.bufferedThrottle = "w";
                case 115 %s
                    obj.bufferedThrottle = "s";
            end
        end
        
        %Return the throttle input keys as a character.
        function throttleInput = getThrottleInput(obj)
            throttleInput = obj.bufferedThrottle;
        end
        
        %Return the rotation input keys as a character.
        function rotInput = getRotInput(obj)
            rotInput = obj.bufferedRot;
        end
    end
        
end
