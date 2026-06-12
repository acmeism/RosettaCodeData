using StaticArrays, Plots, NBodySimulator

const stablebodies = [MassBody(SVector(0.0, 1.0, 0.0), SVector( 5.775e-6, 0.0, 0.0), 2.0),
                      MassBody(SVector(0.0,-1.0, 0.0), SVector(-5.775e-6, 0.0, 0.0), 2.0)]
const bodies = [
    MassBody(SVector(0.0, 1.0, 0.0), SVector( 5.775e-6, 0.0, 0.0), 2.0),
    MassBody(SVector(0.0,-1.0, 0.0), SVector(-5.775e-6, 0.0, 0.0), 2.0),
    MassBody(SVector(0.0, 4.5, 0.0), SVector(-2.5e-6, 0.0, 0.0), 1.0)
]

const G = 6.673e-11  # m^3/kg/s^2
const timespan = (0.0, 1111150.0)

function nbodysim(nbodies, tspan)
    system = GravitationalSystem(nbodies, G)
    simulation = NBodySimulation(system, tspan)
    run_simulation(simulation)
end

simresult = nbodysim(bodies, timespan)
plot(simresult)
