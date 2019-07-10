import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import gaviz 1.0

/* The ToolBar that is just below the Menu
   It contains different Tools and ToolSeparators
   Including :
      - A RangeSlider allowing to select the Minimum and Maximum
          Score Limits in the Population
      - A Slider allowing to select the Minimum more precisely
          in the range given by the RangeSlider
          (if the RangeSlider is changed, this value is not)
      - A ComboBox allowing the user to select the Objective Function used
      - A ComboBox allowing the user to select the population                <-------- Not Very clear yet
      - An empty Item in order to keep all the Tools on the left
*/
RowLayout {
    id: toolBar

    Layout.maximumHeight: 0.07 * parent.height
    property alias zoomSlider: zoomSlider


    signal minScoreChanged(int minScore);
    signal objectiveFunctionsChanged(int index);
    signal populationChanged(int population);
    signal zoomChanged(double zoom);

    /* A RangeSlider allowing to select the Minimum and Maximum
         Score Limits in the Population
    */
    ColumnLayout {
        id: boundsScore

        property int min: rangeSlider.first.value
        property int max: rangeSlider.second.value

        Label {
            text: qsTr("Min and Max Score Limits");
        }

        RangeSlider{
            id: rangeSlider

            from: 0 // minimal value
            to: 100 // maximal value

            first.value: from
            second.value: to

            onHoveredChanged: {
                ToolTip.visible = hovered
                ToolTip.text = qsTr("From : %L1 to %L2").arg(first.value).arg(second.value);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    /* A Slider allowing to select the Minimum more precisely
         in the range given by the RangeSlider
         (if the RangeSlider is changed, this value is not)
    */
    ColumnLayout{
        id: minScore

        Label {
            text: qsTr("Wanted Quality")
        }


        Slider {

            from: boundsScore.min
            value : from
            to: boundsScore.max

            onValueChanged: {
                var intValue = parseFloat(value);
                toolBar.minScoreChanged(intValue);   // notify that the minSocre has been modified
            }
            onHoveredChanged: {
                ToolTip.visible = hovered
                ToolTip.text = qsTr("Value : %1").arg(value);
            }
        }
    }

    ToolSeparator{
        Layout.topMargin: 0
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // A ComboBox allowing the user to select the Objective Function used
    ColumnLayout {

        width: 500
        Label {
            text: qsTr("Performance type")
        }

        ComboBox {
            id: popFitness
            currentIndex: 0
            model: gaviz.getObjectiveFunctions()
            width: parent.width
            onCurrentIndexChanged: {
                toolBar.objectiveFunctionsChanged(currentIndex); // to notify that an objectiv function has been selected
            }
        }

    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // A ComboBox allowing the user to select the population                <-------- Not Very clear yet
    ColumnLayout {
        width: 500
        Label {
            text: qsTr("Population")
        }

        ComboBox {
            id: popIndex
            currentIndex: 0
            model: gaviz.getNbPopulations()
            width: parent.width
            onCurrentIndexChanged: {
                toolBar.populationChanged(currentIndex); // Notify that a new population has been selected.
            }
        }

    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // A Slider allowing to select and view the Zoom Value more precisely
    ColumnLayout{
        Label {
            text: qsTr("Zoom Value")
        }


        Slider {
            id: zoomSlider
            from: 1
            stepSize: 1
            to: 100

            onValueChanged:  {
                var doubleValue = parseFloat(value);
                toolBar.zoomChanged(doubleValue);        // Notify that the zoom has been modified
            }
            onHoveredChanged: {
                ToolTip.visible = hovered
                ToolTip.text = qsTr("Value : %L1").arg(value);
            }
        }
    }

    ToolSeparator{
        Layout.fillHeight: true
        Layout.rightMargin: 10
        Layout.leftMargin: 10
    }

    // An empty Item in order to keep all the Tools on the left
    Item {
        Layout.fillWidth: true
    }
}
