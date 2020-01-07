import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../APCCommon"

TextField {
    id: root

    property string type : '输入'
    property real fontsize : 15
    property bool fontbold : false
    property string fontfamily : '宋体'
    property color backgroundColor : 'white'
    property color borderColor : 'gray'
    property real borderWidth : 2
    property real borderRadius : 0
    property string runjs: ""
    property string returnjs: ""

    function save() { return Object.assign({type, x, y, width, height}, controlPropertys()) }
    //控件属性
    function controlPropertys() {
        return {text, fontsize, fontbold, fontfamily, backgroundColor:backgroundColor.toString(), borderColor:borderColor.toString(), borderWidth,borderRadius,color:color.toString(), runjs, returnjs}
    }
    function execjs(str) { return eval(str) }
    function interval_run() { execjs(runjs) }

    background: Rectangle {
        id: background_id
        color: backgroundColor
        border.color: Qt.darker(borderColor, root.focus ? 1.5 : 1)
        border.width: borderWidth
        radius: borderRadius
    }
    selectByMouse: true
    placeholderText: '输入'
    color: 'black'
    font.pixelSize: fontsize
    font.bold: fontbold
    font.family: fontfamily

    verticalAlignment: TextField.AlignVCenter
    horizontalAlignment: TextField.AlignHCenter
    onEditingFinished: {execjs(returnjs)}

    //---------------------------------//
    property bool checkabled: false
    onCheckabledChanged: {
        if(checkabled) {
            background_id.border.color = 'blue'
            background_id.border.width = checkabled == true ? 3 : 0
        } else {
            background_id.border.color = borderColor
            background_id.border.width = borderWidth
        }
    }
}
