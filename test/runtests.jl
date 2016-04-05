using CompressionStreams
using BufferedStreams

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

datafile(fn) = Pkg.dir("CompressionStreams", "test", "data", fn)

@testset "Decompression of data.bin$ext" for ext in ("", ".gz")

    fn = datafile("1MiB_zeros.bin$ext")

    function read_and_check(stream)
        buf = Vector{UInt8}(2^20)
        @test readbytes!(stream, buf) == length(buf)
        @test all(buf .== 0)
    end

    @testset "File" begin
        s = cstream(fn)
        read_and_check(s)
    end

    @testset "IO" begin
        io = open(fn)
        s = cstream(io)
        read_and_check(s)
    end

    @testset "BufferedStream" begin
        bs = BufferedInputStream(open(fn))
        s = cstream(bs)
        read_and_check(s)
    end

end
     
