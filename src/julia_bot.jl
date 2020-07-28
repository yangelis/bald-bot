module julia_bot

include("tcp.jl")
include("irc.jl")

using .irc
using .tcp

using Sockets


export bot_run

hostname = "irc.chat.twitch.tv"
nick = "baldiobot"
channel = "john_pft"
port = 6667

function bot_run()
    tcp_sock = TCPSocket(;delay=true)
    oauth = read_oauth_file("pass.oauth")
    err = irc_connect(tcp_sock, hostname, port)
    println(stdout, "irc_connect: ", err)
    err = irc_auth(tcp_sock, nick, oauth)
    println(stdout, "irc_auth: ", err)
    err = irc_join(tcp_sock, channel)
    println(stdout, "irc_join: ", err)
    println(stdout, "Initialise:")
    while true
        msg = ""
        err, msg = irc_readlines(tcp_sock)
        if err == Status(6)
            break
        end
        if msg != nothing
            println(stdout, msg)
        end

        # irc_send(tcp_sock, "PONG")
        sleep(1)
    end # while
    st = tcp_close_sock(tcp_sock)
    print(stdout, "Closing with status: ", st)

end


end # module