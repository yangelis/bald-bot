using Sockets

server = listen(8080)

while true
    connection = accept(server)
    # Runs accept async (does not block the main thread)
    @async begin
        try
            while true
                write(connection, "\$> ")
                line = readline(connection)
                if line == "!close"
                    println(connection, "Closing connection")
                    close(connection)
                end
                println(connection, line)
            end
        catch err
            print("connection ended with error $err")
        finally
            close(server)
        end
    end
end

