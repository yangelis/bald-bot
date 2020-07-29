module repl
include("irc.jl")

using .irc

using Sockets

export local_repl

function local_repl(tcp_sock::TCPSocket)
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
                        m = match(r"(.*) (.*)", str)
                        if m.captures[1] == "join"
                            chn = m.captures[2]
                            err = irc_join(tcp_sock, String(chn))
                            println(stdout, "irc_join: ", err)
                        elseif m.captures[1] == "part"
                            chn = m.captures[2]
                            irc_send(tcp_sock, "PART #$chn")
                        elseif occursin("say", m.captures[1])
                            msg = split(str, "say", limit=2)[2]
                            irc_send(tcp_sock, String(chn), String(msg))
                        end
                    catch ex
                        println(sock, "Exception on: ", str)
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
                println("Caught exception: $y")
            end
        end
    end
end


end # module
