%Scrolls and updates the list of particles given
function scrollParticles (particleList, delta_Pos, particleLifespan)
    for particle = particleList
        particle.Location = particle.Location + delta_Pos;
        particle.lifetime = particle.lifetime + 1;
        
        if particle.lifetime >= particleLifespan
            
        end
    end
end