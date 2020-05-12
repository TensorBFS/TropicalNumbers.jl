using Test
using TropicalNumbers

@testset "tropical" begin
    @test Tropical(3) * Tropical(4) == Tropical(7)
    @test Tropical(3) + Tropical(4) == Tropical(4)
    @test Tropical(4) + Tropical(-1) == Tropical(4)
    @test zero(Tropical(2)).n .< -999999
    @test zero(Tropical(2.0)) == Tropical(-Inf)
    @test one(Tropical(2)) == Tropical(0)
    @test Tropical(2.0) ≈ Tropical(2.0 + 1e-10)
    @test Tropical(2) ≈ Tropical(2.0)
    @test TropicalF32(2.0).n isa Float32
    @test TropicalF16(2.0).n isa Float16
    @test TropicalF64(2.0).n isa Float64

    @test Tropical(0//3) * Tropical(1//3) == Tropical(1//3)
    @test Tropical(1//3) * Tropical(0//3) == Tropical(1//3)
    @test Tropical(1//3) * Tropical(1//3) == Tropical(2//3)

    @test Tropical(1//3) * Tropical(1//0) == Tropical(1//0)
    @test Tropical(1//3) * Tropical(-1//0) == Tropical(-1//0)
    @test Tropical(1//0) * Tropical(1//1) == Tropical(1//0)
    @test Tropical(-1//0) * Tropical(-1//1) == Tropical(-1//0)
end
