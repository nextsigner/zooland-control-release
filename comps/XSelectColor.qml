import QtQuick 2.2
import QtQuick.Dialogs 1.0
//import "comps" as Comps

ColorDialog {
    id: colorDialog
    title: "Seleccionar Color"

    property string c: ''
    property color uColor
    onVisibilityChanged: {
        if(visible){
            currentColor=apps[c]
            uColor=currentColor
        }
    }
    onCurrentColorChanged: {
        apps[c]=currentColor
    }
    onAccepted: {
        apps[c]=colorDialog.color
    }
    onRejected: {
        apps[c]=uColor
    }
}
