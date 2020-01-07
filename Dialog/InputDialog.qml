import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3


Dialog {
    id: root
    title: "参数配置"
    anchors.centerIn: Overlay.overlay
    modal: true
    closePolicy: Popup.NoAutoClose

    property real fontsize : 15
    property bool fontbold : false
    property string fontfamily : '宋体'
    property color backgroundColor : 'white'
    property color borderColor : 'white'
    property color color : 'white'
    property real borderWidth : 0
    property real borderRadius : 0
    property string text: ""
    property string runjs: ""
    property string returnjs: ""

    signal saveData(var data)

    function save() {
        return {text, fontsize, fontbold, fontfamily, backgroundColor:backgroundColor.toString(), borderColor:borderColor.toString(), borderWidth,borderRadius,color:color.toString(), runjs, returnjs}
    }
    Component.onCompleted: open()

    GridLayout {
        anchors.fill: parent
        columns: 4
        Label {  text: '显示内容' }
        TextField {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            text: root.text
            onEditingFinished: {root.text = text}
        }
        Label {text: '字体类型'}
        ComboBox {
            Layout.fillWidth: true
            model: Qt.fontFamilies()
            background: Rectangle { color: 'white' }
            currentIndex : find(root.fontfamily)
            onCurrentTextChanged: currentIndex !== 0 ? root.fontfamily = currentText : ''
            Component.onCompleted: currentIndex = find(root.fontfamily)
        }

        Label {text: '字体颜色'}
        TextField {
            Layout.fillWidth: true
            selectByMouse: true
            background: Rectangle { color: 'white' }
            text: root.color
            onEditingFinished: {root.color = text}
        }
        Label {text: '字体大小'}
        SpinBox {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            value: root.fontsize
            onValueChanged: {root.fontsize = value}
        }
        Label {text: '字体加粗'}
        CheckBox {
            Layout.fillWidth: true
            text: qsTr("字体加粗")
            background: Rectangle { color: 'white' }
            checked: root.fontbold
            onCheckedChanged: {
                root.fontbold = checked
            }
        }
        Label {text: '背景色'}
        TextField {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            text: root.backgroundColor
            selectByMouse: true
            onEditingFinished: {root.backgroundColor = text}
        }
        Label {text: '边框圆角'}
        SpinBox {
            Layout.fillWidth: true
            value: root.borderRadius
            background: Rectangle { color: 'white' }
            onValueChanged: {root.borderRadius = value}
        }
        Label {text: '边框颜色'}
        TextField {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            selectByMouse: true
            text: root.borderColor
            onEditingFinished: {root.borderColor = text}
        }
        Label {text: '边框线宽'}
        SpinBox {
            Layout.fillWidth: true
            background: Rectangle { color: 'white' }
            value: root.borderWidth
            onValueChanged: {root.borderWidth = value}
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
                onCursorPositionChanged: {
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
        ScrollView {
            Layout.columnSpan: 4
            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollBar.vertical.width : 8
            ScrollBar.horizontal.height : 8
            background: Rectangle { color: 'white' }
            TextArea {
                background: Rectangle { color: 'transparent' }
                placeholderText: '输入完成执行脚本'
                selectByMouse: true
                ToolTip.timeout : 1000000000
                text: root.returnjs
                onTextChanged: {
                    try {
                        root.parent.execjs(text)
                        ToolTip.visible = false
                    } catch (message) {
                        ToolTip.text = message.toString()
                        ToolTip.visible = true
                    }
                }
                onEditingFinished:  root.returnjs = text
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
    Component.onDestruction: print("InputDialog delete")
    implicitHeight: 600
    implicitWidth: 600
}
