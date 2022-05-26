function getFocusedNode(node)
    if(isValid(node) and isValid(node.focusedChild))
        if (node.focusedChild.isSameNode(node))
            return node
        else
            return getFocusedNode(node.focusedChild)
        end if
    end if
end function

function isString(var as dynamic) as boolean
    return (type(var) = "String" or type(var) = "roString")
end function

function isNonEmptyStr(value)
    return isString(value) and len(value) > 0
end function

function isValid(var as dynamic) as boolean
    if (type(var) = "<uninitialized>")
        return false
    end if

    return var <> invalid
end function

function isNotValid(var as dynamic) as boolean
    return not isValid(var)
end function

function createNode(nodeType as string, fields = invalid as dynamic)
    node = createObject("roSgNode", nodeType)

    if isValid(node) and isNonEmptyAssocArray(fields)
        node.setFields(fields)
    end if

    return node
end function

function isArray(var as dynamic) as boolean
    return isValid(var) and isValid(GetInterface(var, "ifArray"))
end function

function isNonEmptyArray(var as dynamic) as boolean
    return isArray(var) and var.Count() > 0
end function

function isAssocArray(var as dynamic) as boolean
    return isValid(var) and isValid(GetInterface(var, "ifAssociativeArray"))
end function

function isNonEmptyAssocArray(var as dynamic) as boolean
    return isAssocArray(var) and var.Count() > 0
end function

function isNode(value)
    return isValid(value) and isValid(GetInterface(value, "ifSGNodeField"))
end function

sub showLoader(show = true as boolean)
    loader = getScene().findNode("loader")
    loader.callFunc("show", show)
    loader.visible = show
end sub

function isLoaderVisible() as boolean
    return getScene().findNode("loader").visible
end function

function getScene()
    return m.top.getScene()
end function

function showPopup(data as object)

    popup = createNode("DefaultPopup", {
        "data": data
    })

    getScene().appendChild(popup)
    popup.setFocus(true)

    return popup
end function

function readLocalJson(fileName as string) as object
    if fileName <> invalid
        dataString = readAsciiFile(fileName)
        obj = parseJSON(dataString)
        if isNonEmptyAssocArray(obj) or isNonEmptyArray(obj)
            return obj
        end if
    end if

    return {}
end function

sub createVariablesFromChildren(parent = m.top as dynamic, context = m as dynamic)

    if (isNonEmptyArray(parent))

        for i = 0 to parent.count() - 1 step 1
            createVariablesFromChildren(parent[i], context)
        end for

    else if (isNode(parent))

        for i = 0 to parent.getChildCount() - 1 step 1
            child = parent.getChild(i)

            if (isNonEmptyStr(child.id))
                context[child.id] = child
            end if

        end for

    else if(isNonEmptyStr(parent))
        node = m.top.findNode(parent)
        createVariablesFromChildren(node)
    end if

end sub

function getMessageFont()
    return createNode("Font", {
        "uri": "pkg:/fonts/RTLUnitedText-Regular.ttf"
        "size": 16
    })
end function

function getHeaderFont()
    return createNode("Font", {
        "uri": "pkg:/fonts/RTLUnitedText-Bold.ttf"
        "size": 30
    })
end function