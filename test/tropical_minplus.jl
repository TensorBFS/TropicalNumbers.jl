using Test
using TropicalNumbers

@testset "tropical min plus" begin
    @test TropicalMinPlus(3) * TropicalMinPlus(4) == TropicalMinPlus(7)
    @test TropicalMinPlus(3) + TropicalMinPlus(4) == TropicalMinPlus(3)
    @test TropicalMinPlus(4) + TropicalMinPlus(-1) == TropicalMinPlus(-1)
    @test zero(TropicalMinPlus(2)).n .> 99999
    @test zero(TropicalMinPlus(2.0)) == TropicalMinPlus(Inf)
    @test one(TropicalMinPlus(2)) == TropicalMinPlus(0)
    @test TropicalMinPlus(2.0) ≈ TropicalMinPlus(2.0 + 1e-10)
    @test TropicalMinPlus(2) ≈ TropicalMinPlus(2.0)
    @test TropicalMinPlusF32(2.0).n isa Float32
    @test TropicalMinPlusF16(2.0).n isa Float16
    @test TropicalMinPlusF64(2.0).n isa Float64
    @test TropicalMinPlusI32(2).n isa Int32
    @test TropicalMinPlusI16(2).n isa Int16
    @test TropicalMinPlusI64(2).n isa Int64

    @test TropicalMinPlus(0//3) * TropicalMinPlus(1//3) == TropicalMinPlus(1//3)
    @test TropicalMinPlus(1//3) * TropicalMinPlus(0//3) == TropicalMinPlus(1//3)
    @test TropicalMinPlus(1//3) * TropicalMinPlus(1//3) == TropicalMinPlus(2//3)

    @test TropicalMinPlus(1//3) * TropicalMinPlus(1//0) == TropicalMinPlus(1//0)
    @test TropicalMinPlus(1//3) * TropicalMinPlus(-1//0) == TropicalMinPlus(-1//0)
    @test TropicalMinPlus(1//0) * TropicalMinPlus(1//1) == TropicalMinPlus(1//0)
    @test TropicalMinPlus(-1//0) * TropicalMinPlus(-1//1) == TropicalMinPlus(-1//0)
    @test content(TropicalMinPlus(3.0)) == 3.0
    @test TropicalMinPlus{Float32}(TropicalMinPlus(0.0)) isa TropicalMinPlus{Float32}
    println(TropicalMinPlusF64(3))

    # promote and convert
    t1 = TropicalMinPlus(2)
    t2 = TropicalMinPlus(2.0)
    @test TropicalMinPlusF64(t1) === TropicalMinPlus(2.0)
    @test promote(t1, t2) === (TropicalMinPlus(2.0), t2)

    @test content(TropicalMinPlusF64) == Float64

    @test promote(TropicalMinPlus{Float64}(1), TropicalMinPlus{Int64}(2)) == (TropicalMinPlus{Float64}(1), TropicalMinPlus{Float64}(2))
    @test promote(TropicalMinPlus{Float64}(1)) == (TropicalMinPlus{Float64}(1),)
    @test promote_type(TropicalMinPlus{Float64}, TropicalMinPlusF32) == TropicalMinPlusF64
    @test promote_type(TropicalMinPlus{Float64}, TropicalMinPlusF32, TropicalMinPlus{Int32}) == TropicalMinPlusF64

    @test TropicalMinPlus(3) / TropicalMinPlus(4) == TropicalMinPlus(-1)
    @test TropicalMinPlus(3) ÷ TropicalMinPlus(4) == TropicalMinPlus(-1)
    @test inv(TropicalMinPlus(3)) == TropicalMinPlus(-3)

    x = TropicalMinPlus(2.0)
    @test x * true == x * one(x)
    @test x / true == x / one(x)
    @test x ÷ true == x ÷ one(x)
    @test x * false == x * zero(x)
    @test x / false == x / zero(x)
    @test x ÷ false == x ÷ zero(x)
    @test true * x == one(x) * x
    @test true / x == one(x) / x
    @test true ÷ x == one(x) ÷ x
    @test false * x == zero(x) * x
    @test false / x == zero(x) / x
    @test false ÷ x == zero(x) ÷ x
    @test isnan(TropicalMinPlus(NaN))
    @test !isnan(TropicalMinPlus(-Inf))

    @test TropicalMinPlus(2.0) ^ 3.0 == TropicalMinPlus(2.0) * TropicalMinPlus(2.0) * TropicalMinPlus(2.0)
    @test TropicalMinPlus(2.0) ^ 3 == TropicalMinPlus(2.0) * TropicalMinPlus(2.0) * TropicalMinPlus(2.0)
end
