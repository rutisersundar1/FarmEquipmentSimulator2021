
%An object that handles key presses
classdef keyBuffer
    
    properties (Access = private)
        bufferedThrottle %buffered throttle, z x w s
        bufferedRot %buffered rotation, either a or d
    end
    
    methods
        function obj = keyBuffer()
            %Initialize the key buffer object
            obj.bufferedThrottle = 0;
            obj.bufferedRot = 0;
        end
        
        %Add key inputs to the buffer. This should be called as a
        %keyPressFcn callback.
        function obj = bufferKeyInputs(obj, event)
            %Rotation keys
            switch event.Key
                case 97 %a
                    obj.bufferedRot = 1; %a key
                case 100 %d
                    obj.bufferedRot = 2; %d key
                otherwise
                    obj.bufferedRot = 0; %no input
            end
            
            %Throttle keys
            switch event.Key
                case 122 %z
                    obj.bufferedThrottle = 1; %z key
                case 120 %x
                    obj.bufferedThrottle = 2; %x key
                case 119 %w
                    obj.bufferedThrottle = 3; %w key
                case 115 %s
                    obj.bufferedThrottle = 4; %s key
                otherwise
                    obj.bufferedThrottle = 0; %no input
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
        
        %Empty the key buffer after its values are used.
        function obj = emptyBuffer(obj)
            %zero is no input
            obj.bufferedThrottle = 0;
            obj.bufferedRot = 0;
        end
    end
        
end
