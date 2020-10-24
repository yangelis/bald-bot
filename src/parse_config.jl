# include("../../jjson/jjson.jl")

function parseconfig!(configfile::String, bot::Bot)
    parsed_config = jjson.parsejson(configfile)

    config = Config()
    config.hostname = "irc.chat.twitch.tv"
    config.port = 6667
    config.cmd_preffix = parsed_config["twitch"]["preffix"]
    config.owner = parsed_config["twitch"]["owner"]
    config.channel = parsed_config["twitch"]["channel"]
    config.nickname = parsed_config["twitch"]["nickname"]
    config.token_file = parsed_config["twitch"]["token"]

    bot.config = config

    return config
end

