sub init()
    m.appConfig = m.global.config
    m.colors = m.appConfig.colors
    m.texts = m.appConfig.texts

    createVariablesFromChildren([
        m.top,
        "background"
        "header"
        "currentEmail"
        "input"
        "message"
        "button"
        "footer"
    ])

    setStyles()
    setTexts()
end sub

sub setStyles()
    m.background.color = m.colors.background.background
    m.button.setFields({
        focusedColor: m.colors.highlight
        unfocusedColor: m.colors.background.variant
    })
    m.header.font = getHeaderFont()
    m.message.font = getMessageFont()
    m.footer.font = getMessageFont()
end sub

sub setTexts()
    m.header.text = m.texts.welcomeScreen.enterEmailHeader
    m.input.placeholder = m.texts.welcomeScreen.emailInputPlaceholder
    m.message.text = m.texts.welcomeScreen.enterEmailMessage
    m.button.text = m.texts.welcomeScreen.continueButtonText
    m.footer.text = m.texts.welcomeScreen.footer
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if getScene().allowKeyPress = true and press = true
        if key = "ok"
            if m.input.isInFocusChain()
                m.input.voiceEnabled = true
            end if
        else if key = "up" and m.button.isInFocusChain()
            m.input.setFocus(true)
        else if key = "down" and m.input.isInFocusChain()
            m.button.setFocus(true)
        end if
    end if

    return true
end function

sub showKeyboard()

    m.inputKeyboard = createNode("Keyboard", {
        "id": "keyboard"
        "data": {
            "text": m.input.text,
            "translation": [169, 365]
        }
    })

    m.inputKeyboard.getChild(0).visible = false
    m.button.visible = false
    m.message.visible = false
    m.inputKeyboard.observeField("text", "onKeyboardTextReceived")
    m.top.appendChild(m.inputKeyboard)
    m.inputKeyboard.setFocus(true)

end sub

sub onKeyboardTextReceived(msg as object)
    m.input.text = msg.getData()
end sub