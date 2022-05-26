function getAppConfig()
    appConfig = readLocalJson("pkg:/config/appConfig.json")

    appInfo = CreateObject("roAppInfo")

    appConfig.append({
        "appInfo": appInfo
        "channelId": appInfo.GetValue("slug")
        "channelTitle": appInfo.getTitle()
        "channelStoreId": appInfo.GetID()

        "majorVersion": appInfo.GetValue("major_version")
        "minorVersion": appInfo.GetValue("minor_version")
        "buildVersion": appInfo.GetValue("build_version")

        "channelVersion": appInfo.GetValue("major_version").toStr() + appInfo.GetValue("minor_version").toStr() + appInfo.GetValue("build_version").toStr()
        "rokuDevId": ""
    })

    return appConfig
end function