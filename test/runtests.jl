using TropicalNumbers
using Test

@testset "tropical" begin
    include("tropical.jl")
end

@testset "counting_tropical" begin
    include("counting_tropical.jl")
end

@testset "config_tropical" begin
    include("config_tropical.jl")
end
