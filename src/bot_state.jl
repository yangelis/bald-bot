mutable struct Config
    cmd_preffix::String
    owner::String
    channel::String
    nickname::String
    token_file::String
    hostname::String
    port::Int64
    Config() = new()
end

mutable struct Bot
    sock::TCPSocket
    config::Config
    Bot(sock::TCPSocket) = new(sock, Config())
end

