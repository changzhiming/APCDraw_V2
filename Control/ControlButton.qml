import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../APCCommon"

ToolButton {
    id: root
    property string type : '按钮'
    property real fontsize : 15
    property bool fontbold : false
    property string fontfamily : '宋体'
    property color backgroundColor : 'gray'
    property color borderColor : 'white'
    property real borderWidth : 0
    property real borderRadius : 0
    property color color: 'black'
    property string runjs: ""
    property string pressjs: ""

    //要保存的控件属性
    function save() { return Object.assign({type, x, y, width, height}, controlPropertys()) }
    //控件属性
    function controlPropertys() {
        return {text, fontsize, fontbold, fontfamily,backgroundColor:backgroundColor.toString(), borderColor:borderColor.toString(), borderWidth,borderRadius,color:color.toString(),runjs, pressjs}
    }
    function execjs(str) { return eval(str) }
    function interval_run() {execjs(runjs) }

    highlighted: true
    flat: false
    text: '按钮'
    font.pixelSize: fontsize
    font.bold: fontbold
    font.family: fontfamily

    background: Rectangle {
        id: background_id
        color: Qt.darker(backgroundColor , root.pressed ? 3 : 1.0)
        border.color: borderColor
        border.width: borderWidth
        radius: borderRadius
    }

    onColorChanged: contentItem.color = root.color;
    onClicked: {execjs(pressjs);}
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
