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

    property string saveLocation: ''
    signal saveData(var data)

    function save() {
        return {saveLocation}
    }

    FileDialog {
          id: fileDialog
          fileMode : FileDialog.SaveFile

          defaultSuffix:"ini"
          nameFilters: [ "(*.ini)", "All files (*)" ]
          folder: StandardPaths.writableLocation(StandardPaths.DesktopLocation)

          onAccepted: {
              saveLocation = fileDialog.currentFile.toString().slice(8);
          }
    }

    Component.onCompleted: {open()}

    GridLayout {
        anchors.fill: parent
        columns: 10

        Label {Layout.columnSpan: 1;  text: '存储位置' }
        TextField {
            Layout.preferredWidth: 200
            Layout.columnSpan: 8;
            readOnly: true
            text: saveLocation
            clip: true
        }
        Button {
            Layout.columnSpan: 1;
            text: '浏览'
            onClicked: {
                fileDialog.open()
            }
        }

        Button {
            Layout.columnSpan: 5
            Layout.alignment: Qt.AlignCenter
            text: '取消'
            onClicked:  root.destroy()
        }
        Button {
            Layout.columnSpan: 5
            Layout.alignment: Qt.AlignCenter
            text: '保存'
            onClicked: {
                saveData(save())
                root.destroy();
            }
        }
    }
    implicitHeight: 200
    implicitWidth: 400
    Component.onDestruction: print("newProjectDialog delete")
}
