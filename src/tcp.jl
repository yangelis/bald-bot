# based on the tcp part of DonHo's bot
# https://github.com/DonHonerbrink/bruhbot

using Base: StatusUninit, StatusInit, StatusConnecting, StatusOpen,
    StatusClosing, StatusClosed, StatusActive, StatusEOF, StatusPaused
using Sockets

# exports
# export Status, tcp_create_sock, tcp_close_sock, tcp_connect, tcp_send, tcp_recv

@enum(Status, uninit=StatusUninit, init=StatusInit, connecting=StatusConnecting,
      opened=StatusOpen, act=StatusActive, closing=StatusClosing,
      closed=StatusClosed, Eof=StatusEOF, paused=StatusPaused)

function tcp_create_sock(tcp_sock::TCPSocket)
    tcp_sock = TCPSocket()
end

function tcp_close_sock(tcp_sock::TCPSocket)
    tcp_sock.status = StatusClosed
    return Status(tcp_sock.status)
end

function tcp_connect(tcp_sock::TCPSocket, hostname::String, port::Integer)
    Sockets.connect!(tcp_sock, hostname, port)
    return Status(tcp_sock.status)
end

function tcp_send(tcp_sock::TCPSocket, buffer::String)
    write(tcp_sock, buffer)
    return Status(tcp_sock.status)
end

function tcp_recv(tcp_sock::TCPSocket)
    line = ""
    line = seek_sock(tcp_sock)
    if line != ""
        return Status(tcp_sock.status), line
    else
        return Status(tcp_sock.status), nothing
    end
end

function seek_sock(tcp_sock::TCPSocket)
    line = ""
    @async begin
        while !eof(tcp_sock)
            line = readline(tcp_sock)
            println(stdout, line)
        end
    end
    return line
end

function read_msg(msg::Vector{UInt8})::Union{String, Vector{UInt8}}
    result = convert(String, msg)
    if !isvalid(String, result)
        return msg
    end
    return result
end

