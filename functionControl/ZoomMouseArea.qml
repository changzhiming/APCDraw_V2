import QtQuick 2.11
import QtQuick.Controls 2.4
import "../APCCommon"

MouseArea {
    id: root
    property point pressPoint: Qt.point(-1, -1)
    property var pressItem

    property int zoomed: ZoomMouseArea.Normal

    property var rootItem    //显示子控件的父控件
    property var childItems  //所有子控件

    signal doubleClickItem(var item, string type)
    signal createControl(string type, rect selectRect)
    signal scaleChangled(real scale)

    hoverEnabled: true

    enum ZoomType {
        Normal,
        WidthChange,
        HeightChange,
        WidthHeightChange
    }

    function zoomType(cursorShape) {
        switch(cursorShape) {
        case Qt.SizeVerCursor:
            return ZoomMouseArea.HeightChange
        case Qt.SizeHorCursor:
            return ZoomMouseArea.WidthChange
        case Qt.SizeFDiagCursor:
            return ZoomMouseArea.WidthHeightChange
        case Qt.ArrowCursor:
            return ZoomMouseArea.Normal
        default:
            return ZoomMouseArea.Normal
        }
    }
    function getCursorShape(x, y) {
        var child = rootItem.childAt(mouseX, mouseY)
        if(child.type !== undefined) {

            var sapceWidth = child.x + child.width - x
            var spaceHeight = child.y + child.height - y
            if(sapceWidth > 0 && sapceWidth < 5 && spaceHeight > 0 && spaceHeight < 5) {
                return Qt.SizeFDiagCursor
            }
            if(sapceWidth > 0 && sapceWidth < 5 && spaceHeight > 0 && spaceHeight < child.height) {
                return Qt.SizeHorCursor
            }
            if(spaceHeight > 0 && spaceHeight < 5 && sapceWidth > 0 && sapceWidth < child.width) {
                return Qt.SizeVerCursor
            }
        }
        return Qt.ArrowCursor
    }
    function selectAt(x, y, width, height) {

        for(var child of Object.values(childItems)) {
            if(((child.width + child.x) > x && child.x < (x + width)) && ((child.height + child.y) > y && child.y < (y + height))) {
                if(child.checkabled !== undefined){child.checkabled = true}
            }
        }
    }

    Rectangle {
        id: select_rec
        border.color: 'red'
        border.width: 1
        color: 'transparent'
        visible: false
    }

    onDoubleClicked: {
        var child = rootItem.childAt(mouseX, mouseY)
        doubleClickItem(child.type !== undefined ? child: undefined, child.type)
    }
    onPressed: {
        zoomed = zoomType(cursorShape)

        let child = rootItem.childAt(mouseX, mouseY)

        //清空选中
        if (((mouse.button == Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier )) == false) {
            for(var checkChild of Object.values(childItems)) {
                if(checkChild.checkabled !== undefined) {
                    checkChild.checkabled = false
                }
            }
        }
        //选中
        if(child.type  !== undefined) { child.checkabled = true }

        pressItem = child.type !== undefined ? child: undefined
        pressPoint = Qt.point(mouseX, mouseY)
    }
    onPositionChanged: {
        //改变大小
        if(zoomed !== ZoomMouseArea.Normal) {
            switch(zoomed) {
            case ZoomMouseArea.WidthChange:
                pressItem.width += mouseX - pressPoint.x
                break
            case ZoomMouseArea.HeightChange:
                pressItem.height += mouseY - pressPoint.y
                break
            case ZoomMouseArea.WidthHeightChange:
                pressItem.width += mouseX - pressPoint.x
                pressItem.height += mouseY - pressPoint.y
                break
            }
            pressPoint = Qt.point(mouseX, mouseY)

            return
        }
        //移动
        if(pressItem !== undefined) {
            if(Math.abs(mouseX - pressPoint.x) > 5 && Math.abs(mouseY - pressPoint.y) > 5) {
                for(var child of Object.values(childItems)) {
                    if(child.checkabled === true) {
                        child.x += mouseX - pressPoint.x
                        child.y += mouseY - pressPoint.y
                    }
                }
                pressPoint = Qt.point(mouseX, mouseY)
            }

            return
        }
        //绘图 或 选择
        if(pressPoint.x >= 0 && pressPoint.y >= 0) {
            select_rec.visible = true
            select_rec.x = pressPoint.x
            select_rec.y = pressPoint.y
            select_rec.width = mouseX - pressPoint.x
            select_rec.height = mouseY - pressPoint.y

            return
        }
        cursorShape = getCursorShape(mouseX, mouseY)
    }

    onReleased: {
        if(mouseX - pressPoint.x > 10 && mouseY - pressPoint.y > 10 && pressItem === undefined) {
            if(GB.selectType !== '选择') {
                createControl(GB.selectType, Qt.rect(pressPoint.x, pressPoint.y, mouseX - pressPoint.x, mouseY - pressPoint.y))
            } else {
                root.selectAt(pressPoint.x, pressPoint.y, mouseX - pressPoint.x, mouseY - pressPoint.y);
            }
        }

        select_rec.visible = false
        pressPoint = Qt.point(-1, -1)
        pressItem = undefined
        zoomed = ZoomMouseArea.Normal
    }

    onWheel: {
        if(wheel.modifiers & Qt.ControlModifier) {
            scaleChangled(wheel.angleDelta.y > 0 ? 0.1: -0.1)
        }
    }
}
