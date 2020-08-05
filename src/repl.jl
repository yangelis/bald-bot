module repl
include("irc.jl")
include("commands.jl")

using .irc
using .commands

using Sockets

export local_repl

function local_repl(tcp_sock::TCPSocket)
    commands.generate()
    server = listen(6969)
    chn = ""
    m = ""
    while true
        sock = accept(server)
        @async begin
            try
                write(sock,"Connected to bot repl\r\n")
                while true
                    write(sock, "#> ")
                    str = readline(sock)
                    try
                        chn = repl_commands(tcp_sock, str, chn)
                    catch ex
                        println(sock, "Exception on: ", str)
                        println(sock, "with $ex")
                    end
                    if str == "ls"
                        if chn != ""
                            println(sock, "Channel: ", chn)
                        else
                            println(sock, "No channel joined")
                        end
                    end
                end
            catch y
                println(stderr, "Caught exception: $y")
            end
        end
    end
end

function repl_commands(tcp_sock, str, chn )
    if  ( m = match(r"(.*) (.*)", str) ) !== nothing
        if m.captures[1] == "join"
            chn = m.captures[2]
            err = irc_join(tcp_sock, String(chn))
            println(stdout, "irc_join: ", err)
        elseif m.captures[1] == "part"
            chn = m.captures[2]
            irc_send(tcp_sock, "PART #$chn")
            chn = ""
        elseif occursin("say", m.captures[1])
            msg = split(str, "say", limit=2)[2]
            irc_send(tcp_sock, String(chn), String(msg))
        end
    elseif ( m = match(r"(.*)", str) ) !== nothing
        if occursin("khello", m.captures[1])
            println(stdout, "ayyy")
            commands.khello(tcp_sock, String(chn))
        end
    end

    return chn
end

end # module
