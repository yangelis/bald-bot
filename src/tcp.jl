using Base: StatusUninit, StatusInit, StatusConnecting, StatusOpen,
    StatusClosing, StatusClosed, StatusActive, StatusEOF, StatusPaused
using Sockets


@enum(Status, uninit=StatusUninit, init=StatusInit, connecting=StatusConnecting,
      opened=StatusOpen, act=StatusActive, closing=StatusClosing,
      closed=StatusClosed, Eof=StatusEOF, paused=StatusPaused)


function tcp_create_sock(tcp_sock)
    tcp_sock = TCPSocket()
end


function tcp_close_sock(tcp_sock)
    tcp_sock.status = StatusClosed
    return Status(tcp_sock.status)
end

function tcp_connect(tcp_sock, hostname::String, port::Integer)
    Sockets.connect!(tcp_sock, hostname, port)
    return Status(tcp_sock.status)
end

function tcp_send(tcp_sock, buffer::String)
    # tcp_sock.sendbuf = IOBuffer(buffer)
    write(tcp_sock, buffer)
    return Status(tcp_sock.status)
end

function tcp_recv(tcp_sock)
    num_frames = read(tcp_sock, 256)
    # tcp_sock.buffer.data = Array{UInt8,1}()
    # tcp_sock.buffer.size = 512
    @debug tcp_sock.buffer = IOBuffer()
    msg = Vector{Char}()
    foreach(x->push!(msg, Char(x)), num_frames)
    # println(stdout, tcp_sock.buffer)
    return Status(tcp_sock.status), String(msg)

    # frame_lengths = UInt64[read(tcp_sock, UInt64) for i in 1:num_frames]
    # frames = Vector{UInt8}[read(tcp_sock, length) for length in frame_lengths]
    # header, byte_msg = map(x->!isempty(x) ? unpack(x) : nothing, frames)
    # return read_msg(byte_msg)

end

function read_msg(msg::Vector{UInt8})::Union{String, Vector{UInt8}}
    result = convert(String, msg)
    if !isvalid(String, result)
        return msg
    end
    return result
end
