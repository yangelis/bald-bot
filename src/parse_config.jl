module parse_config
include("../../jjson/jjson.jl")

export Config, parseconfig

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

function parseconfig(configfile::String)
    parsed_config = jjson.parsejson(configfile)

    config = Config()
    config.hostname = "irc.chat.twitch.tv"
    config.port = 6667
    config.cmd_preffix = parsed_config["twitch"]["preffix"]
    config.owner = parsed_config["twitch"]["owner"]
    config.channel = parsed_config["twitch"]["channel"]
    config.nickname = parsed_config["twitch"]["nickname"]
    config.token_file = parsed_config["twitch"]["token"]

    return config
end



end # module
