using Test
using TropicalNumbers

@testset "TropicalMaxMin max min" begin
    @test TropicalMaxMin(3) * TropicalMaxMin(4) == TropicalMaxMin(3)
    @test TropicalMaxMin(3) + TropicalMaxMin(4) == TropicalMaxMin(4)
    @test TropicalMaxMin(4) + TropicalMaxMin(1) == TropicalMaxMin(4)
    @test zero(TropicalMaxMin(2)) == TropicalMaxMin(neginf(Int))
    @test zero(TropicalMaxMin(2.0)) == TropicalMaxMin(-Inf)
    @test one(TropicalMaxMin(2)) == TropicalMaxMin(posinf(Int))
    @test TropicalMaxMin(2.0) ≈ TropicalMaxMin(2.0 + 1e-10)
    @test TropicalMaxMin(2) ≈ TropicalMaxMin(2.0)
    @test TropicalMaxMinF32(2.0).n isa Float32
    @test TropicalMaxMinF16(2.0).n isa Float16
    @test TropicalMaxMinF64(2.0).n isa Float64
    @test TropicalMaxMinI32(2).n isa Int32
    @test TropicalMaxMinI16(2).n isa Int16
    @test TropicalMaxMinI64(2).n isa Int64

    @test TropicalMaxMin(0//3) * TropicalMaxMin(1//3) == TropicalMaxMin(0//3)
    @test TropicalMaxMin(1//3) * TropicalMaxMin(0//3) == TropicalMaxMin(0//3)
    @test TropicalMaxMin(1//3) * TropicalMaxMin(1//3) == TropicalMaxMin(1//3)

    @test TropicalMaxMin(1//3) * TropicalMaxMin(1//0) == TropicalMaxMin(1//3)
    @test TropicalMaxMin(1//0) * TropicalMaxMin(1//1) == TropicalMaxMin(1//1)
    @test content(TropicalMaxMin(3.0)) == 3.0
    @test TropicalMaxMin{Float32}(TropicalMaxMin(0.0)) isa TropicalMaxMin{Float32}
    println(TropicalMaxMinF64(3))

    # promote and convert
    t1 = TropicalMaxMin(2)
    t2 = TropicalMaxMin(2.0)
    @test TropicalMaxMinF64(t1) === TropicalMaxMin(2.0)
    @test promote(t1, t2) === (TropicalMaxMin(2.0), t2)

    @test content(TropicalMaxMinF64) == Float64

    @test promote(TropicalMaxMin{Float64}(1), TropicalMaxMin{Int64}(2)) == (TropicalMaxMin{Float64}(1), TropicalMaxMin{Float64}(2))
    @test promote(TropicalMaxMin{Float64}(1)) == (TropicalMaxMin{Float64}(1),)
    @test promote_type(TropicalMaxMin{Float64}, TropicalMaxMinF32) == TropicalMaxMinF64
    @test promote_type(TropicalMaxMin{Float64}, TropicalMaxMinF32, TropicalMaxMin{Int32}) == TropicalMaxMinF64

    x = TropicalMaxMin(2.0)
    @test x * true == x * one(x)
    @test x * false == x * zero(x)
    @test true * x == one(x) * x
    @test false * x == zero(x) * x
    @test isnan(TropicalMaxMin(NaN))
    @test !isnan(TropicalMaxMin(Inf))
end
