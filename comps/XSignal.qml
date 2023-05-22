import QtQuick 2.0
import QtQuick.Particles 2.12

Item {
    id: r
    width: parent.width
    height: parent.height
    property int numAstro: 0
    Row{
        id: row
        anchors.centerIn: r
        Repeater{
            id: rep
            model: 30
            Rectangle{
                id: xSen
                width: r.width/rep.model//.length
                height: r.height//ancho de señal no afecta
                //border.width: 1
                //border.color: 'blue'
                color: 'transparent'
                anchors.verticalCenter: parent.verticalCenter
                onOpacityChanged: if(opacity===0.0)tShow.restart()
                property int dur: 250
                Behavior on opacity{NumberAnimation{id: na1;duration: xSen.dur}}
                Timer{
                    id: tShow
                    interval: 1000
                    onTriggered: {
                        xSen.dur=250
                        parent.opacity=1.0
                    }
                }
                XEmisor{
                    id: emisor1
                    width: parent.width*0.25
                    height: 1*index+app.fs*0.55
                    //color: 'red'
                    img1: r.numAstro<=9?"../resources/imgs/planetas/"+app.planetasRes[r.numAstro]+"_i.png":"../resources/imgs/sol1.png"
                    lifeSpan1: 500+((index+1))
                    sizeVariation1: 1*((index+1)*0.1)
                    size1: 1*((index+1)*0.01)
                    //w1:((index+1)*(index+1))*(parseFloat('0.'+index))
                    w1:(100/120*(index+1))*(100/120*(index+1))*0.25//*(parseFloat('0.'+index))
                    emitRate1: 50
                    anchors.centerIn: parent
                }
                XEmisor{
                    id: emisor2
                    width: parent.width*0.25
                    height: 1*index+app.fs*0.5
                    img1: emisor1.img1
                    lifeSpan1: 200+(index+1)
                    size1: 1*((index+1)*0.01)
                    w1:emisor1.w1
                    emitRate1: 100
                    anchors.centerIn: parent
                }
            }
        }
    }
    Timer{
        running: r.visible&&r.opacity===1.0
        repeat: true
        interval: 50
        property int ce: 0
        onTriggered: {
            if(row.children[ce].opacity===1.0){
                //row.children[ce].dur=250
                row.children[ce].opacity=0.0
            }else{
                //row.children[ce].dur=10
                row.children[ce].opacity=1.0
            }
            if(ce<rep.model){
                ce++
            }else{
                ce=0
            }

        }
    }
}

