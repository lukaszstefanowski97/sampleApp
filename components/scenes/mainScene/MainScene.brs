function init()
    m.appConfig = m.global.config
    showWelcomeScreen("show")
end function

sub showWelcomeScreen(showParam as string)
    if showParam = "show"
        if isNotValid(m.welcomeScreen)
            m.welcomeScreen = createNode("WelcomeScreen", {
                "id": "welcomeScreen"
                "visible": false
            })
            m.welcomeScreen.findNode("input").setFocus(true)
            m.top.appendChild(m.welcomeScreen)
        end if
        m.welcomeScreen.visible = true
        m.welcomeScreen.setFocus(true)
    else if showParam = "hide" and isValid(m.welcomeScreen)
        m.welcomeScreen.setFocus(false)
        m.welcomeScreen.visible = false
    else if showParam = "destroy" and isValid(m.welcomeScreen)
        showWelcomeScreen("hide")
        m.top.removeChild(m.welcomeScreen)
        m.welcomeScreen = invalid
    end if
end sub
