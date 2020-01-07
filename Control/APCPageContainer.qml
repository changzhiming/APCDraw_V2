import QtQuick 2.11
import QtQuick.Controls 2.4
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.3
import "../functionControl"
import "../APCCommon"

Pane {
    id: root

    property string enterJS: ''
    property string runJS: ""
    property string levealJS: ""

    property int timerInteral: 1000
    property int childsTimerInteral: 1000

    property color backgroundColor : 'white'
    property color borderColor : 'white'
    property real borderWidth : 1
    property real borderRadius : 0
    property real windowWith : 1000
    property real windowheight :800
    property string windowType: '嵌入式窗口'
    property string pageName: "窗口"

    background: Rectangle {
        color: backgroundColor
        border.color: borderColor
        border.width: borderWidth
        radius: borderRadius
    }
    transformOrigin: Item.TopLeft

    clip: true
    width: windowWith
    height: windowheight

    function execjs(str) { return eval(str) }

    function controlPropertys() {
        return {pageName:pageName, backgroundColor:backgroundColor.toString(), borderColor:borderColor.toString(), borderWidth:borderWidth, borderRadius:borderRadius,enterJS:enterJS, runJS:runJS, levealJS:levealJS,timerInteral:timerInteral,childsTimerInteral:childsTimerInteral,windowWith:windowWith,windowheight:windowheight,windowType:windowType}
    }

    //保存
    function saveControl() {
        var childItems = []
        for(var index = 0; index < contentChildren.length; index++) {
            if(contentChildren[index].save !== undefined) {
                childItems.push(contentChildren[index].save())
            }
        }
        var pageInfo = root.controlPropertys()
        GBQMl.addOnePage(pageName, pageInfo, childItems)

        GB.showHint(root, "保存成功")
    }
    function deleteControl() {
        for(var index = 0; index < contentChildren.length; index++) {
            if(contentChildren[index].checkabled === true) {
                contentChildren[index].destroy();
            }
        }
    }
    function copyControl() {
        var copyChildres = []
        for(var index = 0; index < contentChildren.length; index++) {
            if(contentChildren[index].checkabled === true) {
                copyChildres.push(contentChildren[index])
            }
        }
        return copyChildres
    }
    //粘贴
    function paseControl(copyChildres)
    {
        for(var index = 0; index < copyChildres.length; index++) {
            newControl(copyChildres[index].save()).checkabled = true;
        }
    }
    //对其
    function align(type) {
        var minY = root.height, maxY = 0, minX = root.width, maxX = 0, checkedNum = 0, currentX = 0, currentY = 0,checkAllWidth = 0, checkAllHeight = 0
        for(var index = 0; index < contentChildren.length; index++) {
            if(contentChildren[index].checkabled === true) {
                minY = contentChildren[index].y < minY ? contentChildren[index].y : minY
                maxY = contentChildren[index].y + contentChildren[index].height > maxY ? contentChildren[index].y + contentChildren[index].height : maxY
                minX = contentChildren[index].x < minX ? contentChildren[index].x : minX
                maxX = contentChildren[index].x + contentChildren[index].width > maxX ? contentChildren[index].x + contentChildren[index].width : maxX
                checkedNum++;
                checkAllWidth += contentChildren[index].width
                checkAllHeight += contentChildren[index].height
            }
        }
        currentX = minX
        currentY = minY

        for(index = 0; index < contentChildren.length; index++) {
            if(contentChildren[index].checkabled === true) {
                if(type === 'top') {contentChildren[index].y = minY }
                if(type === 'buttom') {contentChildren[index].y = maxY - contentChildren[index].height}
                if(type === 'left') {contentChildren[index].x = minX }
                if(type === 'right') {contentChildren[index].x = maxX -  contentChildren[index].width}
                if(type === 'horizontal') {
                    if(checkedNum > 2) {
                        var interval = (maxX - minX - checkAllWidth) / (checkedNum - 1)

                        if(currentX !== minX) {
                            currentX = currentX + interval
                        }

                        contentChildren[index].x = currentX
                        currentX += contentChildren[index].width
                    }
                }

                if(type === 'vertical') {
                    if(checkedNum > 2) {
                        interval = (maxY - minY - checkAllHeight) / (checkedNum - 1)

                        if(currentY !== minY) {
                            currentY = currentY + interval
                        }

                        contentChildren[index].y = currentY
                        currentY += contentChildren[index].height
                    }
                }
            }
        }
    }

    function newControl(propertys) {
        switch(propertys.type) {
        case '文本':
            return GB.newLabel(root.contentItem, propertys)
        case '按钮':
            return GB.newButton(root.contentItem, propertys)
        case '输入':
            return GB.newInput(root.contentItem, propertys)
        case '图片':
            return GB.newImage(root.contentItem, propertys)
        }
    }
    function showDialog(item, type) {
        switch(type) {
        case '文本':
            return GB.showDialogLabel(item, item.controlPropertys()).saveData.connect(function(data){Object.assign(item, data)})
        case '按钮':
            return GB.showDialogButton(item, item.controlPropertys()).saveData.connect(function(data){Object.assign(item, data)})
        case '输入':
            return GB.showDialogInput(item, item.controlPropertys()).saveData.connect(function(data){Object.assign(item, data)})
        case '图片':
            return GB.showDialogImage(item, item.controlPropertys()).saveData.connect(function(data){Object.assign(item, data)})
        case '窗口':
            return GB.showDialogPage(item, item.controlPropertys()).saveData.connect(function(data){Object.assign(item, data)})
        }
    }

    //定时运行js 窗口
    Timer {
        interval: timerInteral > 50 ? timerInteral : 50
        repeat: true
        running: true
        onTriggered: { execjs(runJS);}
    }
    //定时运行 子控件js
    Timer {
        interval: childsTimerInteral > 50 ? childsTimerInteral : 50
        running: true
        repeat: true
        onTriggered: {
            for(var index = 0; index < contentChildren.length; index++) {
                if(contentChildren[index].runjs !== undefined) {
                    contentChildren[index].interval_run()
                }
            }
        }

    }

    Component.onCompleted: {
        var pageData = GBQMl.readOnePage(pageName)
        Object.assign(root, pageData.pageInfo)

        for(var index in pageData.childItems) {
            newControl(pageData.childItems[index])
        }

        execjs(enterJS);
    }
    Component.onDestruction: {execjs(levealJS); print('页面删除:'+pageName)}

    ZoomMouseArea {
        anchors.fill: root.contentItem
        z: parent.z + 1

        rootItem: root.contentItem
        childItems: root.contentChildren

        onScaleChangled: root.scale += scale
        onCreateControl: { newControl({type, x:selectRect.x, y:selectRect.y, width:selectRect.width, height:selectRect.height}) }
        onDoubleClickItem: {showDialog(item, type)}
    }
}


