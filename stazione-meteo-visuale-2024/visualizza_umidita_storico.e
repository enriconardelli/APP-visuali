note
	description: "Summary description for {VISUALIZZA_UMIDITA_STORICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_UMIDITA_STORICO
inherit
	VISUALIZZA_METEO_STORICO


feature

	make_title
		local
			label: EV_LABEL

		do
			create label
			label.set_text ("Umidita'")
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, 150)
			enclosing_box.set_item_y_position (label, 0)
		end

	make_row (weather_report: TUPLE)

		local
			label: EV_LABEL
			sensor_label: EV_LABEL
			forecast_label: EV_LABEL
			mean_label: EV_LABEL
		do
			create label
			label.set_text (weather_report[1].out)
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, firt_column_x_position)
			enclosing_box.set_item_y_position (label, next_y)

			create sensor_label
			sensor_label.set_text (weather_report[2].out+ "%%")
			sensor_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			sensor_label.set_font (internal_font)

			enclosing_box.extend (sensor_label)
			enclosing_box.set_item_x_position (sensor_label, second_column_x_position)
			enclosing_box.set_item_y_position (sensor_label, next_y)

			create forecast_label
			forecast_label.set_text (weather_report[3].out + "%%")
			forecast_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			forecast_label.set_font (internal_font)

			enclosing_box.extend (forecast_label)
			enclosing_box.set_item_x_position (forecast_label, third_column_x_position)
			enclosing_box.set_item_y_position (forecast_label, next_y)

			create mean_label
			mean_label.set_text (weather_report[4].out + "%%")
			mean_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			mean_label.set_font (internal_font)

			enclosing_box.extend (mean_label)
			enclosing_box.set_item_x_position (mean_label, fourth_column_x_position)
			enclosing_box.set_item_y_position (mean_label, next_y)

			next_y := next_y + 30

		end
end
