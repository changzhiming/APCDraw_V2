.pragma library

var selectType = "选择"

function createSpriteObjects(filePath, propertys, parent)
{
    var component = Qt.createComponent(filePath);
    return component.createObject(parent, propertys);
}

function newPage(parent, propertys)
{
    return createSpriteObjects('qrc:/Control/APCPageContainer.qml', propertys, parent)
}

function showDialogNewProject(parent, propertys)
{
    return createSpriteObjects('qrc:/Dialog/NewProjectDialog.qml', propertys, parent)
}
function showDialogButton(control, propertys)
{
    return createSpriteObjects('qrc:/Dialog/ButtonDialog.qml', propertys, control)
}
function showDialogInput(control, propertys)
{
    return createSpriteObjects('qrc:/Dialog/InputDialog.qml', propertys, control)
}
function showDialogImage(control, propertys)
{
    return createSpriteObjects('qrc:/Dialog/ImageDialog.qml', propertys, control)
}
function showDialogLabel(control, propertys)
{
    return createSpriteObjects('qrc:/Dialog/LabelDialog.qml', propertys, control)
}
function showDialogPage(control, propertys)
{
    return createSpriteObjects('qrc:/Dialog/PageDialog.qml', propertys, control)
}
function showHint(parent, text)
{
    return createSpriteObjects('qrc:/Dialog/HintDialog.qml', {text:text}, parent)
}
function showDevicesDialog(parent, propertys) {
    return createSpriteObjects('qrc:/Dialog/DevicesDialog.qml', propertys, parent)
}

function newLabel(parent, propertys)
{
    return createSpriteObjects('qrc:/Control/ControlLabel.qml', propertys, parent)
}
function newButton(parent, propertys)
{
    return createSpriteObjects('qrc:/Control/ControlButton.qml', propertys, parent)
}
function newInput(parent, propertys)
{
    return createSpriteObjects('qrc:/Control/ControlInput.qml', propertys, parent)
}
function newImage(parent, propertys)
{
    return createSpriteObjects('qrc:/Control/ControlImage.qml', propertys, parent)
}


