note
	description: "Summary description for {STILE_FINESTRE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STILE_FINESTRE

feature

	Color_temperature : EV_COLOR
		once
			Result:= create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0)
		end

	Color_humidity : EV_COLOR
		once
			Result:= create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255)
		end

	Color_pressure : EV_COLOR
		once
			Result:= create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0)
		end

	Color_text : EV_COLOR
		once
			Result:= create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0)
		end

 	unit_of_measurement_temperature: STRING = "°"

 	unit_of_measurement_pressure: STRING = "mb"

 	unit_of_measurement_humidity: STRING = "%%"

 	Dash: STRING = "-"

	Font_size_height: INTEGER
		once
			Result := 20
		end

	internal_font: EV_FONT
			-- Internal font used by various widgets
		once
			create Result.make_with_values ({EV_FONT_CONSTANTS}.Family_sans, {EV_FONT_CONSTANTS}.Weight_regular, {EV_FONT_CONSTANTS}.Shape_regular, Font_size_height)
		ensure
			internal_font_created: Result /= Void
			font_family_set_to_family_sans: Result.family = {EV_FONT_CONSTANTS}.Family_sans
			font_weight_set_to_weight_regular: Result.weight = {EV_FONT_CONSTANTS}.Weight_regular
			font_shape_set_to_shape_regular: Result.shape = {EV_FONT_CONSTANTS}.Shape_regular
			font_height_set_to_font_size_height: Result.height = Font_size_height
		end
end
