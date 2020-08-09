module commands

include("irc.jl")
using .irc


cmd = Dict("hello"=> irc_send, "bye"=>irc_send, "test"=> println)

function generate()
    for (key, command) in cmd
    eval(quote
             $(Symbol(key))(sock, chn::String) = $command(sock, chn, "hello")
         end)
    end
end


function printCommands()
    println(stdout, names(commands, all=true))
end


end # module
