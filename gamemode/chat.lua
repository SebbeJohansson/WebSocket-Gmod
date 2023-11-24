require("gwsockets")
local verifyCertificate = true
--[[
    This will run if we hotreload this file. We dont want multiple websockets connected.
]]--
if chatWebSocket then
    print("websocket exists")
    chatWebSocket:closeNow()
end

chatWebSocket = chatWebSocket or GWSockets.createWebSocket("ws://localhost:5110/ws/chat", verifyCertificate)
function chatWebSocket:onMessage(txt)
    print("Received: ", txt)
    local message = util.JSONToTable(txt)
    if not message then
        print("Invalid message received: ", txt)

        return
    end

    PrintMessage(HUD_PRINTTALK, message.Name .. ": " .. message.Text)
end

function chatWebSocket:onError(txt)
    print("Error: ", txt)
end

function chatWebSocket:onConnected()
    print("Connected to chat server")
end

function chatWebSocket:onDisconnected()
    print("Chat server disconnected")
end

chatWebSocket:open()
if not chatWebSocket:isConnected() then
    print("Failed to connect to chat server")
end

function GM:PlayerSay(sender, text, teamChat)
    print("PlayerSay", sender:Name(), text, teamChat)
    local message = {
        Name = sender:Name(),
        Text = text
    }

    chatWebSocket:write(util.TableToJSON(message))

    -- Prevent normal chat message from printing.
    return ""
end