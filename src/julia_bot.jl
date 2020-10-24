module julia_bot

using Base.Threads
using Printf
using Random
using SQLite
using Serialization
using Sockets
using Tables
using UUIDs

include("../../jjson/jjson.jl")
include("bot_state.jl")
include("parse_config.jl")
include("tcp.jl")
include("mcmc.jl")
include("irc.jl")
include("repl.jl")

export run_bot

function run_bot(config_filename::String)
    tcp_sock = TCPSocket(;delay=true)
    bot = Bot(tcp_sock)

    config::Config = parseconfig!(config_filename, bot)
    oauth::String = read_oauth_file(config.token_file)

    status = irc_connect(bot.sock, config)
    println(stdout, "Status after irc_connect: ", status)

    status = irc_auth(bot.sock, config.nickname, oauth)
    println(stdout, "Status after irc_auth: ", status)

    if !isempty(config.channel)
        irc_join(bot.sock, config.channel)
    end # if
    Threads.@spawn local_repl(bot.sock)

    println(stdout, "Initialise:")
    status, msg = irc_readlines(bot.sock, config)
end

end # module
