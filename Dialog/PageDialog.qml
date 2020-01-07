import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Dialog {
    id: root
    title: "窗口参数"
    anchors.centerIn: Overlay.overlay
    modal: true
    closePolicy: Popup.NoAutoClose

    property string enterJS: ''
    property string runJS: ""
    property string levealJS: ""

    property int timerInteral: 1000
    property int childsTimerInteral: 1000

    property color backgroundColor : 'white'
    property color borderColor : 'black'
    property real borderWidth : 1
    property real borderRadius : 0
    property real windowWith : 1000
    property real windowheight :800
    property string windowType: '嵌入式窗口'

    property string pageName: "窗口"

    signal saveData(var data)

    function save() {
        return {backgroundColor:backgroundColor.toString(),borderColor:borderColor.toString(), borderWidth,borderRadius,enterJS, runJS, levealJS, pageName,timerInteral, childsTimerInteral,windowWith, windowheight,windowType}
    }

    Component.onCompleted: {open()}

    GridLayout {
        anchors.fill: parent
        columns: 4
        Label {  text: '窗口名称' }
        TextField {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            text: root.pageName
            selectByMouse: true
            onEditingFinished: {root.pageName = text}
        }

        Label {text: '窗口类型'}
        ComboBox {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            model: ['嵌入式窗口', '弹出式窗口', '侧边栏窗口']
            currentIndex : find(root.windowType)
            onCurrentTextChanged: currentIndex !== 0 ? root.windowType = currentText : ''
            Component.onCompleted: currentIndex = find(root.windowType)
        }

        Label {  text: '背景色' }
        TextField {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            text: root.backgroundColor
            selectByMouse: true
            onEditingFinished: {root.backgroundColor = text}
        }
        Label {text: '边框颜色'}
        TextField {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            text: root.borderColor
            selectByMouse: true
            onEditingFinished: {root.borderColor = text}
        }
        Label {text: '边框线宽'}
        SpinBox {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            value: root.borderWidth
            onValueChanged: {root.borderWidth = value}
        }
        Label {}
        Label {}

        Label {text: '宽度' + slider_width.value.toFixed(1)}
        Slider {
            id: slider_width
            Layout.fillWidth: true
            value: root.windowWith
            from: 0
            to: 4000
            ToolTip {
                parent: slider_width.handle
                visible: slider_width.pressed
                text: slider_width.value.toFixed(1)
            }
            onValueChanged: {root.windowWith = value}
        }

        Label {text: '高度' + slider_height.value.toFixed(1)}
        Slider {
            id: slider_height
            Layout.fillWidth: true
            value: root.windowheight
            from: 0
            to: 4000
            ToolTip {
                parent: slider_height.handle
                visible: slider_height.pressed
                text: slider_height.value.toFixed(1)
            }
            onValueChanged: {root.windowheight = value}
        }

        Label {text: '运行期间\n执行间隔:' + slider_1.value.toFixed(1)}
        Slider {
            id: slider_1
            Layout.fillWidth: true
            value: root.timerInteral
            from: 0
            to: 10000
            ToolTip {
                parent: slider_1.handle
                visible: slider_1.pressed
                text: slider_1.value.toFixed(1)
            }
            onValueChanged: {root.timerInteral = value}
        }

        Label {text: '子控件\n执行间隔:'+slider_2.value.toFixed(1)}
        Slider {
            id: slider_2
            Layout.fillWidth: true
            value: root.childsTimerInteral
            from: 0
            to: 10000
            ToolTip {
                parent: slider_2.handle
                visible: slider_2.pressed
                text: slider_2.value.toFixed(1)
            }
            onValueChanged: {root.childsTimerInteral = value}
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
                placeholderText: '进入窗口执行脚本'
                selectByMouse: true
                ToolTip.timeout : 1000000000
                text: root.enterJS
                onTextChanged: {
                    try {
                        root.parent.execjs(text)
                        ToolTip.visible = false
                    } catch (message) {
                        ToolTip.text = message.toString()
                        ToolTip.visible = true
                    }
                }
                onEditingFinished: root.enterJS = text
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
                placeholderText: '窗口运行期间执行脚本'
                selectByMouse: true
                ToolTip.timeout : 1000000000
                text: root.runJS
                onTextChanged: {
                    try {
                        root.parent.execjs(text)
                        ToolTip.visible = false
                    } catch (message) {
                        ToolTip.text = message.toString()
                        ToolTip.visible = true
                    }
                }
                onEditingFinished:  root.runJS = text
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
                placeholderText: '退出窗口执行脚本'
                selectByMouse: true
                ToolTip.timeout : 1000000000
                text: root.levealJS
                onTextChanged: {
                    try {
                        root.parent.execjs(text)
                        ToolTip.visible = false
                    } catch (message) {
                        ToolTip.text = message.toString()
                        ToolTip.visible = true
                    }
                }
                onEditingFinished:  root.levealJS = text
            }
        }

        Button {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignCenter
            text: '取消'
            onClicked: {
                saveData({})
                root.destroy()
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
    implicitHeight: 800
    implicitWidth: 1000
    Component.onDestruction: print("pagedialog delete")
}
