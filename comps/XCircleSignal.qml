import QtQuick 2.0
import QtQuick.Particles 2.12

Item {
    id: r
    width: parent.width
    height: parent.height
    property int cc: rep.model
    property int cc2: rep2.model
    Item{
        id: xRects1
        width: r.width
        height: r.height
        anchors.centerIn: parent
        Repeater{
            id: rep
            model: r.visible?30:0
            Rectangle{
                objectName: 'cir_'+index
                width: app.fs*0.5*(index + 1)
                height: width
                radius: width*0.5
                anchors.centerIn: parent
                color: 'transparent'
                border.width: 4
                border.color: 'yellow'
                antialiasing: true
                opacity: 0.0
                Behavior on opacity{NumberAnimation{duration: 200}}
                SequentialAnimation on border.color {
                    loops: Animation.Infinite
                    ColorAnimation { from: apps.pointerLineColor; to: apps.fontColor; duration: 100 }
                    ColorAnimation { from: apps.fontColor; to: apps.pointerLineColor; duration: 100 }
                }

            }
        }
    }
    Rectangle{
        id: xAxis
        color: 'transparent'
        width: 10
        height: r.width*5
        anchors.centerIn: parent
        Column{
            anchors.centerIn: parent
            Rectangle{
                width: 3
                height: xAxis.height*0.5-apps.sweFs*4
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle{
                color: 'transparent'
                width: apps.sweFs*4
                height: apps.sweFs
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle{
                width: 3
                height: xAxis.height*0.5-apps.sweFs*4
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Column{
            rotation: 90
            anchors.centerIn: parent
            Rectangle{
                width: 3
                height: xAxis.height*0.5-apps.sweFs*4
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle{
                color: 'transparent'
                width: apps.sweFs*4
                height: apps.sweFs
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle{
                width: 3
                height: xAxis.height*0.5-apps.sweFs*4
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        SequentialAnimation on rotation{
            loops: Animation.Infinite
            RotationAnimation{
                from:0
                to: 180
                duration: 3000
            }
            RotationAnimation{
                from:180
                to: -45
                duration: 2000
            }
            RotationAnimation{
                from:-45
                to: 360
                duration: 1500
            }
        }
    }
    Item{
        id: xRects2
        width: r.width
        height: r.height
        anchors.centerIn: parent
        Repeater{
            id: rep2
            model: r.visible?30:0
            Rectangle{
                objectName: 'cir2_'+index
                width: app.fs*0.5*(index + 1)
                height: width
                radius: width*0.5
                anchors.centerIn: parent
                color: 'transparent'
                border.width: 4
                border.color: 'yellow'
                antialiasing: true
                opacity: 0.0
                Behavior on opacity{NumberAnimation{duration: 200}}
                SequentialAnimation on border.color {
                    loops: Animation.Infinite
                    ColorAnimation { from: apps.pointerLineColor; to: apps.fontColor; duration: 100 }
                    ColorAnimation { from: apps.fontColor; to: apps.pointerLineColor; duration: 100 }
                }

            }
        }
    }
    Timer{
        running: true
        repeat: true
        interval: 250
        onTriggered: setCir()
    }
    function setCir(){
        for(var i=0;i<xRects1.children.length;i++){
            if(xRects1.children[i].objectName.indexOf('cir_')>=0){
                xRects1.children[i].opacity=0.0
            }
        }
        for(i=xRects1.children.length-1;i>0;i--){
            if(xRects1.children[i].objectName.indexOf('cir_')>=0 && xRects1.children[i].objectName.indexOf('cir_'+r.cc)>=0){
                xRects1.children[i].opacity=1.0
            }
        }
        if(r.cc>0){
            r.cc--
        }else{
            r.cc=rep.model
        }
    }
}

