import QtQuick 2.10
import Qt.labs.platform 1.1
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../APCCommon"
import Common.API 1.0


Dialog {
    id: root
    title: "参数配置"
    anchors.centerIn: Overlay.overlay
    modal: true
    closePolicy: Popup.NoAutoClose

    property string source: ""
    property string runjs: ""

    signal saveData(var data)

    //function save() { return {runjs, source} }

    FileDialog {
        id: fileDialog
        fileMode : FileDialog.OpenFile

        nameFilters: [ "image files(*.png *.jpg *.gif *.svg)", "All files (*)"]
        folder: StandardPaths.writableLocation(StandardPaths.DesktopLocation)
        onAccepted: {
            source = fileDialog.currentFile.toString()
        }
    }

    Component.onCompleted: open()

    GridLayout {
        anchors.fill: parent
        columns: 4

        Label {Layout.columnSpan: 1;  text: '文件位置' }
        TextField {
            Layout.preferredWidth: 300;
            Layout.columnSpan: 2;
            readOnly: true
            text: source
        }
        Button {
            Layout.columnSpan: 1;
            text: '浏览'
            onClicked: {
                fileDialog.open()
            }
        }

        ScrollView {
            Layout.columnSpan: 4
            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollBar.vertical.width : 8
            ScrollBar.horizontal.height : 8
            background: Rectangle { color: 'white' }
            TextArea {
                background: Rectangle { color: 'transparent' }
                placeholderText: '数据变化执行脚本'

                selectByMouse: true
                ToolTip.timeout : 1000000000
                text: root.runjs
                onTextChanged: {
                    try {
                        root.parent.execjs(text)
                        ToolTip.visible = false
                    } catch (message) {
                        ToolTip.text = message.toString()
                        ToolTip.visible = true
                    }
                }
                onEditingFinished:  root.runjs = text
            }
        }

        Button {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignCenter
            text: '取消'
            onClicked: {
                root.destroy();
            }
        }
        Button {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignCenter
            text: '保存'
            onClicked: {
                saveData(save())
                root.destroy();
            }
        }
    }
    Component.onDestruction: print("LabelDialog delete")
    implicitHeight: 600
    implicitWidth: 600
}
