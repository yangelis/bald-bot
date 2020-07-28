using Sockets

#HOST = "irc.chat.twitch.tv"
HOST = ip"44.226.36.141"
PORT = 6667
PASS = "oauth:9sr1pqcdwg8tpwoks8t4r5wuklazmm" # your Twitch OAuth token
IDENT = "baldiobot"  # Twitch username your using for your bot
CHANNEL = "john_pft"   # Channel


function opensocket()
    #s = TCPSocket()
    #s = Sockets.connect!(s, HOST, PORT)
    s = UDPSocket()
    bind(s, HOST, PORT)
    send(s, HOST, PORT, "PASS " * PASS * "\r\n")
    println("PASS " * PASS * "\r\n")
    send(s, HOST, PORT, "NICK " * IDENT * "\r\n")
    println("NICK " * IDENT * "\r\n")
    send(s, HOST, PORT, "JOIN #" *  CHANNEL * "\r\n")
    println("JOIN # " * CHANNEL * "\r\n")
    println(stdout, "Socket opened!")
    return s
end

function sendMessage(s, message)
    messagetemp = "PRIVMSG #" * CHANNEL * " :" + message
    send(s, HOST, PORT, messagetemp * "\r\n")
    println("Sent: ", messagetemp)
end
