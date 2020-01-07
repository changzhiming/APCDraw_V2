import QtQuick 2.10
import Qt.labs.platform 1.1
import QtQuick.Controls 2.3
import QtQuick.VirtualKeyboard 2.2
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import './Control'
import "./APCCommon"
import "./Dialog"
import './functionControl'

ApplicationWindow {
    id: window

    property alias currentPage: windowMenu.currentPage

    title : qsTr("组态编辑-") + GBQMl.projectName()

    visible: true
    width: 1280
    height: 1024

    background: Rectangle {
        color: 'gray'
    }
    FileDialog {
        id: fileDialog
        fileMode : FileDialog.OpenFile

        defaultSuffix:"ini"
        nameFilters: [ "(*.ini)", "All files (*)" ]
        folder: StandardPaths.writableLocation(StandardPaths.DesktopLocation)
        onAccepted: {
            var preProName = GBQMl.projectName()
            GBQMl.setProjectName(fileDialog.currentFile.toString().slice(8))
            if(preProName !== GBQMl.projectName()) {
                windowMenu.reload()
                deviceMenu.reload()
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("文件(&F)")
            Action {
                text: qsTr("新建工程(&N)")
                shortcut: 'CTRL+N'
                icon.source: 'qrc:/image/new.png'
                onTriggered: {
                    GB.showDialogNewProject(window, {}).saveData.connect(function(data){
                        GBQMl.setProjectName(data.saveLocation)
                        windowMenu.reload()
                        deviceMenu.reload()
                    })
                }
            }
            Action {
                text: qsTr("打开工程(&O)")
                shortcut: 'CTRL+O'
                icon.source: 'qrc:/image/open.png'
                onTriggered: fileDialog.open()
            }
            Action {
                text: qsTr("新建窗口(&W)")
                icon.source: 'qrc:/image/browser_window.png'
                shortcut: 'CTRL+W'
                onTriggered: {
                    var item = GB.newPage(window.contentItem, {})

                    GB.showDialogPage(item, item.controlPropertys()).saveData.connect(function(data){
                        if(data.pageName !== undefined) {
                            GBQMl.addOnePage(data.pageName, data, [])
                            windowMenu.addItem_(data.pageName)
                        }
                        item.destroy()
                    })
                }
            }
            Action {
                text: qsTr("新建设备(&D)")
                icon.source: 'qrc:/image/devices.svg'
                onTriggered: {
                    GB.showDevicesDialog(window, {}).saveData.connect(function(data){
                        GBQMl.addOneDevice(data.deviceName, data)
                        deviceMenu.addItem_(data.deviceName)
                    })
                }
            }
            Action {
                id: reportProjectAction
                text: qsTr("编译导出(&S)")
                shortcut: 'CTRL+S'
                icon.source: 'qrc:/image/save.png'
                onTriggered: {
                    currentPage.saveControl()
                }
            }
            MenuSeparator {}
            Action {
                text: qsTr("退出(&Q)")
                shortcut: 'CTRL+Q'
                icon.source: 'qrc:/image/out.png'
                onTriggered: Qt.quit();
            }
        }
        Menu {
            id: edit_menu
            title: '编辑(&E)'
            property var copyChildres: []
            Action {
                id : copy_action
                text: qsTr("复制(&C)")
                icon.source : '/image/copy.svg'
                shortcut: 'CTRL+C'
                onTriggered: edit_menu.copyChildres = currentPage.copyControl();
            }
            Action {
                id: paste_ation
                text: qsTr("粘贴(&V)")
                icon.source : '/image/paste.svg'
                shortcut: 'CTRL+V'
                onTriggered: currentPage.paseControl(edit_menu.copyChildres)
            }
            Action {
                id: delete_ation
                text: qsTr("删除(&D)")
                icon.source : '/image/delete.svg'
                shortcut: "CTRL+D"
                onTriggered: currentPage.deleteControl();
            }
            Action {
                id: topAlign_ation
                text: qsTr("上对齐(&T)")
                icon.source : '/image/arrow_thick_up.svg'
                shortcut: 'CTRL+ALT+T'
                onTriggered: currentPage.align('top')
            }
            Action {
                id: buttomAlign_ation
                text: qsTr("下对齐(&B)")
                icon.source : '/image/arrow_thick_down.svg'
                shortcut: 'CTRL+ALT+B'
                onTriggered: currentPage.align('buttom')
            }
            Action {
                id: leftAlign_ation
                text: qsTr("左对齐(&L)")
                icon.source: '/image/arrow_thick_left.svg'
                shortcut: 'CTRL+ALT+L'
                onTriggered: currentPage.align('left')
            }
            Action {
                id: rightAlign_ation
                text: qsTr("右对齐(&R)")
                icon.source : '/image/arrow_thick_right.svg'
                shortcut: 'CTRL+ALT+R'
                onTriggered: currentPage.align('right')
            }
            Action {
                id: horizontalAlign_ation
                text: qsTr("水平分布(&H)")
                icon.source: '/image/arrow_two_left_right.svg'
                shortcut: 'CTRL+ALT+H'
                onTriggered: currentPage.align('horizontal')
            }
            Action {
                id: verticalAlign_ation
                text: qsTr("垂直分布(&V)")
                icon.source: '/image/arrow_two_left_right.svg'

                shortcut: 'CTRL+ALT+V'
                onTriggered: currentPage.align('vertical')
            }
        }

        WindowsMenu {
            id: windowMenu
            title: '窗口(&W)'
            pageHandleParent: window.contentItem
        }
        DevicesMenu {
            id: deviceMenu
            title: '设备(&D)'
        }
        Menu {
            title: '控件(&K)'
            ActionGroup {
                id: controlActionGroup
                exclusive: true
                onTriggered: GB.selectType = action.text
            }
            Action {
                text: '选择'
                icon.source: '/image/selection.svg'
                checkable: true
                checked: true
                ActionGroup.group: controlActionGroup
            }
            Action {
                text: '文本'
                icon.source: '/image/text_.svg'
                checkable: true
                ActionGroup.group: controlActionGroup
            }
            Action {
                text: '按钮'
                icon.source: '/image/press_button.svg'
                checkable: true
                ActionGroup.group: controlActionGroup
            }
            Action {
                text: '输入'
                icon.source: '/image/input_pen.png'
                checkable: true
                ActionGroup.group: controlActionGroup
            }
            Action {
                text: '图片'
                icon.source: '/image/image_picture.svg'
                checkable: true
                ActionGroup.group: controlActionGroup
            }
        }
        Menu {
            title: '帮助'
            Action {
                text: '关于'
            }
        }

        MenuBarItem {display: AbstractButton.IconOnly;  action: copy_action; ToolTip.visible: hovered; ToolTip.text: '复制'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: paste_ation; ToolTip.visible: hovered; ToolTip.text: '粘贴'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: delete_ation; ToolTip.visible: hovered; ToolTip.text: '删除'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: topAlign_ation; ToolTip.visible: hovered; ToolTip.text: '上对齐'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: buttomAlign_ation; ToolTip.visible: hovered; ToolTip.text: '下对其'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: leftAlign_ation; ToolTip.visible: hovered; ToolTip.text: '左对齐'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: rightAlign_ation; ToolTip.visible: hovered; ToolTip.text: '右对齐'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: horizontalAlign_ation; ToolTip.visible: hovered; ToolTip.text: '水平分布'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: verticalAlign_ation;rotation: 90; ToolTip.visible: hovered; ToolTip.text: '垂直分布'}
        MenuBarItem {display: AbstractButton.IconOnly;  action: reportProjectAction;ToolTip.visible: hovered; ToolTip.text: '编译导出'}
    }
}
