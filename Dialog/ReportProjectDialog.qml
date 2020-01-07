import QtQuick 2.0
import QtQuick.Dialogs 1.3

FileDialog {
      id: fileDialog
      title: "选择文件夹"
      folder: shortcuts.home
      selectFolder: true
      onAccepted: {
          console.log("You chose: " + fileDialog.fileUrls)
      }
      onRejected: {
          console.log("Canceled")
      }
  }
