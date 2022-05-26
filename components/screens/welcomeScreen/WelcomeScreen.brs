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
        "successIcon"
        "invalidInputMessage"
        "message"
        "button"
        "footer"
    ])

    m.inputFocusBound = m.input.findNode("focusBoundingRectangle")
    m.top.currentStep = 1

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
        else if key = "up" and m.button.isInFocusChain() and m.top.currentStep < 3
            m.input.setFocus(true)
        else if key = "down" and m.input.isInFocusChain()
            m.button.setFocus(true)
        else if key = "back" and m.inputKeyboard <> invalid and m.inputKeyboard.isInFocusChain()
            m.input.setFocus(true)
            m.button.visible = true
            m.message.visible = true
            m.inputKeyboard.visible = false
            validateEmailAddress()
        end if
    end if

    return true
end function

sub showKeyboard()
    m.inputKeyboard = createNode("Keyboard", {
        "id": "keyboard"
    })

    m.inputKeyboard.getChild(0).visible = false
    m.inputKeyboard.translation = [169, 380]
    m.button.visible = false
    m.message.visible = false
    m.inputKeyboard.observeField("text", "onKeyboardTextReceived")
    m.top.appendChild(m.inputKeyboard)
    m.inputKeyboard.setFocus(true)
end sub

sub onKeyboardTextReceived(msg as object)
    m.input.text = msg.getData()
end sub

sub showPinpad()
    m.input.callFunc("clear")

    m.pinpad = createNode("Pinpad", {
        "id": "pinpad"
        "pinLength": 6
        "showPinDisplay": false
    })

    m.pinpad.translation = [504, 380]
    m.button.visible = false
    m.pinpad.observeField("pin", "onPinpadTextReceived")
    m.top.appendChild(m.pinpad)
    m.pinpad.setFocus(true)
end sub

sub onPinpadTextReceived(msg as object)
    m.input.text = msg.getData()

    if m.input.text.len() = 6
        m.button.visible = true
        m.pinpad.visible = false
        m.button.setFocus(true)
    end if
end sub

sub validateEmailAddress()
    emailRegex = createObject("roRegex", m.appConfig.emailRegex, "i")
    
    if emailRegex.isMatch(m.input.text)
        m.button.setFocus(true)
        m.inputFocusBound.color = m.colors.WHITE
        m.invalidInputMessage.visible = false
    else
        m.input.setFocus(true)
        m.input.findNode("focusBoundingRectangle")
        m.inputFocusBound.color = m.colors.error
        m.invalidInputMessage.setFields({
            visible: true
            text: m.texts.welcomeScreen.invalidEmail
            color: m.colors.error
        })
    end if
end sub

sub finishStep()
    if m.top.currentStep = 1 and m.invalidInputMessage.visible = false
        showPinpadScreen()
    else if m.top.currentStep = 2
        showSuccessScreen()
    else
        getScene().callFunc("hideWelcomeScreen")
    end if
end sub

sub showPinpadScreen()
    emailLabel = m.texts.welcomeScreen.emailLabel + m.input.text
     m.currentEmail.setFields({
        text: emailLabel
        visible: true
    })
    m.input.setFocus(true)
    m.header.text = m.texts.welcomeScreen.enterCodeHeader
    m.message.visible = false
    m.top.currentStep = m.top.currentStep + 1
    m.input.callFunc("clear")
end sub

sub showSuccessScreen()
    m.top.currentStep = m.top.currentStep + 1
    m.header.setFields({
        text: m.texts.welcomeScreen.welcomeHeader
        color: m.colors.highlight
    })
    m.currentEmail.setFields({
        visible: true
        text: m.texts.welcomeScreen.welcomeMessage
    })
    m.message.visible = false
    m.button.setFocus(true)
    m.button.text = m.texts.welcomeScreen.startWatchingButtonText
    m.footer.visible = true
    m.successIcon.visible = true    
    m.input.visible = false
end sub