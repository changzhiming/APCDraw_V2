import QtQuick 2.11
import QtQuick.Controls 2.4
import "../APCCommon"

Menu {
    id: windowMenu

    Item {
        Menu {
            id: menuPopu
            property var menuButton

            function show(menuButton) {
                menuPopu.menuButton = menuButton
                popup()
            }

            MenuItem {
                text: '复制'
                onTriggered: windowMenu.addItem_(GBQMl.copyOneDevice(menuPopu.menuButton.text))
            }
            MenuItem {
                text: '删除'
                onTriggered: {
                    GBQMl.deleteOneDevice(menuPopu.menuButton.text)
                    windowMenu.removeItem(menuPopu.menuButton)
                }
            }
        }
    }

    Component {
        id: menuItem

        MenuItem {
            signal rightClicked()

            icon.source: 'qrc:/image/devices.svg'
            MouseArea {
                acceptedButtons: Qt.AllButtons
                anchors.fill: parent
                propagateComposedEvents: true //必须设置否则不能传递
                onPressed: {
                   if (mouse.button === Qt.RightButton)
                        rightClicked()
                   mouse.accepted = false; //必须设置否则不能传递
                }
            }
        }
    }

    function addItem_(deviceName) {
        var menuButton = menuItem.createObject(windowMenu.contentItem, {'text':deviceName})

        menuButton.clicked.connect(function(){
            GB.showDevicesDialog(windowMenu.parent, GBQMl.readOneDevice(menuButton.text)).saveData.connect(function(data){ GBQMl.addOneDevice(data.deviceName, data) })
        })
        menuButton.rightClicked.connect(function(){
            menuPopu.show(menuButton)
        })
    }

    function readDevices() {
        var devices = GBQMl.readDevices()
        for(var key in devices) {
            windowMenu.addItem_(devices[key])
        }
    }
    function reload() {
        windowMenu.clear()
        windowMenu.readDevices()
    }

    function clear()
    {
        while(true) {
            if(windowMenu.itemAt(1) !== null) {
                windowMenu.removeItem(windowMenu.itemAt(1))
                continue
            }
            break
        }
    }
    Component.onCompleted: readDevices()
}
