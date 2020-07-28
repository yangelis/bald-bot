using Sockets

include("tcp.jl")
include("irc.jl")

hostname = "irc.chat.twitch.tv"
nick = "baldiobot"
channel = "john_pft"
port = 6667

function main()
    tcp_sock = TCPSocket(;delay=true)
    # tcp_sock.buffer.size = 700

    oauth = read_oauth_file("src/oauth.txt")
    err = irc_connect(tcp_sock, hostname, port)
    println(stdout, "irc_connect: ", err)
    err = irc_auth(tcp_sock, nick, oauth)
    println(stdout, "irc_auth: ", err)
    err = irc_join(tcp_sock, channel)
    println(stdout, "irc_join: ", err)
    err, msg = irc_readlines(tcp_sock)
    println(stdout, "Initialise:")
    println(stdout, msg)
    while true
        # println(stdout, "Into the loop")
        # println(stdout, "status:", err)
        # println(stdout, tcp_sock)
        msg = ""
        err, msg = irc_readlines(tcp_sock)
        # tcp_sock.status = StatusOpen
        if err == Status(6)
            break
        end
        # irc_send(tcp_sock, "PONG")
        # println(stdout, "status:", err)
        println(stdout, msg)
        # tcp_sock.buffer.size = 512
        sleep(0.5)
    end # while
    st = tcp_close_sock(tcp_sock)
    print(stdout, "Closing with status: ", st)

end
