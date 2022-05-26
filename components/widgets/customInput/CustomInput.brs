function init() as void

    m.appConfig = m.global.config

    createVariablesFromChildren([
        m.top,
        "inputBackground",
        "focusBoundingRectangle"
    ])

    m.colors = m.appConfig.colors
    m.top.observeField("focusedChild", "onFocus")
    setStyles()
end function

sub onFocus()
    m.focusBoundingRectangle.visible = m.top.isInFocusChain()
end sub

sub setStyles()
    m.inputBackground.color = m.colors.background.variant
    m.inputLabel.color = m.colors.WHITE
end sub

sub onTextChanged()
    text = m.top.text

    if isNonEmptyStr(text)
        if (m.top.isSecured = true)
            textLen = text.Len()
            text = ""
            dot = "•"
            for i = 0 to textLen - 1 step 1
                text += dot
            end for
        end if
        m.inputLabel.text = text
        m.placeholderLabel.visible = false
    else
        m.placeholderLabel.visible = true
    end if
end sub

sub onPlaceholderChanged(msg as object)
    m.placeholderLabel.text = msg.getData()
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if getScene().allowKeyPress = true and press = true and key = "OK"
        m.top.getParent().callFunc("showKeyboard")
        return true
    end if

    return false
end function

