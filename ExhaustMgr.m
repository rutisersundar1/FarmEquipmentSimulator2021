%Manages the particles representing the rocket's exhaust as they interact
%with the ground.
classdef ExhaustMgr 
    properties
        numParticles %Maximum number of particles
        particleList %Array of particles in use
        rocket %rocket to reference
        maxParticleAge %maximum particle age in frames
        despawnedAge %Age to set a particle to when it is despawned
        dragConst %drag constant, multiplied by velocity each frame.
    end

    methods
        %Constructor
        %Creates an ExhaustMgr object and initializes its particle list
        function obj = ExhaustMgr(rocket)
            obj.numParticles = Const.numParticles;
            obj.particleList = zeros(obj.numParticles);
            obj.rocket = rocket;
            obj.maxParticleAge = Const.maxParticleAge;
            obj.despawnedAge = Const.particleDespawnedAge;
            obj.dragConst = Const.particleDragConst;

            %Initialize the particle list
            for i = obj.particleList
                %part1, part2, etc.
                particleName = sprintf("part%.0f", i);
                ithParticle = SpriteKit.Sprite(particleName);

                initState(ithParticle, 'on', Const.exhaustImg, true);
                initState(ithParticle, 'off', Const.noneImg, true);

                addprop(ithParticle, 'velocity');
                addprop(ithParticle, 'age');

                ithParticle.Location = Const.defaultParticlePos;
                obj.particleList(i) = ithParticle;
            end

        end

        %Disables all managed particles.
        function killAllParticles(obj)
            %Iterate through the list of particles and disable all.
            for i = obj.particleList
                despawnParticle(obj.particleList(i));
            end
        end

        %Spawns a particle if possible.
        %position is the position to be spawned at, as [x,y]
        %velocity is [x,y] velocity to be spawned with.
        function spawnParticle(obj, position, velocity)
            %Find the index of the oldest particle.
            [~, targetIndex] = max(obj.particleList.age); %will this work? idk.

            %Select the target particle
            targetParticle = obj.particleList(targetIndex);

            targetParticle.State = 'on'; %Enable the target particle    
            targetParticle.age = 0;
            targetParticle.Location = position;
            targetParticle.velocity = velocity;
        end

        %Despawns the given particle. Note that particle should be a
        %particle Sprite object, not a particle index.
        function despawnParticle(obj, particle)
            particle.State = 'off';
            %Setting the age to a very high number allows this to be one of
            %the first particles when sorted by age.
            particle.age = obj.despawnedAge;
            particle.Location = [0,0];
        end
        
        %Scrolls all particles assigned to the manager and updates them.
        function scrollParticles(obj, x,y)
            particleScrollDist = [x,y];
            %Move every particle in this manager's list by the distance
            %specified
            for i = obj.particleList
                currentPart = obj.particleList(i);
                %Add the offset to each particle's location
                currentPart.Location = currentPart.Location + particleScrollDist;

                %If the particle is scrolled off screen, disable it.
                if (currentPart.Location(1) <= 0 ||... %left
                    currentPart.Location(1) >= Const.windowSize(1) ||... %right
                    currentPart.Location(2) <= 0 ||... %bottom
                    currentPart.Location(2) >= Const.winddowSize(2)) %top

                    despawnParticle(obj, currentPart); %disable particle
                end

                %Increment the age
                currentPart.age = currentPart.age + 1;
                %If the current particle's age is greater than the maximum,
                %disable it.
                if currentPart.age >= obj.maxParticleAge
                    despawnParticle(obj, currentPart); %disable particle
                end
            end
        end

        %To be called every frame. Updates all particles.
        function tickParticles(obj)


        end
    end
end