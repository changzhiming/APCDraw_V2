import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../APCCommon"

Image {
    id: root
    property string type : '图片'
    property string runjs: ""
    source: '/image/image_picture.svg'
    sourceSize.width: width
    sourceSize.height: height

    function save() { return Object.assign({type, x, y, width, height}, controlPropertys()) }
    //控件属性
    function controlPropertys() { return {runjs, source}  }

    function execjs(str) { return eval(str) }
    function interval_run() {  execjs(runjs) }
    //---------------------------------//
    Rectangle {
        id:background_id
        anchors.fill: root
        color: 'transparent'
    }
    property bool checkabled: false
    onCheckabledChanged: {
        if(checkabled) {
            background_id.border.color = 'blue'
            background_id.border.width = checkabled == true ? 3 : 0
        } else {
            background_id.border.color = 'white'
            background_id.border.width = 0
        }
    }
}
