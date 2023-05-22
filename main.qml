import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import "./js/Funcs_v2.js" as JS

import ZoolFileManager 1.3
import web.ZoolandControlServerFileDataManager 1.0
import comps.ZoolLogView 1.0

ApplicationWindow{
    id: app
    visible: true
    visibility: "Maximized"
    color:"black"
    property int fs: Screen.width*0.03
    property var j: JS
    property date currentDate

    property int currentMando: 0

    Settings{
        id: apps
        //property string minymaClientHost: 'ws://192.168.1.51'
        //property int minymaClientPort: 12345
        property color fontColor: 'white'
        property color backgroundColor: 'black'
        property string host: 'http://localhost'

    }
    Item{
        id: xApp
        anchors.fill: parent
        ZoolFileManager{id: zoolFileManager}


        //        Button{
//            text: "Enviar"
//            onClicked: {
//                minymaClient.sendData(minymaClient.loginUserName, 'zooland', 'now')
//            }
//            anchors.centerIn: parent

//        }
    }
    ZoolandControlServerFileDataManager{id: zcsfdm}
    ZoolLogView{id: log; width: (app.width-(app.width-app.fs*17))/2;height: xApp.height}
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(log.visible){
                log.visible=false
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Return'
        onActivated: app.enter()
    }
    Shortcut{
        sequence: 'Enter'
        onActivated: app.enter()
    }
    Shortcut{
        sequence: 'Left'
        onActivated: app.left()
    }
    Shortcut{
        sequence: 'Right'
        onActivated: app.right()
    }
    Shortcut{
        sequence: 'Up'
        onActivated: app.up()
    }
    Shortcut{
        sequence: 'Down'
        onActivated: app.down()
    }
    Component.onCompleted: {
        //zoolFileManager.showSection('ZoolFileMaker')
    }

//    function enter(){
//        app.ci.enter()
//    }
//    function left(){
//        if(app.currentMando===0){
//            setTabIndex()
//            return
//        }

//        if(app.currentMando===1){
//            app.ci.left()
//            return
//        }
//    }
//    function right(){
//        app.ci.right()
//    }
//    function up(){
//        if(app.currentMando===0){
//            if(app.ticiCurrentIndex<app.tici.length-1){
//                app.ticiCurrentIndex++
//            }else{
//                app.ticiCurrentIndex=0
//            }
//            app.ci=app.tici[app.ticiCurrentIndex]
//            return
//        }

//        if(app.currentMando===1){
//            app.ci.up()
//            return
//        }

//    }
//    function down(){
//        app.ci.down()
//    }
//    property var tici: []
//    property int ticiCurrentIndex: -1
//    onTiciCurrentIndexChanged: setTabIndex()
//    function setTabIndex(){
//       if(app.ticiCurrentIndex===0){
//            app.tici=zoolFileManager.getSection('ZoolMaker').getTicis()
//       }
//    }

}
