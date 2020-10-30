using CUDA
using ForwardDiff
using GemmKernels
using LinearAlgebra

# ----
# WMMATropical
# ----

struct WMMATropicalOp{M, N, K} end

@inline GemmKernels.shape(::Type{WMMAOp{M, N, K}}) where {M, N, K} = (M = M, N = N, K = K)

# convert_index_func: function used to transpose the index in case of a row-major layout
for (layout_type, wmma_layout_type, convert_index_func) in [
                                        (Layout.AlignedColMajor, WMMA.ColMajor, identity),
                                        (Layout.AlignedRowMajor, WMMA.RowMajor, x -> reverse(Tuple(x)))
                                       ]
    @eval begin
        @inline fragtype_a(::Type{WMMAOp{16, 16, 16}}, ::Type{$layout_type{Float16}}) = WMMA.Fragment{16, 16, 16, 16, Float16, $wmma_layout_type, WMMA.MatrixA}
        @inline fragtype_b(::Type{WMMAOp{16, 16, 16}}, ::Type{$layout_type{Float16}}) = WMMA.Fragment{16, 16, 16, 16, Float16, $wmma_layout_type, WMMA.MatrixB}
        @inline fragtype_accum(::Type{WMMAOp{16, 16, 16}}, ::Type{$layout_type{Float32}}) = WMMA.Fragment{16, 16, 16, 8, Float32, WMMA.Unspecified, WMMA.Accumulator}

        @inline function load_a(::Type{WMMAOp{M, N, K}}, ::Type{$layout_type{Float16}}, workspace, tile::Tile) where {M, N, K}
            conf = WMMA.Config{M, N, K, Float32}

            linear_base = linearise($convert_index_func(tile.base), size(workspace))
            linear_offset = linearise($convert_index_func(tile.offset), size(workspace))

            ptr = pointer(workspace, linear_base) + (linear_offset - 1) * sizeof(Float16)
            return WMMA.load_a(ptr, size(workspace, 1), $wmma_layout_type, conf)
        end

        @inline function load_b(::Type{WMMAOp{M, N, K}}, ::Type{$layout_type{Float16}}, workspace, tile::Tile) where {M, N, K}
            conf = WMMA.Config{M, N, K, Float32}

            linear_base = linearise($convert_index_func(tile.base), size(workspace))
            linear_offset = linearise($convert_index_func(tile.offset), size(workspace))

            ptr = pointer(workspace, linear_base) + (linear_offset - 1) * sizeof(Float16)
            return WMMA.load_b(ptr, size(workspace, 1), $wmma_layout_type, conf)
        end

        @inline function load_c(::Type{WMMAOp{M, N, K}}, ::Type{$layout_type{Float32}}, workspace, tile::Tile) where {M, N, K}
            conf = WMMA.Config{M, N, K, Float32}

            linear_base = linearise($convert_index_func(tile.base), size(workspace))
            linear_offset = linearise($convert_index_func(tile.offset), size(workspace))

            ptr = pointer(workspace, linear_base) + (linear_offset - 1) * sizeof(Float32)
            return WMMA.load_c(ptr, size(workspace, 1), $wmma_layout_type, conf)
        end

        @inline function store_d(::Type{WMMAOp{M, N, K}}, ::Type{$layout_type{Float32}}, workspace, frag, tile::Tile) where {M, N, K}
            conf = WMMA.Config{M, N, K, Float32}

            linear_base = linearise($convert_index_func(tile.base), size(workspace))
            linear_offset = linearise($convert_index_func(tile.offset), size(workspace))

            ptr = pointer(workspace, linear_base) + (linear_offset - 1) * sizeof(Float32)
            WMMA.store_d(ptr, frag, size(workspace, 1), $wmma_layout_type, conf)
        end
    end
end

function mma(::Type{WMMAOp{M, N, K}}, a_frag, b_frag, c_frag) where {M, N, K}
    conf = WMMA.Config{M, N, K, Float32}
    return WMMA.mma(a_frag, b_frag, c_frag, conf)
end



struct WMMADualOp{M, N, K} end

@inline shape(::Type{WMMADualOp{M, N, K}}) where {M, N, K} = (M = M, N = N, K = K)

@inline fragtype_a(::Type{WMMADualOp{16, 16, 16}}, ::Type{Layout.SplitColMajor{Float16}}) = NTuple{2, WMMA.Fragment{16, 16, 16, 16, Float16, WMMA.ColMajor, WMMA.MatrixA}}
@inline fragtype_b(::Type{WMMADualOp{16, 16, 16}}, ::Type{Layout.SplitColMajor{Float16}}) = NTuple{2, WMMA.Fragment{16, 16, 16, 16, Float16, WMMA.ColMajor, WMMA.MatrixB}}
@inline fragtype_accum(::Type{WMMADualOp{16, 16, 16}}, ::Type{Layout.SplitColMajor{Float32}}) = NTuple{2, WMMA.Fragment{16, 16, 16, 8, Float32, WMMA.Unspecified, WMMA.Accumulator}}

@inline function load_a(::Type{WMMADualOp{M, N, K}}, ::Type{Layout.SplitColMajor{Float16}}, workspace, tile::Tile) where {M, N, K}
    conf = WMMA.Config{16, 16, 16, Float32}
    ind = linearise(tile.index, (size(workspace)[1], size(workspace)[2]))

    return (WMMA.load_a(pointer(workspace, ind), size(workspace)[1], WMMA.ColMajor, conf),
            WMMA.load_a(pointer(workspace, ind + size(workspace)[1] * size(workspace)[2]), size(workspace)[1], WMMA.ColMajor, conf))
end

@inline function load_b(::Type{WMMADualOp{M, N, K}}, ::Type{Layout.SplitColMajor{Float16}}, workspace, tile::Tile) where {M, N, K}
    conf = WMMA.Config{16, 16, 16, Float32}
    ind = linearise(tile.index, (size(workspace)[1], size(workspace)[2]))

    return (WMMA.load_b(pointer(workspace, ind), size(workspace)[1], WMMA.ColMajor, conf),
            WMMA.load_b(pointer(workspace, ind + size(workspace)[1] * size(workspace)[2]), size(workspace)[1], WMMA.ColMajor, conf))
end

@inline function load_c(::Type{WMMADualOp{M, N, K}}, ::Type{Layout.SplitColMajor{Float32}}, workspace, tile::Tile) where {M, N, K}
    conf = WMMA.Config{M, N, K, Float32}
    ind = linearise(tile.index, (size(workspace)[1], size(workspace)[2]))

    return (WMMA.load_c(pointer(workspace, ind), size(workspace)[1], WMMA.ColMajor, conf),
            WMMA.load_c(pointer(workspace, ind + size(workspace)[1] * size(workspace)[2]), size(workspace)[1], WMMA.ColMajor, conf))
end

@inline function store_d(::Type{WMMADualOp{M, N, K}}, ::Type{Layout.SplitColMajor{Float32}}, workspace, frag, tile::Tile) where {M, N, K}
    conf = WMMA.Config{M, N, K, Float32}
    ind = linearise(tile.index, (size(workspace)[1], size(workspace)[2]))

    WMMA.store_d(pointer(workspace, ind), frag[1], size(workspace)[1], WMMA.ColMajor, conf)
    WMMA.store_d(pointer(workspace, ind + size(workspace)[1] * size(workspace)[2]), frag[2], size(workspace)[1], WMMA.ColMajor, conf)
end

@inline function mma(::Type{WMMADualOp{M, N, K}}, a_frag, b_frag, c_frag) where {M, N, K}
    conf = WMMA.Config{16, 16, 16, Float32}

    c_re = c_frag[1]
    c_du = c_frag[2]

    c_re = WMMA.mma(a_frag[1],  b_frag[1], c_re, conf)

    c_du = WMMA.mma(a_frag[1], b_frag[2], c_du, conf)
    c_du = WMMA.mma(a_frag[2], b_frag[1], c_du, conf)

    return (c_re, c_du)
end
################################################################################

@testset "Matmul API" begin
    @test_if "wmma" @testset "WMMA GEMM ($( !transpose_a ? 'N' : 'T' )$( !transpose_b ? 'N' : 'T' ))" for transpose_a = [false, true],
        transpose_b = [false, true]

        @testset "(M = $M, N = $N, K = $K)" for (M, N, K) in [(128, 128, 128), (256, 256, 128), (128, 128, 256), (256, 256, 256), (2048, 2048, 2048)]
            alpha = 2
            beta  = 3

            a_h = rand(Float16, (M, K)) / sqrt(Float16(K))
            b_h = rand(Float16, (K, N)) / sqrt(Float16(K))
            c_h = rand(Float32, (M, N))

            # Transpose input if necessary
            a_h = transpose_a ? transpose(a_h) : a_h
            b_h = transpose_b ? transpose(b_h) : b_h

            a   = CuArray(a_h)
            b   = CuArray(b_h)
            c   = CuArray(c_h)
            d   = similar(c)

            conf = GemmKernels.get_config(
                                          gemm_shape = (M = M, N = N, K = K),
                                          operator = Operator.WMMAOp{16, 16, 16},
                                          global_a_layout = transpose_a ? Layout.AlignedRowMajor{Float16} : Layout.AlignedColMajor{Float16},
                                          global_b_layout = transpose_b ? Layout.AlignedRowMajor{Float16} : Layout.AlignedColMajor{Float16},

                                          global_c_layout = Layout.AlignedColMajor{Float32},
                                          global_d_layout = Layout.AlignedColMajor{Float32},

                                          is_a_col_major = !transpose_a,
                                          is_b_col_major = !transpose_b,
                                         )

            GemmKernels.matmul(a, b, c, d, conf;
                               transform_shared_to_regs_a = Transform.Elementwise(x -> x * alpha),
                               transform_shared_to_regs_c = Transform.Elementwise(x -> x * beta),
                               kernel = Kernel.matmul_pipelined
                              )

            # Transpose outputs, if necessary
            new_a_h = transpose_a ? transpose(a_h) : a_h
            new_b_h = transpose_b ? transpose(b_h) : b_h

            @test all(isapprox.(alpha * Float32.(new_a_h) * Float32.(new_b_h) + beta * c_h, Array(d); rtol = sqrt(eps(Float16))))
        end
    end

    @test_if "dual" @testset "WMMA Dual GEMM" begin
        @testset "(M = $M, N = $N, K = $K)" for (M, N, K) in [(128, 128, 128), (256, 256, 256), (2048, 2048, 2048)]
            a_h = rand(Complex{Float16}, (M, K)) / sqrt(Float16(K));
            b_h = rand(Complex{Float16}, (K, N)) / sqrt(Float16(K));
            c_h = rand(Complex{Float32}, (M, N));

            a = CuArray(a_h);
            b = CuArray(b_h);
            c = CuArray(c_h);
            d = similar(c);

            conf = GemmKernels.get_config(
                                          gemm_shape = (M = M, N = N, K = K),
                                          operator = Operator.WMMADualOp{16, 16, 16},

                                          global_a_layout = Layout.InterleavedColMajor{Float16},
                                          global_b_layout = Layout.InterleavedColMajor{Float16},
                                          global_c_layout = Layout.InterleavedColMajor{Float32},
                                          global_d_layout = Layout.InterleavedColMajor{Float32},

                                          shared_a_layout = Layout.Padded{Layout.SplitColMajor{Float16}, 8},
                                          shared_b_layout = Layout.Padded{Layout.SplitColMajor{Float16}, 8},
                                          shared_c_layout = Layout.SplitColMajor{Float32},
                                          shared_d_layout = Layout.SplitColMajor{Float32},

                                          warps_per_block = 8,

                                          compute_warp = (M = 16, N = 32, K = 16),

                                          block_shape = (M = 64, N = 64, K = 32),

                                          mem_a_warp = (M = 64, K = 2),
                                          mem_b_warp = (K = 32, N = 4),
                                          mem_cd_warp = (M = 64, N = 1),

                                          mem_a_thread = (M = 4, K = 1),
                                          mem_b_thread = (K = 4, N = 1),
                                          mem_cd_thread = (M = 2, N = 1)
                                         )

            GemmKernels.matmul(a, b, c, d, conf;
                               kernel = Kernel.matmul_pipelined)

            a_dual = reinterpret(ForwardDiff.Dual{Float32,Float32,1}, Complex{Float32}.(a_h))
            b_dual = reinterpret(ForwardDiff.Dual{Float32,Float32,1}, Complex{Float32}.(b_h))
            c_dual = reinterpret(ForwardDiff.Dual{Float32,Float32,1}, c_h)
            d_dual = reinterpret(ForwardDiff.Dual{Float32,Float32,1}, Array(d))

            @test all(isapprox.(a_dual * b_dual + c_dual, d_dual; rtol=sqrt(eps(Float16))));
        end
    end
end