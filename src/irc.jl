module irc
include("tcp.jl")
using .tcp

using Printf

# exports
export irc_connect, irc_send, read_oauth_file, irc_auth, irc_join,
    irc_readlines


function irc_connect(tcp_sock, hostname, port)
    tcp_create_sock(tcp_sock)
    tcp_connect(tcp_sock, hostname, port)
    return Status(tcp_sock.status)
end

function irc_send(tcp_sock, buffer::String)
    buffer = buffer * '\r' * '\n'
    tcp_send(tcp_sock, buffer)
end

function read_oauth_file(filename::String)
    oauth = ""
    open(filename, "r") do file
        line = readline(file)
        oauth = line
    end
    return oauth
end

function irc_auth(tcp_sock, nick::String, oauth::String)
    buffer = ""
    buffer = @sprintf("PASS %s\r\n", oauth)
    irc_send(tcp_sock, buffer)

    buffer = @sprintf("NICK %s\r\n", nick)
    irc_send(tcp_sock, buffer)

end

function irc_join(tcp_sock, channel::String)
    buffer = ""
    buffer = @sprintf("JOIN #%s\r\n", channel)
    irc_send(tcp_sock, buffer)

end

function irc_readlines(tcp_sock)
    buffer = ""
    st, msg = tcp_recv(tcp_sock)
    buffer = msg
    # a = split(buffer, "\r\n")

    # while msg[1] == Status(8)
    #     # println(stdout, "aayyyy")
    #     temp = tcp_recv(tcp_sock)
    #     # buffer = buffer * temp[2]
    #     # println(stdout, buffer)
    #     # println(stdout, temp[1])
    # end
    # println(stdout, "Returning...")
    return st, msg
end

end # module
