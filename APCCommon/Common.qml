pragma Singleton

import Qt.labs.settings 1.0
import QtQuick 2.0

Item {
    function setProjectName(proName) {
        systemSetting.projectName = proName
    }
    function projectName() {
        return systemSetting.projectName
    }

    function saveProject(key, value) {
        projectSetting.setValue(key, value)
    }
    function getProject(key) {
        return projectSetting.value(key)
    }
    //读取所有页面
    function readPages() {
        return JSON.parse(getProject('windowList') || "[]")
    }
    //读取一个页面
    function readOnePage(pageName) {
        return JSON.parse(getProject(pageName)||"{}")
    }
    //删除一个页面
    function deleteOnePage(pageName)
    {
        saveProject(pageName, undefined)
        var allPages = readPages()

        var index = allPages.indexOf(pageName);
        if (index > -1) {
            allPages.splice(index, 1);
        }
        saveProject('windowList', JSON.stringify(allPages))
    }
    //添加一个页面
    function addOnePage(pageName, pageInfo, childItems)
    {
        if(pageName === '') {return}
        var allPages = readPages()
        if(allPages.includes(pageName) == false) {
            allPages.push(pageName)
            saveProject('windowList', JSON.stringify(allPages))
        }
        saveProject(pageName, JSON.stringify({pageInfo:pageInfo, childItems:childItems}))
    }
    //复制一个页面
    function copyOnePage(pageName)
    {
        var pageIndex = 1;
        var newPageName = pageName;
        var allPages = readPages()

        while(true) {
            newPageName = pageName + pageIndex++
            if(allPages.includes(newPageName) == false) {

                var pageInfo = readOnePage(pageName)
                pageInfo.pageInfo.pageName = newPageName
                addOnePage(newPageName, pageInfo.pageInfo, pageInfo.childItems)
                break
            }
        }
        return newPageName;
    }

    //读取所有设备
    function readDevices() {
        return JSON.parse(getProject('deviceList') || "[]")
    }
    //读取一个设备
    function readOneDevice(deviceName) {
        return JSON.parse(getProject(deviceName)||"{}")
    }
    //删除一个设备
    function deleteOneDevice(deviceName) {
        saveProject(deviceName, undefined)
        var devices = readDevices()

        var index = devices.indexOf(deviceName);
        if (index > -1) {
            devices.splice(index, 1);
        }
        saveProject('deviceList', JSON.stringify(devices))
    }

    //添加一个设备
    function addOneDevice(deviceName, deviceInfo)
    {
        if(deviceName === '') {return}
        var devices = readDevices()
        if(devices.includes(deviceName) == false) {
            devices.push(deviceName)
            saveProject('deviceList', JSON.stringify(devices))
        }
        saveProject(deviceName, JSON.stringify(deviceInfo))
    }
    //复制一个设备
    function copyOneDevice(deviceName)
    {
        var deviceIndex = 1;
        var newDeviceName = deviceName;
        var devices = readDevices()

        while(true) {
            newDeviceName = deviceName + deviceIndex++
            if(devices.includes(newDeviceName) == false) {

                var deviceInfo = readOneDevice(deviceName)
                deviceInfo.deviceName = newDeviceName
                addOneDevice(newDeviceName, deviceInfo)
                break
            }
        }
        return newDeviceName;
    }


    Settings {
        id: systemSetting
        fileName: 'systemSetting'
        property var projectName
    }

    Settings {
        id: projectSetting
        fileName: systemSetting.projectName
    }
}
