module repl
include("irc.jl")

using .irc

using Sockets

export local_repl

function local_repl(tcp_sock::TCPSocket)
    server = listen(6969)
    while true
        sock = accept(server)
        @async begin
            try
                write(sock,"Connected\r\n")
                while true
                    str = readline(sock)
                    write(sock,"$str\r\n")
                    if str[1:5] == "!JOIN"
                        chn = str[7:end]
                        write(sock,"$chn\r\n")
                        irc_join(tcp_sock, chn)
                    end
                end
            catch y
                println("Caught exception: $y")
            end
        end
    end
end


end # module
