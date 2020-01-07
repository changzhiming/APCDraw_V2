import QtQuick 2.10
import Qt.labs.platform 1.1
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Dialog {
    id: root
    title: "工程参数"
    anchors.centerIn: Overlay.overlay
    modal: true
    closePolicy: Popup.NoAutoClose
    spacing: 0

    property string deviceName: '设备'
    property string protocol: ''
    property string url: ''
    property string port: ''
    property string clientId: ''
    property string username: ''
    property string password: ''
    property string topicList: ''
    property string modbusList: ''

    signal saveData(var data)

    function save() {
        return {deviceName, protocol, url, port, clientId, username, password, topicList, modbusList}
    }
    Component.onCompleted: open()

    GridLayout {
        anchors.fill: parent
        columns: 4

        Label {  text: '设备名称' }
        TextField {
            Layout.fillWidth: true
            text: root.deviceName
            background: Rectangle { color: 'white' }
            onEditingFinished: {root.deviceName = text}
        }
        Label {text: '设备协议'}
        ComboBox {
            id: protocolCombox
            background: Rectangle { color: 'white' }
            Layout.fillWidth: true
            model: [ 'MQTT', 'Modbut TCP']
            onCurrentTextChanged: currentIndex !== 0 ? root.protocol = currentText : ''
            Component.onCompleted: {
                var index = find(root.protocol)
                currentIndex = index > 0 ? index : 0
            }
        }

        Label {  text: '设备地址' }
        TextField {
            Layout.fillWidth: true
            text: root.url
            background: Rectangle { color: 'white' }
            onEditingFinished: {root.url = text}
        }
        Label {  text: '端口号' }
        TextField {
            Layout.fillWidth: true
            text: root.port
            background: Rectangle { color: 'white' }
            onEditingFinished: {root.port = text}
        }


        Label {  text: 'ClientId' }
        TextField {
            Layout.preferredWidth: 100
            Layout.fillWidth: true
            text: root.clientId
            background: Rectangle { color: 'white' }
            onEditingFinished: {root.clientId = text}
        }
        Label{}
        Label{}
        Label {  text: '用户名' }
        TextField {
            Layout.preferredWidth: 100
            Layout.fillWidth: true
            text: root.username
            background: Rectangle { color: 'white' }
            onEditingFinished: {root.username = text}
        }
        Label {  text: '密码' }
        TextField {
            Layout.preferredWidth: 100
            Layout.fillWidth: true
            text: root.password
            background: Rectangle { color: 'white' }
            onEditingFinished: {root.password = text}
        }

        ScrollView {
            Layout.columnSpan: 4
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollBar.vertical.width : 8
            ScrollBar.horizontal.height : 8
            background: Rectangle { color: 'white' }
            TextArea {
                background: Rectangle { color: 'transparent' }
                placeholderText: '输入设备mqtt 设备id例如: 343534343;44242343;'
                selectByMouse: true
                text: root.topicList
                onEditingFinished: {root.topicList = text}
            }
        }


        ScrollView {
            Layout.columnSpan: 4
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollBar.vertical.width : 8
            ScrollBar.horizontal.height : 8
            background: Rectangle {
                color: 'white'
            }
            TextArea {
                background: Rectangle { color: 'transparent' }
                text: root.modbusList
                selectByMouse: true
                placeholderText: '输入modbus寄存器例如 2_1_0_24  线圈主地址1 查询0-24个地址'
                onEditingFinished: {root.modbusList = text}
            }
        }

        Button {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignCenter
            text: '取消'
            onClicked:  root.destroy()
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
    implicitHeight: 600
    implicitWidth: 600
    Component.onDestruction: print("DeviceDialog delete")
}
