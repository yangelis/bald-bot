module bald_bot

using Base.Threads
using Printf
using Random
using SQLite
using Serialization
using Sockets
using Tables
using UUIDs

include("../../jjson/src/jjson.jl")
using .jjson
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

    parseconfig!(config_filename, bot)
    oauth::String = read_oauth_file(bot.config.token_file)

    status = irc_connect(bot.sock, bot.config)
    println(stdout, "Status after irc_connect: ", status)

    status = irc_auth(bot.sock, bot.config.nickname, oauth)
    println(stdout, "Status after irc_auth: ", status)

    if !isempty(bot.config.channel)
        irc_join(bot.sock, bot.config.channel)
    end

    init_database(bot.config.database, bot.config.channel)

    Threads.@spawn local_repl(bot.sock)

    println(stdout, "Initialise:")
    status, msg = irc_readlines(bot.sock, bot.config)
end

end # module
