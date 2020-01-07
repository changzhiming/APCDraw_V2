import QtQuick 2.11
import QtQuick.Controls 2.4
import "../APCCommon"

Menu {
    id: windowMenu

    property var pageHandleParent
    property var currentPage

    Item {
        Menu {
            id: menuPopu
            property var menuButton
            property var pageHandle

            function show(menuButton, pageHandle) {
                menuPopu.menuButton = menuButton
                menuPopu.pageHandle = pageHandle
                popup()
            }

            MenuItem {
                text: '复制'
                onTriggered: windowMenu.addItem_(GBQMl.copyOnePage(menuPopu.pageHandle.pageName))
            }
            MenuItem {
                text: '删除'
                onTriggered: {
                    GBQMl.deleteOnePage(menuPopu.pageHandle.pageName)
                    windowMenu.removeItem(menuPopu.menuButton)
                }
            }
            MenuItem {
                text: '属性'
                onTriggered: menuPopu.pageHandle.showDialog(menuPopu.pageHandle, '窗口')
            }
        }
    }

    Component {
        id: menuItem

        MenuItem {

            signal rightClicked()
            signal deleted()

            checkable: true
            autoExclusive: true
            icon.source: 'qrc:/image/browser_window.png'

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
            Component.onDestruction: deleted()
        }
    }

    function addItem_(pageName) {
        var menuButton = menuItem.createObject(windowMenu.contentItem, {'text':pageName})
        var pageHandle = GB.newPage(pageHandleParent, {pageName:pageName})
        pageHandle.visible = false

        menuButton.text =  Qt.binding(function(){  return pageHandle.pageName })

        menuButton.clicked.connect(function(){
            if(currentPage != undefined) {
                currentPage.visible = false
            }

            currentPage = pageHandle
            currentPage.visible = true
        })
        menuButton.rightClicked.connect(function(){
            menuPopu.show(menuButton, pageHandle)
        })
        menuButton.deleted.connect(function(){ pageHandle.destroy() })  //自动删除绑定页面

        if(windowMenu.count == 2) {
            menuButton.checked = true
            currentPage = pageHandle
            currentPage.visible = true
        }
    }

    function readPages() {
        var pages = GBQMl.readPages()
        for(var key in pages) {
            windowMenu.addItem_(pages[key])
        }
    }
    function reload() {
        windowMenu.clear()
        windowMenu.readPages()
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
    Component.onCompleted: readPages()
}
