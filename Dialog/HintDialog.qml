import QtQuick 2.10
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.12


ToolTip {
      id: control
      text: qsTr("提示")

      anchors.centerIn: Overlay.overlay
      visible: true
      timeout: 2000
      font.pointSize: 20

      width: 200
      height: 100

      contentItem: Label {
          text: control.text
          font: control.font
          verticalAlignment: Label.AlignVCenter
          horizontalAlignment: Label.AlignHCenter
      }

      background: Rectangle {
          DropShadow  {
              anchors.fill: rect
              horizontalOffset: 0
              verticalOffset: 0
              spread :0.2
              radius: 8
              samples: 17
              color: "#80000000"
              source: rect
          }
          Rectangle {
              id: rect
              anchors.fill: parent
              color: 'white'
          }
      }


      onVisibleChanged: {
          if(control.visible == false)  {
              control.destroy()
          }
      }
  }

