module repl
include("irc.jl")
include("commands.jl")

using .irc
using .commands

using Sockets

export local_repl

function remove!(a, item)
    deleteat!(a, findall(x->x==item, a))
end


function local_repl(tcp_sock::TCPSocket)
    commands.generate()
    server = listen(6969)
    chn = Vector{String}()
    m = ""
    while true
        sock::TCPSocket = accept(server)
        @async begin
            try
                write(sock,"Connected to bot repl\r\n")
                while true
                    write(sock, "#> ")
                    str = readline(sock)
                    try
                        repl_commands(tcp_sock, str, chn)
                    catch ex
                        println(sock, "Exception on: ", str)
                        println(sock, "with $ex")
                        close(sock)
                    end
                    if str == "ls"
                        if chn != ""
                            println(sock, "Channels joined:")
                            for (i, ch) in enumerate(chn)
                                println(sock, i, ": ", ch)
                            end
                        else
                            println(sock, "No channel joined")
                        end
                    end
                end
            catch y
                println(stderr, "Caught exception: $y")
                close(sock)
            end
        end
    end
end

function repl_commands(tcp_sock::TCPSocket, str::String, chn::Vector{String})
    if ( m = match(r"(?<cmd>.*) :(?<index>\w+) (?<msg>.*)", str)) !== nothing
        if occursin("say", m[:cmd])
            println(str)
            msg = m[:msg]
            ch_index = parse(Int32, m[:index])
            irc_send(tcp_sock, chn[ch_index], String(msg))
        end
    elseif  ( m = match(r"(.*) (.*)", str) ) !== nothing
        if m.captures[1] == "join"
            temp_chn = m.captures[2]
            push!(chn, temp_chn)
            err = irc_join(tcp_sock, String(temp_chn))
            println(stdout, "irc_join: ", err)
        elseif m.captures[1] == "part"
            if m.captures[2] == "all"
                for ch in chn
                    irc_send(tcp_sock, "PART #$ch")
                end
                chn = String[]
            else
                old_chn = m.captures[2]
                remove!(chn, old_chn)
                irc_send(tcp_sock, "PART #$old_chn")
            end
        elseif occursin("say", m.captures[1])
            msg = split(str, "say", limit=2)[2]
            irc_send(tcp_sock, String(chn[1]), String(msg))
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
