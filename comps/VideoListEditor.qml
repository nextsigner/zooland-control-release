import QtQuick 2.0
import QtQuick.Controls 2.0
import QtMultimedia 5.12
import QtQuick.Dialogs 1.2

Rectangle {
    id: r
    width: xApp.width*0.8
    height: xApp.height
    color: 'black'
    anchors.right: parent.right
    visible: false
    Column{
        Rectangle{
            id: xFilesData
            width: r.width
            height: col.height+app.fs
            color: 'black'
            border.width: 2
            border.color: 'white'
            Column{
                id: col
                spacing: app.fs*0.5
                anchors.centerIn: parent
                Row{
                    spacing: app.fs*0.5
                    Text{
                        id: label1
                        text:'<b>Archivo:</b>'
                        color: 'white'
                        font.pixelSize: app.fs*0.5
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    TextField{
                        id: tfArchivo
                        text: panelVideLectura.currentUrl
                        width: xFilesData.width-label1.width-botExaminar.width-app.fs*1.5
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Button{
                        id: botExaminar
                        text: 'Examinar'
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: fileDialogJson.open()
                    }
                }
                Row{
                    spacing: app.fs*0.5
                    Text{
                        id: label2
                        text:'<b>Carpeta:</b>'
                        color: 'white'
                        font.pixelSize: app.fs*0.5
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    TextField{
                        id: tfCarpeta
                        text: apps.repLectCurrentFolder
                        width: xFilesData.width-label2.width-botExaminarFolder.width-app.fs*1.5
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Button{
                        id: botExaminarFolder
                        text: 'Examinar'
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: fileDialogFolder.open()
                    }
                }
            }
        }
        ListView{
            id: lv
            width: r.width
            height: r.height-xFilesData.height
            model: lm
            delegate: comp
        }
    }
    ListModel{
        id: lm
        function addItem(fn, ip, im, isMax){
            return{
                fileName: fn,
                indexPlanet: ip,
                isMirror: im,
                isMaximized: isMax
            }
        }
    }
    Component{
        id: comp
        Rectangle{
            id: xItem
            width: lv.width-app.fs
            height: app.fs*6
            color: 'black'
            border.width: 1
            border.color: 'white'
            MediaPlayer{
                id: videoPlayer
                autoPlay: false
                source: fileName.indexOf('file://')<0?'file://'+fileName:fileName
            }
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: app.fs*0.5
                Rectangle{
                    width: app.fs*6
                    height: width*0.75
                    color: 'transparent'
                    border.width: 1
                    border.color: 'white'
                    anchors.verticalCenter: parent.verticalCenter
                    VideoOutput{
                        id: videoPlayerOutPut
                        source: videoPlayer
                        width: app.fs*6
                        height: width*0.75
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset: !isMirror?0:width
                        anchors.verticalCenter: parent.verticalCenter
                        transform: Scale{ xScale: isMirror?-1:1 }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(videoPlayer.playbackState===MediaPlayer.PlayingState){
                                videoPlayer.stop()
                            }else{
                                panelVideLectura.vp.pause()
                                videoPlayer.play()
                            }
                        }
                    }
                }
                Column{
                    spacing: app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    Row{
                        spacing: app.fs*0.25
                        Text{
                            text: '<b>Mostrar Cuerpo: </b>'+indexPlanet
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Row{
                            ButtonIcon{
                                text:'\uf0ab'
                                width: apps.botSize
                                height: width
                                onClicked: {
                                    setIndexPlanet(index, indexPlanet, false)
                                    indexPlanet-=1
                                }
                            }
                            ButtonIcon{
                                text:'\uf0aa'
                                width: apps.botSize
                                height: width
                                onClicked: {
                                    setIndexPlanet(index, indexPlanet, true)
                                    indexPlanet+=1
                                }
                            }
                        }
                        Item{width: app.fs*0.5;height: 1}
                        Text{
                            text: '<b>Volteado: </b>'+(isMirror?'SI':'NO')
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        ButtonIcon{
                            text:'\uf0ec'
                            width: apps.botSize
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                setMirror(index, isMirror)
                                isMirror=!isMirror
                                if(panelVideLectura.pl.currentIndex===index){
                                    panelVideLectura.vo.isMirror=isMirror
                                }
                            }
                        }
                        Item{width: app.fs*0.5;height: 1}
                        Text{
                            text: '<b>Eliminar</b>'
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        ButtonIcon{
                            text:'\uf00d'
                            width: apps.botSize
                            height: width
                            onClicked: {
                                deleteItem(index)
                            }
                        }
                        Item{width: app.fs*0.5;height: 1}
                    }
                    Row{
                        spacing: app.fs*0.5
                        Text{
                            text: '<b>Maximizar: </b>'+(!isMaximized?'SI':'NO')
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        ButtonIcon{
                            text:isMaximized?'\uf066':'\uf08e'
                            width: apps.botSize
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                setMaximized(index, isMaximized)
                                isMaximized=!isMaximized
                                if(panelVideLectura.pl.currentIndex===index){
                                    panelVideLectura.playMaximized=isMaximized
                                }
                            }
                        }
                        Text{
                            text: '<b>Subir/Bajar</b>'
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Row{
                            ButtonIcon{
                                text:'\uf0ab'
                                width: apps.botSize
                                height: width
                                visible: index!==lm.count-1
                                onClicked: {
                                    lm.move(index, index+1, 1)
                                    saveFileList()
                                }
                            }
                            ButtonIcon{
                                text:'\uf0aa'
                                width: apps.botSize
                                height: width
                                visible: index!==0
                                onClicked: {
                                    lm.move(index, index-1, 1)
                                    saveFileList()
                                }
                            }
                        }
                    }
                    Text{
                        id: txtData
                        text: fileName
                        font.pixelSize: app.fs*0.5
                        color: 'white'
                        width: xItem.width-videoPlayerOutPut.width-app.fs*3
                        wrapMode: Text.WrapAnywhere
                    }
                }

            }
        }
    }
    ButtonIcon{
        text:'+'
        width: apps.botSize*2
        height: width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs*0.5
        anchors.left: parent.left
        anchors.leftMargin: app.fs*0.5
        onClicked: {
            fileDialog.open()
        }
    }
    FileDialog {
        id: fileDialog
        title: "Seleccionar Videos"
        folder: apps.repLectCurrentFolder
        selectFolder: false
        nameFilters: ["*.mkv", "*.mp4"]
        selectMultiple: true
        onAccepted: {
            //console.log("You chose: " + fileDialog.fileUrls)
            let u=fileDialog.fileUrls
            //'Cargando Video '+u.toString(), 0, 500)
            for(var i=0;i<u.length;i++){
                addFileList(u[i])
                //log.ls('Video '+i+': '+u[i], 0, 500)
                //log.ls('json Video '+i+': '+addFileList(u[i]), 0, 500)
            }
            updateList()
        }
        onRejected: {
            console.log("Canceled")
        }
        //Component.onCompleted: visible = true
    }
    FileDialog {
        id: fileDialogJson
        title: "Seleccionar Archivo"
        folder: apps.jsonsFolder
        selectFolder: false
        nameFilters: ["*.json"]
        selectMultiple: false
        onAccepted: {
            //console.log("You chose: " + fileDialog.fileUrls)
            let u=fileDialogJson.fileUrls
            panelVideLectura.currentUrl=u[0].replace('file://', '')
            saveFileList()
        }
        onRejected: {
            console.log("Canceled")
        }
        //Component.onCompleted: visible = true
    }
    FileDialog {
        id: fileDialogFolder
        title: "Seleccionar Carpeta"
        folder: apps.repLectCurrentFolder
        selectFolder: true
        selectMultiple: false
        onAccepted: {
            let u=fileDialogFolder.fileUrls[0]
            apps.repLectCurrentFolder=""+u
            //panelVideLectura.updateVideoList()
            updateList()
        }
        onRejected: {
            console.log("Canceled")
        }
        //Component.onCompleted: visible = true
    }
    Component.onCompleted: {
        //updateList()
    }
    function setIndexPlanet(index, indexPlanet, sube){
        let jsonData=''
        let jsonFile=(''+apps.repLectCurrentFolder).replace('file://', '')+'/list.json'
        if(!unik.fileExist(jsonFile)){
            return
        }
        jsonData=unik.getFile(jsonFile)
        let json=JSON.parse(jsonData)
        json.items['item'+index].indexPlanet=sube?indexPlanet+1:indexPlanet-1
        panelVideLectura.uJson=json
        unik.setFile(jsonFile,JSON.stringify(json))
    }
    function setMirror(index, isMirror){
        let jsonData=''
        let jsonFile=(''+apps.repLectCurrentFolder).replace('file://', '')+'/list.json'
        if(!unik.fileExist(jsonFile)){
            return
        }
        jsonData=unik.getFile(jsonFile)
        let json=JSON.parse(jsonData)
        json.items['item'+index].isMirror=!isMirror
        panelVideLectura.uJson=json
        unik.setFile(jsonFile,JSON.stringify(json))
    }
    function setMaximized(index, isMaximized){
        let jsonData=''
        let jsonFile=(''+apps.repLectCurrentFolder).replace('file://', '')+'/list.json'
        if(!unik.fileExist(jsonFile)){
            return
        }
        jsonData=unik.getFile(jsonFile)
        let json=JSON.parse(jsonData)
        json.items['item'+index].isMaximized=!isMaximized
        panelVideLectura.uJson=json
        unik.setFile(jsonFile,JSON.stringify(json))
    }
    function addFileList(file){
        //log.ls('Cargando archivo de video '+file+'...', 0, 500)
        let jsonData=''
        let jsonFile=(''+apps.repLectCurrentFolder).replace('file://', '')+'/list.json'
        if(!unik.fileExist(jsonFile)){
            log.ls('Error! El archivo '+jsonFile+' no existe.', 0, 500)
            return
        }
        jsonData=unik.getFile(jsonFile)
        let json=JSON.parse(jsonData)
        let e=false
//        for(var i=0;i<Object.keys(json.items).length;i++){
//            if(json.items['item'+i]&&file===json.items['item'+i].fileName){
//                e=true
//                log.ls('El archivo '+file+' ya existe en el json!', 0, 500)
//                break
//            }

//        }
        if(!e){
            //log.ls('El archivo no existe en el json!', 0, 500)
            //log.ls('Nuevo item: '+'item'+parseInt(Object.keys(json).length), 300, 500)
            let obj={}

            obj.fileName=file
            obj.indexPlanet=-2
            obj.isMirror=false
            obj.isMaximized=false
            json.items['item'+parseInt(Object.keys(json.items).length)]=obj
            //log.ls('jsonFile add item: '+JSON.stringify(json), 300, 500)
            unik.setFile(jsonFile,JSON.stringify(json))
            panelVideLectura.updateVideoList()
        }
    }
    function deleteItem(index){
        let jsonData=''
        let jsonFile=(''+apps.repLectCurrentFolder).replace('file://', '')+'/list.json'
        if(!unik.fileExist(jsonFile)){
            return
        }
        jsonData=unik.getFile(jsonFile)
        let json=JSON.parse(jsonData)
        delete json.items['item'+index]
        let nJson={}
        nJson.items={}
        nJson.itemData=json.itemData
        for(var i=0;i<Object.keys(json.items).length;i++){
            let obj=json.items[Object.keys(json.items)[i]]
            nJson.items["item"+i]=obj
        }
        panelVideLectura.uJson=nJson
        unik.setFile(jsonFile,JSON.stringify(nJson))
        updateList()
        //panelVideLectura.updateVideoList()
    }
    function updateList(){
        r.visible=true
        lm.clear()
        let jsonData=''
        let jsonFile=(''+apps.repLectCurrentFolder).replace('file://', '')+'/list.json'
        //log.ls('jsonFile: '+jsonFile, 300, 500)
        if(!unik.fileExist(jsonFile)){
            jsonData='{"items": {"item0":{"fileName":"/home/ns/Documentos/gd/zool_videos/intro_vn.mkv", "indexPlanet": -1, "isMirror": false, "isMaximized": true},"item1":{"fileName":"/home/ns/Documentos/gd/zool_videos/close_vn.mkv", "indexPlanet": -1, "isMirror": false, "isMaximized": true}}, "itemData":{"file":""}}'
            unik.setFile(jsonFile,jsonData)

        }else{
            jsonData=unik.getFile(jsonFile)
        }
        //log.ls('\n\n\nUpdate json list: '+jsonData.replace(/,"/g, ', "'), 0, 500)
        let json=JSON.parse(jsonData)
        panelVideLectura.uJson=json
        for(var i=0;i<Object.keys(json.items).length;i++){
            //log.ls('jsonItem: '+json['item'+i].fileName, 300, 500)
            //log.ls('jsonItem: '+json['item'+i].indexPlanet, 300, 500)
            //log.ls('jsonItem: '+json['item'+i].isMirror, 300, 500)
            if(json.items['item'+i]){
                lm.append(lm.addItem(json.items['item'+i].fileName, json.items['item'+i].indexPlanet, json.items['item'+i].isMirror, json.items['item'+i].isMaximized))
            }
        }
        if(json['itemData']){
            panelVideLectura.currentUrl=json['itemData'].file
        }
        panelVideLectura.updateVideoList()
    }
    function saveFileList(){
        let json={}
        json.items={}
        for(var i=0;i<lm.count;i++){
            let obj=lm.get(i)
            json.items['item'+i]=obj
        }
        if(panelVideLectura.currentUrl!==''){
            let obj={}
            obj.file=panelVideLectura.currentUrl
            json['itemData']=obj
        }
        panelVideLectura.uJson=json
        let jsonFile=(''+apps.repLectCurrentFolder).replace('file://', '')+'/list.json'
        unik.setFile(jsonFile,JSON.stringify(json))
        panelVideLectura.uJson=json
        panelVideLectura.updateVideoList()
    }
}
