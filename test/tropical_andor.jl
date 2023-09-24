using Test
using TropicalNumbers

@testset "tropical and or" begin
    @test TropicalAndOr(true) * TropicalAndOr(true) == TropicalAndOr(true)
    @test TropicalAndOr(true) * TropicalAndOr(false) == TropicalAndOr(false)
    @test TropicalAndOr(false) * TropicalAndOr(true) == TropicalAndOr(false)
    @test TropicalAndOr(false) * TropicalAndOr(false) == TropicalAndOr(false)

    @test TropicalAndOr(true) + TropicalAndOr(true) == TropicalAndOr(true)
    @test TropicalAndOr(true) + TropicalAndOr(false) == TropicalAndOr(true)
    @test TropicalAndOr(false) + TropicalAndOr(true) == TropicalAndOr(true)
    @test TropicalAndOr(false) + TropicalAndOr(false) == TropicalAndOr(false)

    @test inv(TropicalAndOr(true)) == TropicalAndOr(false)  
    @test inv(TropicalAndOr(false)) == TropicalAndOr(true)  

    @test zero(TropicalAndOr) == TropicalAndOr(false)
    @test one(TropicalAndOr) == TropicalAndOr(true)

    println(TropicalAndOr(true))
end
