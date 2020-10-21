# Bald-bot
**NOT EVEN ALPHA STATE**

This is a twitch bot written in julia. For now it can connect to a twitch
channel, read messages and even send some

## Usage

```sh
$ julia --project
julia> using julia_bot
julia> run_bot("path/to/config.json")
```

Now, open a separate terminal and connect to the repl as port 6969

```sh
ncat localhost 6969
#> join channel_name
#> say hello chat
#> ...
#> part channel_name
```

