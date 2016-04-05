module CompressionStreams

using BufferedStreams
using Libz

export cstream

const MAGIC_TYPES = Dict(
    UInt8[0x1f, 0x8b] => ZlibInflateInputStream
)

function cstream(filename::Union{ASCIIString, UTF8String})
    bs = BufferedInputStream(open(filename))
    return cstream(bs)
end

function cstream(io::IO)
    bs = BufferedInputStream(io)
    return cstream(bs)
end

function cstream(bs::BufferedInputStream)
    compress_type = detect_type(bs)
    if compress_type == :Void
        return bs
    end
    return compress_type(bs)
end

function detect_type(stream::BufferedInputStream)
    buf = Vector{UInt8}(256)
    peekbytes!(stream, buf)
    for (magic, ztype) in MAGIC_TYPES
        if buf[1:length(magic)] == magic
            return ztype
        end
    end
    return :Void
end

end # module
