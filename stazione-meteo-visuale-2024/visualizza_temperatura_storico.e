note
	description: "Summary description for {VISUALIZZA_TEMPERATURA_STORICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_TEMPERATURA_STORICO

inherit
	VISUALIZZA_METEO_STORICO


feature

	make_top_row
		local
			label: EV_LABEL
			sensor_label: EV_LABEL
		do
			create label
			label.set_text ("n°")
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, 10)
			enclosing_box.set_item_y_position (label, 0)

			create sensor_label
			sensor_label.set_text ("Temperatura")
			sensor_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			sensor_label.set_font (internal_font)

			enclosing_box.extend (sensor_label)
			enclosing_box.set_item_x_position (sensor_label, 100)
			enclosing_box.set_item_y_position (sensor_label, 0)
		end

	make_row (weather_report: TUPLE)

		local
			label: EV_LABEL
			sensor_label: EV_LABEL
		do
			create label
			label.set_text (weather_report[1].out)
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, 10)
			enclosing_box.set_item_y_position (label, next_y)

			create sensor_label
			sensor_label.set_text (weather_report[2].out+ "°")
			sensor_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			sensor_label.set_font (internal_font)

			enclosing_box.extend (sensor_label)
			enclosing_box.set_item_x_position (sensor_label, 100)
			enclosing_box.set_item_y_position (sensor_label, next_y)

			next_y := next_y + 30

		end
end
