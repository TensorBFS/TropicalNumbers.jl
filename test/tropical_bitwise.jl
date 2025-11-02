using Test
using TropicalNumbers

@testset "TropicalBitwise max mul" begin
    @test TropicalBitwise(3) * TropicalBitwise(4) == TropicalBitwise(0)
    @test TropicalBitwise(3) + TropicalBitwise(4) == TropicalBitwise(7)
    @test TropicalBitwise(4) + TropicalBitwise(1) == TropicalBitwise(5)
    @test zero(TropicalBitwise(2)) == TropicalBitwise(0)
    @test one(TropicalBitwise(2)) == TropicalBitwise(~0)
    @test TropicalBitwise(2) ≈ TropicalBitwise(2)
    @test TropicalBitwiseI32(2).n isa Int32
    @test TropicalBitwiseI16(2).n isa Int16
    @test TropicalBitwiseI64(2).n isa Int64

    @test content(TropicalBitwise(3)) == 3
    @test TropicalBitwise{UInt32}(TropicalBitwise(0)) isa TropicalBitwise{UInt32}
    println(TropicalBitwiseI64(3))

    # promote and convert
    t1 = TropicalBitwise(2)
    t2 = TropicalBitwise(UInt32(2))
    @test TropicalBitwiseI32(t1) === TropicalBitwise(Int32(2))
    @test promote(t1, t2) === (t1, t1)

    @test content(TropicalBitwiseI64) == Int64

    @test promote(TropicalBitwise{Int64}(1), TropicalBitwise{UInt64}(2)) == (TropicalBitwise{Int64}(1), TropicalBitwise{Int64}(2))
    @test promote(TropicalBitwise{Int64}(1)) == (TropicalBitwise{Int64}(1),)
    @test promote_type(TropicalBitwise{Int64}, TropicalBitwiseI32) == TropicalBitwiseI64
    @test promote_type(TropicalBitwise{Int64}, TropicalBitwiseI32, TropicalBitwise{UInt32}) == TropicalBitwiseI64

    x = TropicalBitwise(2)
    @test x * true == x * one(x)
    @test x * false == x * zero(x)
    @test true * x == one(x) * x
    @test false * x == zero(x) * x

    @test TropicalBitwise(0) < TropicalBitwise(10) <= TropicalBitwise(10) <= TropicalBitwise(~0)
end
