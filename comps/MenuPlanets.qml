import QtQuick 2.12
import QtQuick.Controls 2.12
import "../js/Capture.js" as Cap
Menu {
    id: r
    width: app.fs*8
    property int currentIndexPlanet: -1
    property var aMI: []
    property bool isBack: false
    onOpenedChanged:  menuBar.expanded=opened
    //onCurrentIndexChanged: menuBar.uCMI=aMI[currentIndex]
    Component.onCompleted: menuBar.aMenuItems.push(this)
    delegate: MenuItem {
        id: menuItem
        implicitWidth: 200
        implicitHeight: 40

        arrow: Canvas {
            x: parent.width - width
            implicitWidth: 40
            implicitHeight: 40
            visible: menuItem.subMenu
            onPaint: {
                var ctx = getContext("2d")
                ctx.fillStyle = menuItem.highlighted ? "#ffffff" : "#21be2b"
                ctx.moveTo(15, 15)
                ctx.lineTo(width - 15, height / 2)
                ctx.lineTo(15, height - 15)
                ctx.closePath()
                ctx.fill()
            }
        }

        indicator: Item {
            implicitWidth: 40
            implicitHeight: 40
            Rectangle {
                width: 26
                height: 26
                anchors.centerIn: parent
                visible: menuItem.checkable
                border.color: "#21be2b"
                radius: 3
                Rectangle {
                    width: 14
                    height: 14
                    anchors.centerIn: parent
                    visible: menuItem.checked
                    color: "#21be2b"
                    radius: 2
                }
            }
        }
        contentItem: Text {
            leftPadding: menuItem.indicator.width
            rightPadding: menuItem.arrow.width
            text: menuItem.text.replace('&', '')
            font: menuItem.font
            opacity: enabled ? 1.0 : 0.3
            color:menuItem.highlighted ? apps.fontColor : apps.backgroundColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            color: menuItem.highlighted ?  apps.backgroundColor : apps.fontColor
        }
    }
    title: 'Menu '+app.planetas[r.currentIndexPlanet]
    Action {text: qsTr("Características de "+app.planetas[app.planetasRes.indexOf(app.uSonFCMB.split('_')[0])]); onTriggered: {
            xInfoData.markDown=true
            xInfoData.loadData('./resources/caracteristicas_'+(''+app.planetas[r.currentIndexPlanet]).toLocaleLowerCase()+'')}
    }
    Action {text: qsTr('Info '+app.planetas[app.planetasRes.indexOf(app.uSonFCMB.split('_')[0])]+' en '+app.signos[app.objSignsNames.indexOf(app.uSonFCMB.split('_')[1])]+' en casa '+app.uSonFCMB.split('_')[2]); onTriggered: {
            app.j.showIWFromCtxMenuBar()
        }
    }
    Action {text: qsTr(apps.anColorXAs?"No Centellar":"Centellar"); onTriggered: {
            apps.anColorXAs=!apps.anColorXAs
        }
    }
    Action {text: qsTr("Grabar Posición"); onTriggered: {
            app.j.saveZoomAndPos()
        }
    }
    Action {text: qsTr("Capturar"); onTriggered: {
            if(!r.isBack){
                Cap.captureSweg()
            }else{
                Cap.captureSwegBack()
            }
        }
    }
}
