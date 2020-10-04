module julia_bot

include("parse_config.jl")
include("irc.jl")
include("repl.jl")

using .parse_config
using .irc
using .repl

using Sockets, Base.Threads

export bot_run

function bot_run(config_filename::String)
    config::Config = parseconfig(config_filename)

    tcp_sock = TCPSocket(;delay=true)

    oauth::String = read_oauth_file(config.token_file)
    status = irc_connect(tcp_sock, config)
    println(stdout, "Status after irc_connect: ", status)

    status = irc_auth(tcp_sock, config.nickname, oauth)
    println(stdout, "Status after irc_auth: ", status)

    if !isempty(config.channel)
        irc_join(tcp_sock, config.channel)
    end # if
    Threads.@spawn local_repl(tcp_sock)

    println(stdout, "Initialise:")
    status, msg = irc_readlines(tcp_sock, config)
end

end # module
