import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../APCCommon"

Label {
    id: root
    property string type : '文本'
    property real fontsize : 15
    property bool fontbold : false
    property string fontfamily : '宋体'
    property color backgroundColor : 'white'
    property color borderColor : 'white'
    property real borderWidth : 0
    property real borderRadius : 0
    property string runjs: ""

    function save() { return Object.assign({type, x, y, width, height}, controlPropertys()) }
    //控件属性
    function controlPropertys() {
        return {text, fontsize, fontbold, fontfamily, backgroundColor:backgroundColor.toString(), borderColor:borderColor.toString(), borderWidth,borderRadius,color:color.toString(), runjs}
    }
    function execjs(str) { return eval(str) }
    function interval_run() { execjs(runjs) }

    text: "文本"
    color: 'black'
    font.pixelSize: fontsize
    font.bold: fontbold
    font.family: fontfamily

    background: Rectangle {
        id:background_id
        color: backgroundColor
        border.color: borderColor
        border.width: borderWidth
        radius: borderRadius
    }
    verticalAlignment: Label.AlignVCenter
    horizontalAlignment: Label.AlignHCenter

    //-------------------------------------//
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
