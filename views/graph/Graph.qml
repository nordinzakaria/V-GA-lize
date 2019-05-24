import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.4
import QtCharts 2.3

import gaviz 1.0
import "../tools"
import "../menu"

/* The Graph Frame, Second Page of the SwipeView
   Contains different types of graphs on which it is
      possible to interract using the diffent available Tools
*/
Frame {
    id: graphView

    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: 0

    property alias fitToGeneration : fitToGenerationCheckBox.checked
    property int axisWidth: 1
    property int selectedGeneration: 0

    property int selectedFitness0: 0
    property int selectedFitness1: 0
    property real maxFitness0:  gaviz.getMaxFitness(selectedPopulation, selectedFitness0)
    property real maxFitness1:  gaviz.getMaxFitness(selectedPopulation, selectedFitness1)
    property real minFitness0:  gaviz.getMinFitness(selectedPopulation, selectedFitness0)
    property real minFitness1:  gaviz.getMinFitness(selectedPopulation, selectedFitness1)
    property int selectedFitness: selectedFitness0


    ColumnLayout {
        anchors.fill: parent

        /* Header of the Graph Frame
           Contains :
              - A Label displaying a title
              - A Label displaying the current
                  Generation selected.
        */
        RowLayout {
            id: graphHeader
            spacing: 20
            Layout.leftMargin: 10
            Layout.maximumHeight: 0.1 * parent.height

            Frame {
                Layout.topMargin: 5
                id: viewTitle
                Label {
                    text: "GRAPH VIEW"
                    font.pixelSize: 24
                }
            }

            Label {
                text: "Generation " + selectedGeneration
                font.pixelSize: 24
            }
        }

        VerticalSeparator{
            Layout.fillWidth: true
        }

        /* ToolBar inside the Graph Frame,
           Contains :
             - A ComboBox to choose the Objective Function used
             - A ComboBox to choose the type of Graph
             - A Slider to select a Generation
             - A CheckBox to display the Graph
                 only for the selected Generation
                 (if checked))
        */
        RowLayout {
            id: graphToolBar
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.maximumHeight: 0.1 * parent.height

            Tool{
                Label {
                    id: fitnesslist1Label
                    text: "Function Choice :"
                }

                ComboBox {
                    id: fitnesslist1
                    currentIndex: 0
                    model: gaviz.getObjectiveFunctions()
                    width: 150
                    onCurrentIndexChanged: selectedFitness1 = currentIndex
                }
            }

            ToolSeparator{
                Layout.fillHeight: true
                Layout.rightMargin: 10
                Layout.leftMargin: 10
            }

            Tool{
                Label {
                    id: chartlistLabel
                    text: "Graph Type :"
                }

                ComboBox {
                    id: chartlist
                    currentIndex: 0
                    width: 150

                    model:   ["SCATTERPLOT", "AVERAGE", "STDDEV", "MINMAX", "HISTOGRAM" ]

                    onCurrentIndexChanged: {
                            var charts = [scatterplot, averageplot, stddevplot, minmaxplot0, minmaxplot1, histoplot, histoplot1]
                            for (var i=0; i<charts.length; i++)
                            {
                                charts[i].visible = false
                            }
                            if (currentIndex == 3)
                            {
                                charts[3].visible = true
                                charts[4].visible = true
                            }
                            else
                            if (currentIndex == 4)
                            {
                                charts[5].visible = true
                                charts[6].visible = true
                            }

                            else
                                charts[currentIndex].visible = true
                    }
                }
            }

            ToolSeparator{
                Layout.fillHeight: true
                Layout.rightMargin: 10
                Layout.leftMargin: 10
            }

            Tool {

                 Label {
                         text: "Generation Selection :"
                     }

                 Slider {
                     Layout.fillWidth: true
                     Layout.leftMargin: 20
                     from: 0
                     value: 0
                     to: gaviz.getNbGenerations(selectedPopulation) - 1

                     onValueChanged: {
                         selectedGeneration = value
                         updateBounds()
                     }
                 }
            }

            ToolSeparator{
                Layout.fillHeight: true
                Layout.rightMargin: 10
                Layout.leftMargin: 10
            }

            Tool {
                RowLayout{

                    Label {
                         text: "Fit to gen : "
                     }

                    CheckBox {
                          id: fitToGenerationCheckBox
                          onCheckStateChanged: {
                              updateBounds()
                          }
                 }

                }
            }
        }

        VerticalSeparator{

            Layout.fillWidth: true
        }

        // ChartView of the ScatterPlot Type
        ChartView {
            id: scatterplot
            Layout.fillWidth: true
            height: 450
            antialiasing: true
            visible: true
            theme: ChartView.ChartThemeDark


            function populate()
            {
                var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                var fitness0 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness0, IndividualProperty.Fitness)
                var fitness1 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness1, IndividualProperty.Fitness)
                console.log('redrawing scatter')

                for (var i=0; i<sz; i++) {
                    scatter1.append(fitness0[i], fitness1[i])
                    }
            }

            ScatterSeries {
                id: scatter1
                name: "F0:"+gaviz.getObjectiveFunction(selectedFitness0) + " vs F1:" + gaviz.getObjectiveFunction(selectedFitness1)
                Component.onCompleted: {
                        var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                        var fitness0 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness0, IndividualProperty.Fitness)
                        var fitness1 = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness1, IndividualProperty.Fitness)
                        console.log('redrawing scatter')

                        for (var i=0; i<sz; i++) {
                            scatter1.append(fitness0[i], fitness1[i])
                            }
                    }
                }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { chartDialog.open() }
               }

            FileDialog {
                id: chartDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    scatterplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(chartDialog.fileUrl)
                                                console.log('saving to '+localfile)
                                               result.saveToFile(localfile);
                                           });
                }
            }


        }

        // ChartView of the AveragePlot Type
        ChartView {
            Layout.fillWidth: true
            height: 450
            id: averageplot
            title: "Average"
            antialiasing: true
            visible:false
            theme: ChartView.ChartThemeDark

            ValueAxis {
                    id: xAxisAvg
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }

            ValueAxis {    //  <- custom ValueAxis attached to the y-axis
                id: yAxisAvg
                min: gaviz.getMinStats(selectedPopulation, selectedFitness0, StatsProperty.AVERAGE)//-0.2
                max: gaviz.getMaxStats(selectedPopulation, selectedFitness0, StatsProperty.AVERAGE)//+0.2
            }


            LineSeries {
                id: avgseries0
                name: "F0:"+gaviz.getObjectiveFunction(selectedFitness0)
                axisX: xAxisAvg
                axisY: yAxisAvg
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            avgseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.AVERAGE))
                          }
                    }
            }

            LineSeries {
                id: avgseries1
                name: "F1:"+gaviz.getObjectiveFunction(selectedFitness1)
                axisX: xAxisAvg
                axisY: yAxisAvg
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            avgseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.AVERAGE))
                          }
                    }
            }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { averageDialog.open() }
               }

            FileDialog {
                id: averageDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    averageplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(averageDialog.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }

        }

        // 2 ChartViews of the Min and Max of 2 Objective Functions
        RowLayout {
            ChartView {
                width: 0.5*parent.width
                height: 450
                id: minmaxplot0
                title: "Min and Max "+gaviz.getObjectiveFunction(selectedFitness0) + " for each Generation"
                antialiasing: true
                visible:false
                theme: ChartView.ChartThemeDark
                Layout.rightMargin: -5

                ValueAxis {
                    id: xAxisMinMax
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }
                ValueAxis {
                    id: yAxisMinMax
                    min: gaviz.getMinStats(selectedPopulation, selectedFitness0, StatsProperty.MIN)//-1
                    max: gaviz.getMaxStats(selectedPopulation, selectedFitness0, StatsProperty.MAX)//+1

                }

                LineSeries {
                    id: minseries0
                    name: "Min"
                    axisX: xAxisMinMax
                    axisY: yAxisMinMax
                    Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            minseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.MIN))
                        }
                    }
                }
                LineSeries {
                    id: maxseries0
                    name: "Max"
                    axisX: xAxisMinMax
                    axisY: yAxisMinMax
                    Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            maxseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.MAX))
                        }
                    }
                }

                MouseArea {
                   anchors.fill: parent
                   onPressAndHold:  { minmaxDialog0.open() }
               }

                FileDialog {
                id: minmaxDialog0
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    minmaxplot0.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(minmaxDialog0.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }
            }

            ChartView {
                width: 0.5*parent.width
                height: 450
                id: minmaxplot1
                title: "Min and Max "+gaviz.getObjectiveFunction(selectedFitness1)  + " for each Generation"
                antialiasing: true
                visible:false
                theme: ChartView.ChartThemeDark



                ValueAxis {
                    id: xAxisMinMax1
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }
                ValueAxis {
                    id: yAxisMinMax1
                    min: gaviz.getMinStats(selectedPopulation, selectedFitness0, StatsProperty.MIN)//-1
                    max: gaviz.getMaxStats(selectedPopulation, selectedFitness0, StatsProperty.MAX)//+1

                }


                LineSeries {
                id: minseries1
                name: "Min"

                axisX: xAxisMinMax1
                axisY: yAxisMinMax1

                Component.onCompleted: {
                    var gsz = gaviz.getNbGenerations(selectedPopulation)
                    for (var i=0; i<gsz; i++) {
                        minseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.MIN))
                    }
                }
            }
                LineSeries {
                id: maxseries1
                name: "Max"
                axisX: xAxisMinMax1
                axisY: yAxisMinMax1

                Component.onCompleted: {
                    var gsz = gaviz.getNbGenerations(selectedPopulation)
                    for (var i=0; i<gsz; i++) {
                        maxseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.MAX))
                    }
                }
            }

                MouseArea {
                   anchors.fill: parent
                   onPressAndHold:  { minmaxDialog1.open() }
               }

                FileDialog {
                id: minmaxDialog1
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    minmaxplot1.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(minmaxDialog1.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }
            }
        }

        // ChartView of the StandradDeviationPlot Type
        ChartView {
            Layout.fillWidth: true
            height: 450
            id: stddevplot
            title: "Standard Deviation"
            antialiasing: true
            visible:false
            theme: ChartView.ChartThemeDark

            ValueAxis {
                    id: xAxisStddev
                    min: 0
                    max: gaviz.getNbGenerations(selectedPopulation)
                }
            ValueAxis {
                id: yAxisStddev
                min: gaviz.getMinStats(selectedPopulation, selectedFitness0, StatsProperty.STDDEV)//-1
                max: gaviz.getMaxStats(selectedPopulation, selectedFitness0, StatsProperty.STDDEV)//+1

            }

            LineSeries {
                id: stddevseries0
                name: 'F0:'+gaviz.getObjectiveFunction(selectedFitness0)
                axisX: xAxisStddev
                axisY: yAxisStddev
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            stddevseries0.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness0, StatsProperty.STDDEV))
                          }
                    }
            }

            LineSeries {
                id: stddevseries1
                name: 'F1:'+gaviz.getObjectiveFunction(selectedFitness1)
                axisX: xAxisStddev
                axisY: yAxisStddev
                Component.onCompleted: {
                        var gsz = gaviz.getNbGenerations(selectedPopulation)
                        for (var i=0; i<gsz; i++) {
                            stddevseries1.append(i, gaviz.getStats(selectedPopulation, i, selectedFitness1, StatsProperty.STDDEV))
                          }
                    }
            }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold:  { stddevDialog.open() }
               }

            FileDialog {
                id: stddevDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    stddevplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(stddevDialog.fileUrl)
                                               result.saveToFile(localfile);
                                           });
                }
            }

        }

        // 2 ChartViews of the Histogram of 2 Objective Functions
        RowLayout {
            Layout.alignment: parent.verticalCenter
            ChartView {
                id: histoplot
                width: 0.5*parent.width
                height: 450
                antialiasing: true
                visible: false
                theme: ChartView.ChartThemeDark
                Layout.rightMargin: -5

                property double category: maxFitness0/5

                function populate()
                {
                    var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                    var fitness = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness0, IndividualProperty.Fitness)
                    var count = [0, 0, 0, 0, 0]

                    for (var i=0; i<sz; i++)
                    {
                        if (fitness[i] < histoplot.category)
                            count[0]++
                        else if (fitness[i] < 2*histoplot.category)
                            count[1]++
                        else if (fitness[i] < 3*histoplot.category)
                            count[2]++
                        else if (fitness[i] < 4*histoplot.category)
                            count[3]++
                        else
                            count[4]++
                    }

                    var max = 0
                    for (i=0; i<count.length; i++)
                    {
                        console.log('count at index '+i+' is '+count[i])
                        if (count[i] > max)
                            max = count[i]
                    }

                    hist0ValueAxis.max = max
                    histoseries.append(gaviz.getObjectiveFunction(selectedFitness0), count)
                }

                BarSeries {
                id: histoseries
                name: "F0 : "+gaviz.getObjectiveFunction(selectedFitness0)
                axisX: BarCategoryAxis {
                    categories: [(histoplot.category).toFixed(4),
                                 (2*histoplot.category).toFixed(4),
                                 (3*histoplot.category).toFixed(4),
                                 (4*histoplot.category).toFixed(4),
                                 (maxFitness0).toFixed(4)
                                ]
                }

                axisY: ValueAxis {
                    id: hist0ValueAxis
                    min: 0
                }
                Component.onCompleted: {
                    histoplot.populate()
                    }
                }

                MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { histoDialog.open() }
               }

                FileDialog {
                id: histoDialog
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    histoplot.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(histoDialog.fileUrl)
                                                console.log('saving to '+localfile)
                                               result.saveToFile(localfile);
                                           });
                }
            }
            }

            ChartView {
            id: histoplot1
            width: 0.5*parent.width
            height: 450
            antialiasing: true
            visible: false
            theme: ChartView.ChartThemeDark

            property double category: maxFitness1/5

            function populate()
            {
                var sz = gaviz.getNbIndInGeneration(selectedPopulation, selectedGeneration)
                var fitness = gaviz.getIndividualPropertyList(selectedPopulation, selectedGeneration, 0, selectedFitness0, IndividualProperty.Fitness)
                var count = [0, 0, 0, 0, 0]

                for (var i=0; i<sz; i++)
                {
                    if (fitness[i] < histoplot1.category)
                        count[0]++
                    else if (fitness[i] < 2*histoplot1.category)
                        count[1]++
                    else if (fitness[i] < 3*histoplot1.category)
                        count[2]++
                    else if (fitness[i] < 4*histoplot1.category)
                        count[3]++
                    else
                        count[4]++
                }

                var max = 0
                for (i=0; i<count.length; i++)
                {
                    console.log('count at index '+i+' is '+count[i])
                    if (count[i] > max)
                        max = count[i]
                }

                hist1ValueAxis.max = Math.ceil(max)
                histoseries1.append(gaviz.getObjectiveFunction(selectedFitness0), count)
            }

            BarSeries {
                id: histoseries1
                name: "F1 : "+gaviz.getObjectiveFunction(selectedFitness1)
                axisX: BarCategoryAxis {
                    categories: [(histoplot1.category).toFixed(4),
                                 (2*histoplot1.category).toFixed(4),
                                 (3*histoplot1.category).toFixed(4),
                                 (4*histoplot1.category).toFixed(4),
                                 (maxFitness1).toFixed(4)
                                ]
                }

                axisY: ValueAxis {
                    id: hist1ValueAxis
                    min: 0
                }

                Component.onCompleted: {
                    histoplot1.populate()
                    }
                }

            MouseArea {
                   anchors.fill: parent
                   onPressAndHold: { histoDialog1.open() }
               }

            FileDialog {
                id: histoDialog1
                title: "Please choose a file"
                folder: shortcuts.home
                modality: Qt.NonModal
                selectExisting : false
                nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]

                onAccepted: {
                    histoplot1.grabToImage(function(result) {
                                               var localfile = gaviz.getLocalFile(histoDialog1.fileUrl)
                                                console.log('saving to '+localfile)
                                               result.saveToFile(localfile);
                                           });
                    }
                }
            }
        }

    }

    /* Function used by the "Fit to Generation" CheckBox
       Updates the graph's bounds depending on wether the CheckBox
          is checked or not
    */
    function updateBounds ()
    {
        console.log('minFitness0 was '+minFitness0+', maxFitness0 was '+maxFitness0)
        console.log('minFitness1 was '+minFitness1+', maxFitness1 was '+maxFitness1)

        if(fitToGeneration){
            minFitness0 = gaviz.getMinFitness(selectedPopulation, selectedGeneration, selectedFitness0)
            minFitness1 = gaviz.getMinFitness(selectedPopulation, selectedGeneration, selectedFitness1)

            maxFitness0 = gaviz.getMaxFitness(selectedPopulation, selectedGeneration, selectedFitness0)
            maxFitness1 = gaviz.getMaxFitness(selectedPopulation, selectedGeneration, selectedFitness1)
        }
        else{
            minFitness0 = gaviz.getMinFitness(selectedPopulation, selectedFitness0)
            minFitness1 = gaviz.getMinFitness(selectedPopulation, selectedFitness1)

            maxFitness0 = gaviz.getMaxFitness(selectedPopulation, selectedFitness0)
            maxFitness1 = gaviz.getMaxFitness(selectedPopulation, selectedFitness1)
        }

        console.log('minFitness0 = '+minFitness0+', maxFitness0='+maxFitness0 +" for gen "+selectedGeneration+', for fitness '+selectedFitness0)
        console.log('minFitness1 = '+minFitness1+', maxFitness1='+maxFitness1)

        scatter1.clear()
        scatterplot.populate()
    }
}
