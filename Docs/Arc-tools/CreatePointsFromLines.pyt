import arcpy
import os

class Toolbox(object):
    def __init__(self):
        """Define the toolbox (the name of the toolbox is the name of the
        .pyt file)."""
        self.label = "Create Points Along Lines"
        self.alias = "alonglines"

        # List of tool classes associated with this toolbox
        self.tools = [CreatePointsAlongLines]


class CreatePointsAlongLines(object):
    def __init__(self):
        self.label = "Create Points Along Lines"
        self.description = "Constructs point features at intervals along line features."
        self.canRunInBackground = True

    def getParameterInfo(self):
        """Define parameter definitions"""
        in_lines = arcpy.Parameter(
            displayName="Input Line Features",
            name="in_line_features",
            datatype="Feature Layer",
            parameterType="Required",
            direction="Input")
        in_lines.filter.list = ['Polyline']

        out_points = arcpy.Parameter(
            displayName="Output Point Feature Class",
            name="out_point_features",
            datatype="Feature Class",
            parameterType="Required",
            direction="Output")

        interval = arcpy.Parameter(
            displayName="Interval (units are in units of input)",
            name="interval",
            datatype="Double",
            parameterType="Required",
            direction="Input")

        use_percentage = arcpy.Parameter(
            displayName="Use as percentage (or value)",
            name="use_percentage",
            datatype="Boolean",
            parameterType="Optional",
            direction="Input")
        use_percentage.filter.list = ["PERCENTAGE", "VALUE"]
        use_percentage.value = "VALUE"

        end_points = arcpy.Parameter(
            displayName="Start and End Points",
            name="end_points",
            datatype="Boolean",
            parameterType="Optional",
            direction="Input")
        end_points.filter.list = ["END_POINTS", "NO_END_POINTS"]
        end_points.value = "NO_END_POINTS"

        return [in_lines, out_points, interval, use_percentage, end_points]

    def isLicensed(self):
        return True

    def updateParameters(self, parameters):

        parameters[1].parameterDependencies = [parameters[0].name]
        parameters[1].schema.clone = True
        parameters[1].schema.geometryTypeRule = "AsSpecified"
        parameters[1].schema.geometryType = "Point"
        parameters[1].schema.fieldsRule = "FirstDependencyFIDs"
        parameters[1].schema.fieldsRule = "None"

        id_field = arcpy.Field()
        id_field.name = "FID_1"
        id_field.type = "Integer"

        parameters[1].schema.additionalFields = [id_field]

        return

    def updateMessages(self, parameters):
        """Provide error messages if interval is invalid"""
        err_percentage = "Percentages must be between 0.0 and 1.0"
        err_value = "Distance value cannot be a negative number"

        if parameters[3].value:  # percentage
            if parameters[2].value < 0.0 or parameters[2].value > 1.0:
                parameters[2].setErrorMessage(err_percentage)
        elif parameters[3].value == False:  # value
            if parameters[2].value < 0.0:
                parameters[2].setErrorMessage(err_value)
        return

    def execute(self, parameters, messages):
        """The source code of the tool."""
        in_fc = parameters[0].valueAsText
        out_fc = parameters[1].valueAsText
        interval = parameters[2].value
        use_percentage = parameters[3].value
        end_points = parameters[4].value

        desc = arcpy.Describe(in_fc)

        # Create output feature class
        arcpy.CreateFeatureclass_management(
            os.path.dirname(out_fc),
            os.path.basename(out_fc),
            geometry_type="POINT",
            spatial_reference=desc.spatialReference)

        # Add a field to transfer FID from input
        fid_name = "FID_1"
        arcpy.AddField_management(out_fc, fid_name, "LONG")

        # Create new points based on input lines
        with arcpy.da.SearchCursor(
                in_fc, ['SHAPE@', desc.OIDFieldName]) as search_cursor:
            with arcpy.da.InsertCursor(
                    out_fc, ['SHAPE@', fid_name]) as insert_cursor:
                for row in search_cursor:
                    line = row[0]

                    if line:  # if null geometry--skip
                        if end_points:
                            insert_cursor.insertRow([line.firstPoint, row[1]])

                        cur_length = interval

                        max_position = 1
                        if not use_percentage:
                            max_position = line.length

                        while cur_length < max_position:
                            insert_cursor.insertRow(
                                [line.positionAlongLine(
                                    cur_length, use_percentage), row[1]])
                            cur_length += interval

                        if end_points:
                            insert_cursor.insertRow(
                                [line.positionAlongLine(1, True), row[1]])

        return