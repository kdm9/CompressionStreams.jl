using CompressionStreams



function dotest(fn, N)

    buf = Vector{UInt8}(2^20)

    for i in 1:N
        s = cstream(fn)
        red = readbytes!(s, buf)
    end

    assert(all(buf .== 0))

end


#@time dotest("1M.bin", 10)
#@time dotest("1M.bin.gz", 10)

@time dotest("1G.bin", 2)
@time dotest("1G.bin.gz", 2)
