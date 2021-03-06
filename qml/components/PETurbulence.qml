/****************************************************************************
**
** Copyright (C) 2013-2015 Oleg Yadrov
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
** http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
**
****************************************************************************/

import QtQuick 2.4
import QtQuick.Particles 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import "../scripts/ObjectManager.js" as ObjectManager
import "../controls"

SceneItem {
    id: peTurbulence

    frameColor: settings.turbulenceColor

    property string type: "Turbulence"
    property bool isAffector: true
    property int uniqueID: ObjectManager.getNewAffectorID()

    Turbulence {
        id: turbulence
        anchors.fill: parent
        system: ObjectManager.getDefaultSystem()

        Component.onCompleted: {
            shape = scene.rectangleShapeComponent.createObject(turbulence)
        }

        function getListProperty(propertyName) {
            var listPropertyValues = []

            for (var key in turbulence[propertyName])
                listPropertyValues.push(turbulence[propertyName][key])

            return listPropertyValues
        }
    }

    property Component settingsComponent:
        Component {
            GridLayout {
                columns: 2

                PropertyNameLabel {
                    text: "Type"
                }
                TextField {
                    Layout.fillWidth: true

                    text: peTurbulence.type
                    enabled: false
                }

                PropertyNameLabel {
                    text: "Object name"
                }
                TextField {
                    Layout.fillWidth: true

                    maximumLength: 50

                    text: peTurbulence.objectName
                    onTextChanged:
                        peTurbulence.objectName = text
                }

                PropertyNameLabel {
                    text: "Width"
                }
                SpinBox {
                    Layout.fillWidth: true

                    minimumValue: 1
                    maximumValue: consts.maxInt

                    value: peTurbulence.width
                    onValueChanged:
                        peTurbulence.width = value
                }

                PropertyNameLabel {
                    text: "Height"
                }
                SpinBox {
                    Layout.fillWidth: true

                    minimumValue: 1
                    maximumValue: consts.maxInt

                    value: peTurbulence.height
                    onValueChanged:
                        peTurbulence.height = value
                }

                PropertyNameLabel {
                    text: "Enabled"
                }
                CheckBox {
                    Layout.fillWidth: true

                    checked: turbulence.enabled
                    onCheckedChanged:
                        turbulence.enabled = checked
                }

                PropertyNameLabel {
                    text: "Groups"
                }
                TextField {
                    Layout.fillWidth: true

                    text: turbulence.groups.join(",")
                    onTextChanged: {
                        // here [] !== [""], what is ~right~ for emitter's property "group" which equals to an empty string ("") by default
                        if (text === "")
                            turbulence.groups = []
                        else
                            turbulence.groups = text.split(",")
                    }
                }

                PropertyNameLabel {
                    text: "When colliding with"
                }
                TextField {
                    Layout.fillWidth: true

                    text: turbulence.whenCollidingWith.join(",")
                    onTextChanged:
                        turbulence.whenCollidingWith = text.split(",")
                }

                PropertyNameLabel {
                    text: "Once"
                }
                CheckBox {
                    Layout.fillWidth: true

                    checked: turbulence.once
                    onCheckedChanged:
                        turbulence.once = checked
                }

                PropertyNameLabel {
                    text: "Noise source"
                }
                ImageSelector {
                    Layout.fillWidth: true

                    path: turbulence.noiseSource
                    onPathChanged:
                        turbulence.noiseSource = path
                }

                PropertyNameLabel {
                    text: "Strength"
                }
                SpinBox {
                    Layout.fillWidth: true

                    minimumValue: 0
                    maximumValue: consts.maxInt
                    decimals: 2

                    value: turbulence.strength
                    onValueChanged:
                        turbulence.strength = value
                }

                PropertyNameLabel {
                    text: "Shape"
                }
                ComboBox {
                    Layout.fillWidth: true
                    model: ["Ellipse", "Line", "Mask", "Rectangle"]
                    currentIndex:
                        switch (turbulence.shape.type) {
                        case "EllipseShape":
                            0; break
                        case "LineShape":
                            1; break
                        case "MaskShape":
                            2; break
                        case "RectangleShape":
                            3; break
                        }

                    onActivated: {
                        var oldShape = turbulence.shape

                        switch (index) {
                        case 0:
                            turbulence.shape = scene.ellipseShapeComponent.createObject(turbulence)
                            break
                        case 1:
                            turbulence.shape = scene.lineShapeComponent.createObject(turbulence)
                            break
                        case 2:
                            turbulence.shape = scene.maskShapeComponent.createObject(turbulence)
                            break
                        case 3:
                            turbulence.shape = scene.rectangleShapeComponent.createObject(turbulence)
                            break
                        }

                        oldShape.destroy()
                    }
                }

                PropertyNameLabel {
                    visible: turbulence.shape.type === "EllipseShape"
                    text: "Fill"
                }
                CheckBox {
                    visible: turbulence.shape.type === "EllipseShape"
                    Layout.fillWidth: true

                    Component.onCompleted: {
                        if (visible)
                            checked = turbulence.shape.fill
                    }
                    onVisibleChanged: {
                        if (visible)
                            checked = turbulence.shape.fill
                    }
                    onCheckedChanged:
                        turbulence.shape.fill = checked
                }

                PropertyNameLabel {
                    visible: turbulence.shape.type === "LineShape"
                    text: "Mirrored"
                }
                CheckBox {
                    visible: turbulence.shape.type === "LineShape"
                    Layout.fillWidth: true

                    Component.onCompleted: {
                        if (visible)
                            checked = turbulence.shape.mirrored
                    }
                    onVisibleChanged: {
                        if (visible)
                            checked = turbulence.shape.mirrored
                    }
                    onCheckedChanged:
                        turbulence.shape.mirrored = checked
                }

                PropertyNameLabel {
                    visible: turbulence.shape.type === "MaskShape"
                    text: "Source"
                }
                ImageSelector {
                    visible: turbulence.shape.type === "MaskShape"
                    Layout.fillWidth: true

                    Component.onCompleted: {
                        if (visible)
                            path = turbulence.shape.source
                    }
                    onVisibleChanged: {
                        if (visible)
                            path = turbulence.shape.source
                    }
                    onPathChanged:
                        turbulence.shape.source = path
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

    function toQML() {
        var genericProperties = ["objectName", "x", "y", "width", "height"]
        var properties = ["enabled", "groups", "whenCollidingWith", "once", "noiseSource", "strength", "system"]
        var objectProperties = ["shape"]

        var data = "    " + peTurbulence.type + " {"

        for (var i = 0; i < genericProperties.length; i++)
            data += "\n        %1: %2".arg(genericProperties[i]).arg(JSON.stringify(peTurbulence[genericProperties[i]]))

        for (i = 0; i < properties.length; i++) {
            if (properties[i] === "system")
                data += "\n        %1: %2".arg(properties[i]).arg(turbulence.system.objectName)
            else if (properties[i] === "groups" || properties[i] === "whenCollidingWith")
                data += "\n        %1: %2".arg(properties[i]).arg(JSON.stringify(turbulence.getListProperty(properties[i])))
            else if (properties[i] === "noiseSource")
                data += "\n        %1: %2".arg(properties[i]).arg(JSON.stringify(turbulence.noiseSource.toString()))
            else
                data += "\n        %1: %2".arg(properties[i]).arg(JSON.stringify(turbulence[properties[i]]))
        }

        for (i = 0; i < objectProperties.length; i++) {
            data += "\n        %1:\n%2".arg(objectProperties[i]).arg(turbulence[objectProperties[i]].toQML())
        }

        data += "\n    }"

        return data
    }
}
