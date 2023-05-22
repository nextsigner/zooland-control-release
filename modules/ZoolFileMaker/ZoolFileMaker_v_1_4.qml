import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import ZoolControlsTime 1.0
import ZoolTextInput 1.0
//import "../../comps" as Comps
//import "../../js/Funcs.js" as JS

import ZoolText 1.0
import ZoolButton 1.2

import ZoolMando 1.0

Rectangle {
    id: r
    width: xApp.width-app.fs*17
    height: xApp.height//zsm.getPanel('ZoolFileManager').hp
    visible: true
    color: apps.backgroundColor
    border.width: 2
    border.color: apps.fontColor
    anchors.horizontalCenter: parent.horizontalCenter
    property real lat:-100.00
    property real lon:-100.00
    property int alt:0

    property real ulat:-100.00
    property real ulon:-100.00

    property string uFileNameLoaded: ''
    onVisibleChanged: {
        //if(visible)zoolVoicePlayer.stop()
        //if(visible)zoolVoicePlayer.speak('Sección para crear archivos.', true)
    }
    Settings{
        id: settings
        fileName: 'zoolFileMaker.cfg'
        property bool showModuleVersion: false
        property bool inputCoords: false
    }
    Flickable{
        id: flk
        width: r.width
        height: r.height
        contentWidth: r.width
        contentHeight: col.height+app.fs*3
        clip: true
        anchors.horizontalCenter: parent.horizontalCenter
        Column{
            id: col
            spacing: app.fs*0.75
            anchors.horizontalCenter: parent.horizontalCenter
            Item{width: 1; height: app.fs*0.15}
            ZoolTextInput{
                id: tiNombre
                width: r.width-app.fs*0.5
                t.font.pixelSize: app.fs*0.65
                anchors.horizontalCenter: parent.horizontalCenter
                KeyNavigation.tab: controlTimeFecha
                t.maximumLength: 30
                borderColor:apps.fontColor
                borderRadius: app.fs*0.25
                padding: app.fs*0.25
                horizontalAlignment: TextInput.AlignLeft
                onEnterPressed: {
                    controlTimeFecha.focus=true
                    controlTimeFecha.cFocus=0
                }
                Text {
                    text: 'Nombre'
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top
                }
                Rectangle{
                    anchors.fill: parent
                    opacity: 0.65
                    visible: app.ci===parent
                }
            }
            Item{width: 1; height: app.fs*0.15}
            Row{
                spacing: app.fs*0.1
                anchors.horizontalCenter: parent.horizontalCenter
                ZoolControlsTime{
                    id: controlTimeFecha
                    gmt: 0
                    KeyNavigation.tab: tiCiudad.t
                    setAppTime: false
                    onCurrentDateChanged: {
                        //log.l('PanelVN CurrenDate: '+currentDate.toString())
                        //log.visible=true
                        //log.x=xApp.width*0.2
                    }
                    Text {
                        text: 'Fecha'
                        font.pixelSize: app.fs*0.5
                        color: 'white'
                        anchors.bottom: parent.top
                    }
                }
            }
            Item{width: 1; height: app.fs*0.15}
            ZoolTextInput{
                id: tiCiudad
                width: tiNombre.width
                t.font.pixelSize: app.fs*0.65;
                KeyNavigation.tab: settings.inputCoords?tiLat.t:(botCrear.visible&&botCrear.opacity===1.0?botCrear:botClear)
                t.maximumLength: 50
                borderColor:apps.fontColor
                borderRadius: app.fs*0.25
                padding: app.fs*0.25
                horizontalAlignment: TextInput.AlignLeft
                onTextChanged: {
                    tSearch.restart()
                    t.color='white'
                }
                Text {
                    text: 'Lugar, ciudad, provincia,\nregión y/o país de nacimiento'
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    anchors.bottom: parent.top
                }
                Timer{
                    id: tSearch
                    running: false
                    repeat: false
                    interval: 2000
                    onTriggered: {
                        getZoolandCoords(parent.t.text)
                    }
                }
            }
            Row{
                spacing: app.fs*0.5
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: 'Ingresar coordenadas\nmanualmente'
                    font.pixelSize: app.fs*0.5
                    color: apps.fontColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                CheckBox{
                    checked: settings.inputCoords
                    anchors.verticalCenter: parent.verticalCenter
                    onCheckedChanged: settings.inputCoords=checked
                }
            }
            Column{
                id: colTiLonLat
                anchors.horizontalCenter: parent.horizontalCenter
                visible: settings.inputCoords

                Row{
                    spacing: app.fs
                    anchors.horizontalCenter: parent.horizontalCenter
                    ZoolTextInput{
                        id: tiLat
                        //width: r.width*0.5-app.fs*0.5
                        //width: r.width*0.15-app.fs*0.5
                        w: r.width*0.4-app.fs*0.5
                        t.font.pixelSize: app.fs*0.65
                        anchors.verticalCenter: parent.verticalCenter
                        KeyNavigation.tab: tiLon.t
                        t.maximumLength: 10
                        t.validator: RegExpValidator {
                            regExp: RegExp(/^(\+|\-)?0*(?:(?!999\.9\d*$)\d{0,3}(?:\.\d*)?|999\.0*)$/)
                        }
                        borderColor:apps.fontColor
                        borderRadius: app.fs*0.25
                        padding: app.fs*0.25
                        horizontalAlignment: TextInput.AlignLeft
                        property bool valid: false
                        Timer{
                            running: r.visible && settings.inputCoords
                            repeat: true
                            interval: 100
                            onTriggered: {
                                parent.valid=parent.t.text===''?false:(parseFloat(parent.t.text)>=-180.00 && parseFloat(parent.t.text)<=180.00)
                                if(parent.valid){
                                    r.ulat=parseFloat(parent.t.text)
                                }else{
                                    r.ulat=-1
                                }
                            }
                        }
                        Rectangle{
                            width: parent.width+border.width*2
                            height: parent.height+border.width*2
                            anchors.centerIn: parent
                            color: 'transparent'
                            border.width: 4
                            border.color: 'red'
                            visible: parent.t.text===''?false:!parent.valid
                        }
                        onEnterPressed: {
                            //controlTimeFecha.focus=true
                            //controlTimeFecha.cFocus=0
                        }
                        Text {
                            text: 'Latitud'
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            //anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                        }
                    }
                    ZoolTextInput{
                        id: tiLon
                        //width: r.width*0.15-app.fs*0.5
                        w: r.width*0.4-app.fs*0.5
                        t.font.pixelSize: app.fs*0.65
                        anchors.verticalCenter: parent.verticalCenter
                        KeyNavigation.tab: botCrear.visible&&botCrear.opacity===1.0?botCrear:botClear
                        t.maximumLength: 10
                        t.validator: RegExpValidator {
                            regExp: RegExp(/^(\+|\-)?0*(?:(?!999\.9\d*$)\d{0,3}(?:\.\d*)?|999\.0*)$/)
                        }
                        borderColor:apps.fontColor
                        borderRadius: app.fs*0.25
                        padding: app.fs*0.25
                        horizontalAlignment: TextInput.AlignLeft
                        property bool valid: false
                        Timer{
                            running: r.visible && settings.inputCoords
                            repeat: true
                            interval: 100
                            onTriggered: {
                                parent.valid=parent.t.text===''?false:(parseFloat(parent.t.text)>=-180.00 && parseFloat(parent.t.text)<=180.00)
                                if(parent.valid){
                                    r.ulon=parseFloat(parent.t.text)
                                }else{
                                    r.ulon=-1
                                }
                            }
                        }
                        Rectangle{
                            width: parent.width+border.width*2
                            height: parent.height+border.width*2
                            anchors.centerIn: parent
                            color: 'transparent'
                            border.width: 4
                            border.color: 'red'
                            visible: parent.t.text===''?false:!parent.valid
                        }
                        //onPressed: {
                        onEnterPressed: {
                            //controlTimeFecha.focus=true
                            //controlTimeFecha.cFocus=0
                        }
                        Text {
                            text: 'Longitud'
                            font.pixelSize: app.fs*0.5
                            color: 'white'
                            //anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.top
                        }
                    }
                }
                Item{width: 1; height: app.fs*0.5;visible: settings.inputCoords}
                Text{
                    text: tiLat.t.text===''&&tiLon.t.text===''?'Escribir las coordenadas geográficas.':
                                                                (
                                                                    tiLat.valid && tiLon.valid?
                                                                        'Estas coordenadas son válidas.':
                                                                        'Las coordenadas no son correctas'
                                                                    )
                    font.pixelSize: app.fs*0.5
                    color: apps.fontColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: settings.inputCoords
                }
            }
            Column{
                id: colLatLon
                anchors.horizontalCenter: parent.horizontalCenter
                visible: r.lat===r.ulat&&r.lon===r.ulon
                //height: !visible?0:app.fs*3
                Text{
                    text: 'Lat:'+r.lat
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.lat!==-100.00?1.0:0.0
                }
                Text{
                    text: 'Lon:'+r.lon
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.lon!==-100.00?1.0:0.0
                }
            }
            Column{
                visible: !colLatLon.visible
                //height: !visible?0:app.fs*3
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: 'Error: Corregir el nombre de ubicación'
                    font.pixelSize: app.fs*0.25
                    color: 'white'
                    visible: r.ulat===-1&&r.ulon===-1
                }
                Text{
                    text: 'Lat:'+r.ulat
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.ulat!==-100.00?1.0:0.0
                }
                Text{
                    text: 'Lon:'+r.ulon
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    opacity: r.ulon!==-100.00?1.0:0.0
                }
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: app.fs*0.25
                ZoolText{
                    text: 'Compartir con la\ncomunidad Zool'
                    fs: app.fs*0.5
                    textFormat:Text.Normal
                    anchors.verticalCenter: parent.verticalCenter
                }
                CheckBox{
                    id: cbShared
                    checked: false
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: app.fs*0.25
                Button{
                    id: botClear
                    text: 'Limpiar'
                    font.pixelSize: app.fs*0.5
                    opacity:  r.lat!==-100.00||r.lon!==-100.00||tiNombre.text!==''||tiCiudad.text!==''?1.0:0.0
                    enabled: opacity===1.0
                    onClicked: {
                        clear()
                    }
                }
                Button{
                    id: botCrear
                    text: 'Crear'
                    font.pixelSize: app.fs*0.5
                    KeyNavigation.tab: tiNombre.t
                    visible: r.ulat!==-1&&r.ulon!==-1&&tiNombre.text!==''&&tiCiudad.text!==''
                    onClicked: {
                        if(!settings.inputCoords){
                            searchGeoLoc(true)
                        }else{
                            r.lat=parseFloat(tiLat.t.text)
                            r.lon=parseFloat(tiLon.t.text)
                            r.ulat=r.lat
                            r.ulon=r.lon
                            setNewJsonFileData()
                        }
                    }
                    Timer{
                        running: r.state==='show'
                        repeat: true
                        interval: 1000
                        onTriggered: {
                            let nom=tiNombre.t.text.replace(/ /g, '_')
                            let fileName=apps.jsonsFolder+'/'+nom+'.json'
                            if(unik.fileExist(fileName)){
                                r.uFileNameLoaded=tiNombre.text
                                let jsonFileData=unik.getFile(fileName)
                                let j=JSON.parse(jsonFileData)
                                let dia=''+j.params.d
                                if(parseInt(dia)<=9){
                                    dia='0'+dia
                                }
                                let mes=''+j.params.m
                                if(parseInt(mes)<=9){
                                    mes='0'+mes
                                }
                                let hora=''+j.params.h
                                if(parseInt(hora)<=9){
                                    hora='0'+hora
                                }
                                let minuto=''+j.params.min
                                if(parseInt(minuto)<=9){
                                    minuto='0'+minuto
                                }
                                let nt=new Date(parseInt(j.params.a), parseInt(mes - 1), parseInt(dia), parseInt(hora), parseInt(minuto))
                                controlTimeFecha.currentDate=nt
                                controlTimeFecha.gmt=j.params.gmt
                                if(tiCiudad.text.replace(/ /g, '')===''){
                                    tiCiudad.text=j.params.ciudad
                                }
                                r.lat=j.params.lat
                                r.lon=j.params.lon
                                r.ulat=j.params.lat
                                r.ulon=j.params.lon
                                let vd=parseInt(tiFecha1.t.text)
                                let vm=parseInt(tiFecha2.t.text)
                                let vh=parseInt(tiHora1.t.text)
                                let vmin=parseInt(tiHora2.t.text)
                                let vgmt=controlTimeFecha.gmt//tiGMT.t.text
                                let vCiudad=tiCiudad.t.text.replace(/_/g, ' ')
                                if(j.params.d!==vd||j.params.m!==vm||j.params.a!==va||j.params.h!==vh||j.params.min!==vmin||r.lat!==r.ulat||r.lon!==r.ulon){
                                    botCrear.text='Modificar'
                                }else{
                                    botCrear.text='[Crear]'
                                }
                            }else{
                                botCrear.text='Crear'
                            }
                        }
                    }
                }
            }
        }
    }
    Item{
        width: r.parent.width
        height: 1
        anchors.centerIn: parent
        ZoolMando{
            id: zoolMando1
            width: app.fs*8
            height: width
            num:1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            onLeft:{
                runLeft(num)
            }
            onRight:{
                runRight(num)
            }
            onUp:{
                app.up()
            }
            onDown:{
                runDown(num)
            }
            onEnter:{
                runEnter(num)
            }
        }
        ZoolMando{
            id: zoolMando2
            width: app.fs*8
            height: width
            num:2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            onLeft:{
                runLeft(num)
            }
            onRight:{
                runRight(num)
            }
            onUp:{
                app.up()
            }
            onDown:{
                runDown(num)
            }
            onEnter:{
                runEnter(num)
            }
        }
    }

    //--> Get Data  Coords
    QtObject{
        id: setZoolandCoords
        function setData(data, isData){
            if(app.dev){
                //log.lv('setZoolandParamsList:\n'+JSON.stringify(JSON.parse(data), null, 2))
                //console.log('setZoolandParamsList data: '+data)
            }
            if(isData){
                let j=JSON.parse(data)
                log.lv('setZoolandCoords(): '+JSON.stringify(j))
                //zsm.getPanel('ZoolRemoteParamsList').load(j)
            }else{
                log.lv('setZoolandCoords(): No hay data! host: '+zcsfdm.host)
            }
        }
    }
    function getZoolandCoords(ciudad){
        let msReq=new Date(Date.now()).getTime()
        //let url=apps.host
        let url=zcsfdm.host
        url+='/zool/getZoolandCoords'
        url+='?ciudad='+ciudad+'&r='+msReq
        app.j.getRD(url, setZoolandCoords)
    }
    //<-- Get Data Coords

    function searchGeoLoc(crear){
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='            console.log(logData)\n'
        c+='        let result=(\'\'+logData).replace(/\\n/g, \'\')\n'
        c+='        let json=JSON.parse(result)\n'
        c+='        if(json){\n'
        //c+='            console.log(JSON.stringify(json))\n'

        c+='                if(r.lat===-1&&r.lon===-1){\n'
        c+='                   tiCiudad.t.color="red"\n'
        c+='                }else{\n'
        c+='                   tiCiudad.t.color=apps.fontColor\n'
        if(crear){
            c+='                r.lat=json.coords.lat\n'
            c+='                r.lon=json.coords.lon\n'
            c+='                    setNewJsonFileData()\n'
            c+='                    r.state=\'hide\'\n'
        }else{
            c+='                r.ulat=json.coords.lat\n'
            c+='                r.ulon=json.coords.lon\n'
            //c+='                    setNewJsonFileData()\n'
            //c+='                if(tiGMT.t.text===""){\n'
            //c+='                    tiGMT.t.text=parseFloat(r.ulat / 10).toFixed(1)\n'
            //c+='                }\n'
        }
        c+='                }\n'
        c+='        }else{\n'
        c+='            console.log(\'No se encontraron las cordenadas.\')\n'
        c+='        }\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        console.log(\''+app.pythonLocation+' '+app.mainLocation+'/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\''+app.pythonLocation+' "'+unik.currentFolderPath()+'/py/geoloc.py" "'+tiCiudad.t.text+'" "'+unik.currentFolderPath()+'"\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodenewvn')
    }
    function setNewJsonFileData(){

        let vtipo='vn' //Esto luego lo programaré para EVENTOS tipo='even'

        let d = new Date(Date.now())
        let ms=d.getTime()
        let nom=tiNombre.t.text.replace(/ /g, '_')

        let vd=controlTimeFecha.dia
        let vm=controlTimeFecha.mes
        let va=controlTimeFecha.anio
        let vh=controlTimeFecha.hora
        let vmin=controlTimeFecha.minuto

        let vgmt=controlTimeFecha.gmt//tiGMT.t.text
        let vlon=r.lon
        let vlat=r.lat
        let valt=r.alt
        let vCiudad=tiCiudad.t.text.replace(/_/g, ' ')

        let vhsys=apps.currentHsys

        let extId='id'
        extId+='_'+vd
        extId+='_'+vm
        extId+='_'+va
        extId+='_'+vh
        extId+='_'+vmin
        extId+='_'+vgmt
        extId+='_'+vlat
        extId+='_'+vlon
        extId+='_'+valt
        extId+='_'+vtipo
        extId+='_'+vhsys

        let j='{'
        j+='"params":{'
        j+='"tipo":"'+vtipo+'",'
        j+='"ms":'+ms+','
        j+='"n":"'+nom+'",'
        j+='"d":'+vd+','
        j+='"m":'+vm+','
        j+='"a":'+va+','
        j+='"h":'+vh+','
        j+='"min":'+vmin+','
        j+='"gmt":'+vgmt+','
        j+='"lat":'+vlat+','
        j+='"lon":'+vlon+','
        j+='"alt":'+valt+','
        j+='"ciudad":"'+vCiudad+'",'
        j+='"hsys":"'+vhsys+'",'
        if(apps.enableShareInServer && cbShared.checked){
            j+='"shared":true,'
        }else{
            j+='"shared":false,'
        }
        j+='"extId":"'+extId+'"'
        j+='},'
        j+='"exts":[]'
        j+='}'

        let json=JSON.parse(j)
        if(zfdm.mkFileAndLoad(json)){
            if(app.dev)log.lv('Archivo creado: '+json.params.n)
        }else{
            if(app.dev)log.lv('Archivo NO creado: '+json.params.n)
        }
    }
    //    function enter(){
    //        if(botCrear.focus&&tiNombre.text!==''&&tiFecha1.text!==''&&tiFecha2.text!==''&&tiFecha3.text!==''&&tiHora1.text!==''&&tiHora2.text!==''&&tiGMT.text!==''&&tiCiudad.text!==''){
    //            searchGeoLoc(true)
    //        }
    //    }
    function clear(){
        r.ulat=-100
        r.ulon=-100
        tiNombre.t.text=''
        tiFecha1.t.text=''
        tiFecha2.t.text=''
        tiFecha3.t.text=''
        //tiHora1.t.text=''
        tiHora2.t.text=''
        tiCiudad.t.text=''
        tiGMT.t.text=''
    }
    function toRight(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toRight()
        }
    }
    function toLeft(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toLeft()
        }
    }
    function toUp(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toUp()
        }
    }
    function toDown(){
        if(controlTimeFecha.focus){
            controlTimeFecha.toDown()
        }
    }
    function setInitFocus(){
        tiNombre.t.selectAll()
        tiNombre.t.focus=true
    }

    function getTicis(){
        let a=[]
        a.push(tiNombre)
        a.push(tiCiudad)
        return a
    }

    function runEnter(num){
        //app.ci.enter()
    }
    function runLeft(num){



    }
    function runRight(num){
        if(num===1){
            if(tiNombre.t.focus){
                controlTimeFecha.focus=true
                return
            }
            if(controlTimeFecha.focus){
                tiCiudad.t.focus=true
                return
            }
            if(tiCiudad.t.focus){
                tiNombre.t.focus=true
                return
            }
            tiNombre.t.focus=true
            return
        }
    }
    function runUp(num){
        if(app.currentMando===0){

            return
        }

        if(app.currentMando===1){
            ////app.ci.up()
            return
        }

    }
    function runDown(num){
        //app.ci.down()
    }
    //    property var tici: []
    //    property int ticiCurrentIndex: -1
    //    onTiciCurrentIndexChanged: setTabIndex()
    //    function setTabIndex(){
    //       if(app.ticiCurrentIndex===0){
    //            app.tici=zoolFileManager.getSection('ZoolMaker').getTicis()
    //       }
    //    }
}
