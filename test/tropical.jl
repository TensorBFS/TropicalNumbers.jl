using Test
using TropicalNumbers

@testset "tropical" begin
    @test Tropical(3) * Tropical(4) == Tropical(7)
    @test Tropical(3) + Tropical(4) == Tropical(4)
    @test Tropical(4) + Tropical(-1) == Tropical(4)
    @test zero(Tropical(2)).n .< -99999
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
    @test content(Tropical(3.0)) == 3.0
    @test Tropical{Float32}(Tropical(0.0)) isa Tropical{Float32}
    println(TropicalF64(3))

    # promote and convert
    t1 = Tropical(2)
    t2 = Tropical(2.0)
    @test TropicalF64(t1) === Tropical(2.0)
    @test promote(t1, t2) === (Tropical(2.0), t2)

    @test content(TropicalF64) == Float64

    @test promote(Tropical{Float64}(1), Tropical{Int64}(2)) == (Tropical{Float64}(1), Tropical{Float64}(2))
    @test promote(Tropical{Float64}(1)) == (Tropical{Float64}(1),)
    @test promote_type(Tropical{Float64}, TropicalF32) == TropicalF64
    @test promote_type(Tropical{Float64}, TropicalF32, Tropical{Int32}) == TropicalF64
end
