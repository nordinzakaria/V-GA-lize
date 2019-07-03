import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.2


import gaviz 1.0
import "../menu"
import "../../utils.js" as Utils

/* The Individual Frame appears when you click on a square in the Population Frames
    It contains :
       - Two Labels on the left displaying the Generation and Number of the selected individual
       - A SwipeView containing two pages :
           - the first displays the individual and its parents (only if not from generation 0)
           - the second displays the individual's value and an animated circle :
               The colour has the same meaning than before (from red if over minimum, to blue if very close)
               The circle is complete depending on how far over the minimum the value is
       - A Frame displaying :
           - The different values of the individual depending on the objective functions,
           - Their Rank in the generation
*/
Frame {
    id: individualView

    Layout.fillWidth: true
    Layout.preferredHeight: 0.5 * parent.height

    property int selectedFitness: 0

    property int selectedPopulation: 0
    property int selectedGeneration: 0
    property int selectedIndividual: 0

    property double individualFitness: 0
    property int individualRank: 0

    property int parent1Index: -1
    property int parent2Index: -1
    property int parent1Rank: 0
    property int parent2Rank: 0
    property double parent1Fitness: 0
    property double parent2Fitness: 0

    property var mycanvas: individualcharacteristic.mycanvas
    property var swipeV: swipeView
    property var leftB: buttonLeft
    property var rightB: buttonRight

    property double minScore: 0

    signal individualChanged(int population, int generation, int individual);

    onSelectedIndividualChanged :
    {
        individualFitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, selectedFitness, IndividualProperty.Fitness)
        individualRank    = selectedIndividual;

        if (selectedGeneration > 0) {
            parent1Index = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, selectedFitness, IndividualProperty.Parent1)
            parent2Index = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, selectedFitness, IndividualProperty.Parent2)

            parent1Fitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration-1, 0, parent1Index, selectedFitness, IndividualProperty.Fitness)
            parent2Fitness = gaviz.getIndividualProperty(selectedPopulation, selectedGeneration-1, 0, parent2Index, selectedFitness, IndividualProperty.Fitness)

            parent1Rank = parent1Index
            parent2Rank = parent2Index
        }

        mycanvas.animationProgress = 0;
    }

    ColumnLayout {
        id: individualViewTopColumn
        anchors.fill: parent

        RowLayout{
            Layout.topMargin: -7
            Frame {
                id: viewTitle
                Label {
                    text: qsTr("INDIVIDUAL VIEW")
                    font.pixelSize: 24
                }
            }

            Item{
                Layout.fillWidth: true
            }

            MenuButton{
                id : exitIndividual
                trueIcon.source: "../../images/icons/image_part_004.png"

                onClicked: individualView.visible = false
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Close Individual View")
            }
        }

        VerticalSeparator{
            Layout.fillWidth: true
            Layout.leftMargin: -11
            Layout.rightMargin: -11
        }

        RowLayout {
            id: rowBelowTitle
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: genIndIndex
                Layout.preferredWidth: viewTitle.width

                Label {
                    text: qsTr("Generation %1").arg(selectedGeneration)
                    font.pixelSize: 24
                }
                Label {
                    text: qsTr("Individual %1").arg(selectedIndividual)
                    font.pixelSize: 24
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            ColumnLayout {
                id: indViewMain
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Button {
                        id: buttonLeft
                        Layout.preferredWidth: 50
                        Layout.fillHeight: true
                        visible: false

                        text: "<"

                        onClicked: {
                            swipeView.currentIndex--
                            visible = false
                            buttonRight.visible = true
                        }
                    }

                    Frame {
                        id: swipeframe
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        SwipeView {
                            id: swipeView
                            anchors.fill: parent
                            clip: true

                            currentIndex: 0

                            Item {
                                id: genealogyPage

                                Column {
                                    id: column /* outer column */
                                    anchors.fill: parent

                                    spacing: 10
                                    Text {
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: qsTr("Parents")
                                        visible: parent1Index > -1
                                    }
                                    Row { /* inner row */
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10

                                        Rectangle {
                                            id: coloredParent1
                                            visible: parent1Index > (-1)

                                            width: swipeframe.width / 4; height: swipeframe.height / 4
                                            color: {
                                                var minScore = individualView.minScore;

                                                var population = individualView.selectedPopulation;
                                                var generation = individualView.selectedGeneration-1;
                                                var cluster = 0;
                                                var individual = parent1Index;
                                                var fitness = individualView.selectedFitness;
                                                var score = gaviz.getIndividualProperty(population, generation, cluster, individual, fitness, IndividualProperty.Fitness)

                                                var maxScore = minScore+5

                                                return Utils.getFillStyle(minScore,score,maxScore);
                                            }

                                            property int numgenes: (parent1Index != -1) ? gaviz.getIndividualProperty(selectedPopulation,
                                                                                                                      selectedGeneration-1, 0,
                                                                                                                      parent1Index,
                                                                                                                      selectedFitness, IndividualProperty.NumGenes) : 0
                                            property real gwidth : (numgenes > 0) ? width * 0.9 / numgenes : 0

                                            Row {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.verticalCenter: parent.verticalCenter
                                                Repeater {
                                                    id: genesrect1
                                                    model: coloredParent1.numgenes
                                                    Rectangle {
                                                        width: coloredParent1.gwidth
                                                        height: coloredParent1.height * 0.9
                                                        color:{
                                                            var generation = individualView.selectedGeneration-1;
                                                            var cluster = 0;
                                                            var individual = individualView.parent1Index;


                                                            return Utils.getGeneStyle(generation, cluster,individual, index)
                                                        }
                                                    }
                                                }
                                            }

                                            MouseArea {
                                                visible: parent1Index > (-1)
                                                anchors.fill: coloredParent1
                                                acceptedButtons: Qt.LeftButton
                                                cursorShape: Qt.PointingHandCursor

                                                onClicked: {
                                                    var parentPopulation = individualView.selectedPopulation
                                                    var parentGeneration = individualView.selectedGeneration - 1;
                                                    var parentIndex = individualView.parent1Index;

                                                    individualView.individualChanged(parentPopulation,parentGeneration,parentIndex)
                                                }
                                            }

                                        }

                                        Rectangle {
                                            id: coloredParent2
                                            visible: parent2Index > (-1)

                                            width: swipeframe.width / 4; height: swipeframe.height / 4
                                            color:{
                                                var minScore = individualView.minScore;

                                                var population = individualView.selectedPopulation;
                                                var generation = individualView.selectedGeneration-1;
                                                var cluster = 0;
                                                var individual = parent2Index;
                                                var fitness = individualView.selectedFitness;
                                                var score = gaviz.getIndividualProperty(population, generation, cluster, individual, fitness, IndividualProperty.Fitness)

                                                var maxScore = minScore+5

                                                return Utils.getFillStyle(minScore,score,maxScore);
                                            }

                                            property int numgenes: (parent2Index != -1) ? gaviz.getIndividualProperty(selectedPopulation,
                                                                                                                      selectedGeneration-1, 0,
                                                                                                                      parent2Index,
                                                                                                                      selectedFitness, IndividualProperty.NumGenes) : 0
                                            property real gwidth : (numgenes > 0) ? width * 0.9 / numgenes : 0

                                            Row {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.verticalCenter: parent.verticalCenter
                                                Repeater {
                                                    id: genesrect2
                                                    model: coloredParent2.numgenes
                                                    Rectangle {
                                                        width: coloredParent2.gwidth
                                                        height: coloredParent2.height * 0.9
                                                        color:{
                                                            var generation = individualView.selectedGeneration-1;
                                                            var cluster = 0;
                                                            var individual = individualView.parent2Index;


                                                            return Utils.getGeneStyle(generation, cluster,individual, index)
                                                        }
                                                    }
                                                }
                                            }

                                            MouseArea {
                                                visible: parent2Index > (-1)
                                                anchors.fill: coloredParent2
                                                acceptedButtons: Qt.LeftButton
                                                cursorShape: Qt.PointingHandCursor

                                                onClicked: {

                                                    var parentPopulation = individualView.selectedPopulation
                                                    var parentGeneration = individualView.selectedGeneration - 1;
                                                    var parentIndex = individualView.parent2Index;

                                                    individualView.individualChanged(parentPopulation,parentGeneration,parentIndex)
                                                }
                                            }

                                        }

                                    }

                                    Text {
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: qsTr("Individual")
                                    }
                                    Rectangle {
                                        id: coloredInd
                                        width: swipeframe.width / 4;
                                        height: swipeframe.height / 4

                                        color: {
                                            var minScore = individualView.minScore;

                                            var population = individualView.selectedPopulation;
                                            var generation = individualView.selectedGeneration;
                                            var cluster = 0;
                                            var individual = individualView.selectedIndividual;
                                            var fitness = individualView.selectedFitness;
                                            var score = gaviz.getIndividualProperty(population, generation, cluster, individual, fitness, IndividualProperty.Fitness)

                                            var maxScore = minScore+5

                                            return Utils.getFillStyle(minScore,score,maxScore);
                                        }
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        property int numgenes: gaviz.getIndividualProperty(selectedPopulation,
                                                                                           selectedGeneration, 0,
                                                                                           selectedIndividual,
                                                                                           selectedFitness, IndividualProperty.NumGenes)
                                        property real gwidth : (numgenes > 0) ? width * 0.9 / numgenes : 0

                                        Row {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.verticalCenter: parent.verticalCenter
                                            Repeater {
                                                id: genesrectInd
                                                model: coloredInd.numgenes
                                                Rectangle {
                                                    width: coloredInd.gwidth
                                                    height: coloredInd.height * 0.9
                                                    color:{
                                                        var generation = individualView.selectedGeneration;
                                                        var cluster = 0;
                                                        var individual = individualView.selectedIndividual;


                                                        return Utils.getGeneStyle(generation, cluster,individual, index)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            /*
                            Item {
                                id: scoresPage

                                Label {
                                    text: "Scores view"
                                }

                                Canvas {
                                    id: mycanvas
                                    anchors.centerIn: parent
                                    anchors.leftMargin: 0.5 * parent.width
                                    width: parent.width
                                    height: parent.height

                                    // animation based on the value of this
                                    property real animationProgress: 0

                                    states: State {
                                        when: (buttonRight.visible === false || buttonLeft.visible === true)
                                        PropertyChanges { animationProgress: 1; target: mycanvas }
                                    }
                                    transitions: Transition {
                                        NumberAnimation {
                                            property: "animationProgress"
                                            easing.type: Easing.OutExpo
                                            duration: 4000
                                        }
                                    }

                                    onAnimationProgressChanged: requestPaint()

                                    onPaint: {
                                        var radius = 0.4*parent.height;
                                        var lineWidth = 0.1*radius;
                                        var ctx = getContext("2d");
                                        ctx.reset();
                                        // Resets the current path to a new path.
                                        ctx.beginPath();
                                        ctx.lineWidth= lineWidth;
                                        ctx.strokeStyle = populationView.getFillStyle(selectedGeneration, 0, selectedIndividual, selectedFitness)
                                        // object arc(real x, real y, real radius, real startAngle, real endAngle, bool anticlockwise)
                                        var min=minScore
                                        if(minScore === 0)
                                            ctx.arc(width/2, height/2, radius, 1.5*Math.PI, 1.5*Math.PI-2*Math.PI*animationProgress*((individualFitness)-0.2), true);
                                        else
                                            ctx.arc(width/2, height/2, radius, 1.5*Math.PI, 1.5*Math.PI-2*Math.PI*animationProgress*((individualFitness/minScore)-0.2), true);
                                        // Strokes the subpaths with the current stroke style.
                                        ctx.stroke();
                                    }
                                }

                                ColumnLayout {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.horizontalCenter
                                    anchors.rightMargin: mycanvas.width * 0.01

                                    Repeater
                                    {
                                        model: gaviz.getNbObjectiveFunctions()

                                        RowLayout {
                                            Label {
                                                text: "Fitness: "+gaviz.getObjectiveFunction(index)
                                            }
                                            Item {
                                                Layout.fillWidth: true
                                            }
                                            Label {
                                                text: gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, index, IndividualProperty.Fitness)
                                            }
                                        }
                                    }

                                }
                            }
*/

                            Individualcharacteristic{
                                id: individualcharacteristic

                                parent1 : individualView.parent1Index
                                parent2 : individualView.parent2Index

                                selectedFitness: individualView.selectedFitness

                                selectedIndividual: individualView.selectedIndividual
                                selectedGeneration: individualView.selectedGeneration
                                selectedPopulation: individualView.selectedPopulation

                                mNumberFunctions: gaviz.getNbObjectiveFunctions()
                                mFunctions: gaviz.getObjectiveFunctions()
                            }

                            MouseArea {
                                anchors.fill: parent.currentItem
                                onPressAndHold: { swipeDialog.open() }
                            }

                            FileDialog {
                                id: swipeDialog
                                title: qsTr("Please choose a file")
                                folder: shortcuts.home
                                modality: Qt.NonModal
                                selectExisting : false
                                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                                onAccepted: {
                                    swipeframe.grabToImage(function(result) {
                                        var localfile = gaviz.getLocalFile(swipeDialog.fileUrl)
                                        console.log('saving to '+localfile)
                                        result.saveToFile(localfile);
                                    });
                                }
                            }
                        }

                    }

                    Button {
                        id: buttonRight
                        Layout.preferredWidth: 50
                        Layout.fillHeight: true
                        visible: true

                        text: ">"

                        onClicked: {
                            swipeView.currentIndex++
                            visible = false
                            buttonLeft.visible = true
                        }
                    }

                }

            }

            Frame {
                id: lastBox
                Layout.fillHeight: true
                Layout.preferredWidth: 0.3*parent.width

                clip: true
                ColumnLayout{
                    anchors.fill: parent
                    Layout.fillHeight: true
                    Layout.fillWidth:  true

                    Label {
                        text: qsTr("Individual Statistics")
                        font.pixelSize: 24
                    }

                    Repeater {
                        id: rep1
                        model: gaviz.getNbObjectiveFunctions()
                        Label {
                            //property int ng: gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, index, IndividualProperty.NumGenes)
                            text: "Fitness " + index +": "+
                                  gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, index, IndividualProperty.Fitness)
                                  + '\n' + "Rank: " + selectedIndividual + '\n' + "Genes : " + coloredInd.numgenes
                        }
                    }

                    Label {
                        text: ""
                    }

                    // add popup window for gene
                    Button{
                        id : inspector
                        text: qsTr("See Genes")

                        onClicked: {
                            //TODO
                            if(menuBar.params.tsp === Qt.Unchecked)
                                dialog.open()
                            else
                                tspDialog.open()
                        }

                        Dialog {
                            id: dialog
                            title: qsTr("Genes Inspector")
                            visible: false

                            anchors.centerIn: Overlay.overlay
                            width: 800
                            height: 600
                            modal : false

                            standardButtons: Dialog.Ok

                            contentItem: ColumnLayout {
                                Frame{
                                    Layout.preferredHeight: 0.3*parent.height
                                    Layout.preferredWidth: parent.width

                                    Column { /* inner column */
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10

                                        Text {
                                            color: "white"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: qsTr("Individual")
                                        }

                                        Rectangle {
                                            id: coloredIndBis
                                            width: swipeframe.width / 4; height: swipeframe.height / 4

                                            color: {
                                                var minScore = individualView.minScore;

                                                var population = individualView.selectedPopulation;
                                                var generation = individualView.selectedGeneration;
                                                var cluster = 0;
                                                var individual = individualView.selectedIndividual;
                                                var fitness = individualView.selectedFitness;
                                                var score = gaviz.getIndividualProperty(population, generation, cluster, individual, fitness, IndividualProperty.Fitness)

                                                var maxScore = minScore+5

                                                return Utils.getFillStyle(minScore,score,maxScore);
                                            }
                                            property int numgenes: gaviz.getIndividualProperty(selectedPopulation,
                                                                                               selectedGeneration, 0,
                                                                                               selectedIndividual,
                                                                                               selectedFitness, IndividualProperty.NumGenes)
                                            property real gwidth : (numgenes > 0) ? width * 0.9 / numgenes : 0

                                            Row {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                anchors.verticalCenter: parent.verticalCenter
                                                Repeater {
                                                    id: genesrectIndBis
                                                    model: coloredInd.numgenes
                                                    Rectangle {
                                                        width: coloredInd.gwidth
                                                        height: coloredInd.height * 0.9
                                                        color:{

                                                            var generation = individualView.selectedGeneration;
                                                            var cluster = 0;
                                                            var individual = individualView.selectedIndividual;


                                                            return Utils.getGeneStyle(generation, cluster,individual, index)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        Repeater {
                                            id: labelRepeater
                                            model: gaviz.getNbObjectiveFunctions()
                                            Label {
                                                text: "Fitness " + index +": "+
                                                      gaviz.getIndividualProperty(selectedPopulation, selectedGeneration, 0, selectedIndividual, index, IndividualProperty.Fitness)
                                                      + '\n' + "Rank: " + selectedIndividual + '\n' + "Genes : " + coloredInd.numgenes
                                            }
                                        }

                                    }
                                }

                                Frame{
                                    implicitWidth: parent.width
                                    Layout.preferredHeight: 0.7*parent.height
                                    Layout.preferredWidth: parent.width
                                    /*
                                    ScrollView{
                                        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                                        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                                        contentHeight: parent.height
                                        contentWidth: parent.width
                                        clip: true
                                        */

                                    GridLayout{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        columns: 3
                                        columnSpacing: 0.12*parent.width
                                        rowSpacing: 10

                                        Repeater{
                                            model: coloredInd.numgenes
                                            Label {
                                                text: "Gene " + index + " : " +
                                                      gaviz.getGene(selectedGeneration, 0, selectedIndividual, index)
                                            }
                                        }
                                    }
                                    //}
                                }
                            }
                        }

                        Dialog {
                            id: tspDialog
                            title: qsTr("Genes Inspector")
                            visible: false

                            anchors.centerIn: Overlay.overlay
                            width: 900
                            height: 700
                            modal : true

                            //standardButtons: Dialog.Ok

                            contentItem: ColumnLayout {
                                Frame{
                                    id: tspframe

                                    Layout.preferredHeight: parent.height
                                    Layout.preferredWidth: parent.width

                                    Column { /* inner column */
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 10

                                        Text {
                                            color: "white"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: qsTr("Proposed Route :")
                                        }

                                        Canvas{
                                            id: tspCanvas
                                            width: 600
                                            height: 600

                                            anchors.centerIn: tspframe.Center

                                            property real radius: 6
                                            property real margin: 25
                                            property var pointsArray : []
                                            property int numgenes: gaviz.getIndividualProperty(selectedPopulation,
                                                                                               selectedGeneration, 0,
                                                                                               selectedIndividual,
                                                                                               selectedFitness, IndividualProperty.NumGenes)
                                            onPaint: {
                                                pointsArray = []
                                                var context = getContext("2d");
                                                context.reset()
                                                tspCanvas.requestPaint();

                                                var gene, geneX, geneY;

                                                for(var k = 0; k < numgenes; k++){
                                                    gene = gaviz.getGene(selectedGeneration, 0, selectedIndividual, k)
                                                    geneX = gene.slice(1).slice(0, gene.length-2).split(",")[0]
                                                    geneY = gene.slice(1).slice(0, gene.length-2).split(",")[1]

                                                    tspCanvas.pointsArray.push({"x": (geneX * 1.4), "y": (geneY * 1.4)})
                                                }

                                                context.save()
                                                if(pointsArray.length > 0){
                                                    for(var i = 0; i < pointsArray.length; i++){
                                                        if(i === 0)
                                                        {
                                                            context.clearRect(0, 0, width, height)
                                                            context.fillStyle = "white"
                                                            context.fillRect(0, 0, width, height)
                                                            context.fill()
                                                            context.fillStyle = "green"
                                                        }
                                                        else if(i === 1)
                                                            context.fillStyle = "black"
                                                        else if( i === pointsArray.length-1)
                                                            context.fillStyle = "red"

                                                        var point= pointsArray[i]
                                                        context.fillRect(point["x"]-radius, point["y"]-radius, 2*radius, 2*radius)
                                                    }
                                                    context.strokeStyle = Qt.rgba(0, 1, 1, 0)
                                                    context.fill()
                                                    context.stroke()
                                                    context.beginPath()
                                                    var start = pointsArray[0]
                                                    context.moveTo(start["x"], start["y"])
                                                    for(var j=1; j < pointsArray.length; j++){
                                                        var end= pointsArray[j]
                                                        context.lineTo(end["x"], end["y"])
                                                        context.moveTo(end["x"], end["y"])
                                                    }
                                                    context.closePath()
                                                    context.strokeStyle = Qt.rgba(0, 0, 1, 0.5)
                                                    context.lineWidth = 2
                                                    context.stroke()
                                                }
                                                context.restore()

                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
    }
}

