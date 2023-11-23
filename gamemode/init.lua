DeriveGamemode( "sandbox" )

print("Hellow world in init.lua")
require("gwsockets")
 
local verifyCertificate = true

local webSocket = GWSockets.createWebSocket( "ws://localhost:5110/ws/chat", verifyCertificate )

function webSocket:onMessage(txt)
    print("Received: ", txt)
    local message = util.JSONToTable(txt)
    PrintMessage(HUD_PRINTTALK, message.Name .. ": " .. message.Text)
end

function webSocket:onError(txt)
    print("Error: ", txt)
end

function webSocket:onConnected()
    print("Connected to chat server")
end

function webSocket:onDisconnected()
    print("WebSocket disconnected")
end

webSocket:open()

print("messaged written", webSocket:isConnected())

function GM:PlayerSay(sender, text, teamChat)
    print("PlayerSay", sender:Name(), text, teamChat)
    local message = {
        Name = sender:Name(),
        Text = text
    }
    webSocket:write(util.TableToJSON(message))
    return text
end

