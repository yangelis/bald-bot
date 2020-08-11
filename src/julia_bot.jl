module julia_bot

include("irc.jl")
include("repl.jl")

using .irc
using .repl

using Sockets, Base.Threads

export bot_run

const hostname = "irc.chat.twitch.tv"
const nick = "baldiobot"
const port = 6667

function bot_run()
    tcp_sock = TCPSocket(;delay=true)
    oauth::String = read_oauth_file("pass.oauth")
    err = irc_connect(tcp_sock, hostname, port)
    println(stdout, "irc_connect: ", err)
    err = irc_auth(tcp_sock, nick, oauth)
    println(stdout, "irc_auth: ", err)
    Threads.@spawn local_repl(tcp_sock)
    println(stdout, "Initialise:")
    err, msg = irc_readlines(tcp_sock)
end

end # module
