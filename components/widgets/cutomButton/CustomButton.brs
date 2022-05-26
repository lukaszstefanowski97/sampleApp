function init() as void

    m.appConfig = m.global.config
    m.colors = m.appConfig.colors
    settings = m.appConfig.settings.screenComponents

    createVariablesFromChildren([
        m.top,
        "btnBorder"
        "btnIcon"
        "btnFocused"
        "btnUnfocused"
        "btnLabelFocus"
        "btnLabelUnfocus"
    ])

    m.btnBorder.setFields({
        uri: settings.border.uri,
        focusable: settings.border.focusable,
        height: settings.border.height,
    })

    m.btnFocused.setFields({
        visible: true
        width: settings.backgroundFocused.width,
        height: settings.backgroundFocused.height,
        blendingEnabled: settings.backgroundFocused.blendingEnabled,
    })

    m.btnUnfocused.visible = false

    m.btnLabelUnfocus.setFields({
        height: settings.label.height,
        width: settings.label.width,
        vertAlign: settings.label.vertAlign,
        horizAlign: settings.label.horizAlign,
    })

    m.btnLabelFocus.setFields({
        height: settings.label.height,
        width: settings.label.width,
        vertAlign: settings.label.vertAlign,
        horizAlign: settings.label.horizAlign,
    })

    m.btnFocused.color = m.colors.highlight
    m.unFocusedRct.setFields({
        width: settings.backgroundFocused.width,
        height: settings.backgroundFocused.height,
        color: m.colors.background.variant
    })
    m.btnLabelFocus.color = m.colors.white
    m.btnLabelUnfocus.color = m.colors.white
    m.btnLabelFocus.font = getHeaderFont()
    m.btnLabelUnfocus.font = getHeaderFont()

    m.top.observeField("focusedChild", "setFocus")
    setFocus()

end function

sub setFocus()

    if m.top.isInFocusChain() = true
        m.btnUnfocused.visible = false
        m.btnBorder.uri = ""
        m.btnFocused.visible = true
        m.btnIcon.blendColor = m.colors.black

    else
        m.btnFocused.visible = false
        onHasBorderChanged()
        m.btnUnfocused.visible = true
        m.btnIcon.blendColor = m.colors.highlight
    end if

end sub


sub onTextChanged()

    text = m.top.text

    if (isValid(text) and isNonEmptyStr(text))
        m.btnLabelFocus.text = text
        m.btnLabelUnfocus.text = text
    end if

end sub

sub onHeightChanged()

    height = m.top.height

    if (isValid(height))
        m.btnBorder.height = height
        m.unFocusedRct.height = height
        m.btnFocused.height = height
        m.btnLabelFocus.height = height
        m.btnLabelUnfocus.height = height
        m.btnLabelUnfocus.height = height
    end if

end sub


sub onWidthChanged()

    width = m.top.width

    if (isValid(width))
        m.btnBorder.width = width
        m.btnFocused.width = width
        m.unFocusedRct.width = width
        m.btnLabelFocus.width = width
        m.btnLabelUnfocus.width = width
    end if

end sub

sub onHasBorderChanged()
    hasBorder = m.top.hasBorder

    if (hasBorder)
        m.btnBorder.uri = "pkg:/images/button_border.9.png"
    else
        m.btnBorder.uri = ""
    end if

end sub

sub onIconUriChanged(msg as object)
    iconUri = msg.getData()

    if (isValid(iconUri))
        m.btnIcon.uri = iconUri
    end if
end sub

sub onIconAlignChanged(msg as object)
    iconAlign = msg.getData()
    if (iconAlign > 0)
        btnWidth = m.btnIcon.boundingRect().width
        btnLabelWidth = m.btnLabelUnfocus.boundingRect().width
        btnLabelAlign = iconAlign + btnWidth
        btnLabelWidth -= btnLabelAlign
        btnIconOffsetX = iconAlign - btnWidth
        btnIconOffsetY = m.btnIcon.translation[1] - 2
        m.btnIcon.translation = [btnIconOffsetX, btnIconOffsetY]

        m.btnLabelUnfocus.setFields({
            "translation": [btnLabelAlign, m.btnLabelUnfocus.translation[1]]
            "width": btnLabelWidth
            "horizAlign": "left"
        })
        m.btnLabelFocus.setFields({
            "translation": [btnLabelAlign, m.btnLabelUnfocus.translation[1]]
            "width": btnLabelWidth
            "horizAlign": "left"
        })
    end if

end sub

sub onUnFocusedColorChanged(msg as object)
    unFocusedColor = msg.getData()
    if (isNonEmptyStr(unFocusedColor))
        m.unFocusedRct.color = unFocusedColor
    end if
end sub

sub onFocusedColorChanged(msg as object)
    focusedColor = msg.getData()

    if (isNonEmptyStr(focusedColor))
        m.btnFocused.color = focusedColor
    end if
end sub

sub onKeyEvent(key as string, press as boolean) as boolean

    if (getScene().allowKeyPress = true and press = true and key = "OK" )
        m.top.itemSelected = m.top.id
        return true
    end if

    return false

end sub