sub Main()
    m.screen = CreateObject("roSGScreen")
    loadScene()
end sub

sub loadScene(restart = false as boolean)
    setGlobalNode()
    port = CreateObject("roMessagePort")
    screen = CreateObject("roSGScreen")
    screen.SetMessagePort(port)

    m.scene = screen.CreateScene("MainScene")

    if (restart = true)
        screen.show()
        m.screen.close()
        m.screen = screen
    else
        m.screen = screen
        screen.show()
    end if



    m.global.observeField("exitApp", port)
    m.global.observeField("restartApp", port)

    while(true)
        msg = wait(0, port)
        msgType = type(msg)

        if (msgType = "roSGNodeEvent")
            field = msg.getField()

            if (field = "exitApp")
                m.screen.close()
            else if (field = "restartApp")
                loadScene(true)
            end if
        end if
    end while

    if m.screen <> invalid then
        m.screen.close()
        m.screen = invalid
    end if

end sub

sub setGlobalNode()
    m.global = m.screen.getGlobalNode()
    m.global.addField("exitApp", "boolean", true)
    m.global.addField("deepLinkData", "assocarray", true)
    m.global.addField("restartApp", "boolean", true)

    m.global.addFields(getAppConfigObject())
end sub

function getAppConfigObject()

    config = getAppConfig()

    return {
        config: config
    }

end function
