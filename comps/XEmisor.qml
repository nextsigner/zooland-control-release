import QtQuick 2.0
import QtQuick.Particles 2.12

Item {
    id: root
    width: parent.width
    height: parent.height
    property alias img1: blip.source
    property alias emitRate1: e1.emitRate
    property alias lifeSpan1: e1.lifeSpan
    property alias lifeSpanVariation1: e1.lifeSpanVariation
    property alias size1: e1.size
    property alias sizeVariation1: e1.sizeVariation
    property alias pda1X: pda1.x
    property alias pda1Y: pda1.y
    property alias pda1Vx: pda1.xVariation
    property alias pda1Vy: pda1.yVariation
    property bool paused: false
    property int uER: e1.emitRate
    property int w1: 300
    onPausedChanged: {
        if(!paused){
            e1.emitRate=uER
        }else{
            uER=e1.emitRate
            e1.emitRate=0
        }
    }
    ParticleSystem {
        id: particleSys

    }

    Emitter {
        id: e1
        width: root.width//*0.5
        height: app.fs*0.5
        anchors.verticalCenter: parent.verticalCenter
        //anchors.horizontalCenter: parent.horizontalCenter
        system: particleSys
        emitRate: 300
        lifeSpan: 200



        //velocity: PointDirection {id: pdv1; xVariation: 4; yVariation: 10;}
        velocity: PointDirection {id: pdv1; xVariation: 100; yVariation: root.w1;}
        //acceleration: PointDirection {id: pda1; xVariation: 10; yVariation: 10;}
        acceleration: PointDirection {id: pda1; xVariation: 100; yVariation: 100;}

        velocityFromMovement: 8

        size: app.fs*0.15
        sizeVariation: app.fs*0.25
        shape: RectangleShape {fill: true}
        ImageParticle {
            id: blip
            anchors.fill: parent
            system: particleSys
            source: "../resources/imgs/planetas/moon_i.png"            
            //clip: true
        }

    }
}

