note
	description: "Summary description for {VISUALIZZA_DATI_PRECEDENTI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- Ceccarelli Claudia
class
	VISUALIZZA_DATI_PRECEDENTI

inherit
	VIS_MEM_DATI

feature {NONE} -- Implementation GUI

	build_widgets
			-- Build GUI elements.
		do
			create enclosing_box
			extend (enclosing_box)
			build_temperature_widgets
			build_humidity_widgets
			build_pressure_widgets
		end

	build_temperature_widgets
			-- Build the widgets for temperature
		require
			enclosing_box_not_void: enclosing_box /= Void
		do
			create temperature_label
			temperature_label.set_text ("Temperatura Precedente:")
			temperature_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			temperature_label.set_font (internal_font)

			enclosing_box.extend (temperature_label)
			enclosing_box.set_item_x_position (temperature_label, 10)
			enclosing_box.set_item_y_position (temperature_label, 20)

			create temperature_value_label
			temperature_value_label.set_text ("-")
			temperature_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			temperature_value_label.set_font (internal_font)

			enclosing_box.extend (temperature_value_label)
			enclosing_box.set_item_x_position (temperature_value_label, 320)
			enclosing_box.set_item_y_position (temperature_value_label, 20)
		end

	build_humidity_widgets
			-- Build the widgets for humidity
		require
			enclosing_box_not_void: enclosing_box /= Void
		do
			create humidity_label
			humidity_label.set_text ("Umidita Precedente:")
			humidity_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			humidity_label.set_font (internal_font)

			enclosing_box.extend (humidity_label)
			enclosing_box.set_item_x_position (humidity_label, 10)
			enclosing_box.set_item_y_position (humidity_label, 100)

			create humidity_value_label
			humidity_value_label.set_text ("-")
			humidity_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			humidity_value_label.set_font (internal_font)

			enclosing_box.extend (humidity_value_label)
			enclosing_box.set_item_x_position (humidity_value_label, 320)
			enclosing_box.set_item_y_position (humidity_value_label, 100)
		end

	build_pressure_widgets
			-- Build the widgets for pressure
		require
			enclosing_box_not_void: enclosing_box /= Void
		do
			create pressure_label
			pressure_label.set_text ("Pressione Precedente:")
			pressure_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
			pressure_label.set_font (internal_font)

			enclosing_box.extend (pressure_label)
			enclosing_box.set_item_x_position (pressure_label, 10)
			enclosing_box.set_item_y_position (pressure_label, 180)

			create pressure_value_label
			pressure_value_label.set_text ("-")
			pressure_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
			pressure_value_label.set_font (internal_font)

			enclosing_box.extend (pressure_value_label)
			enclosing_box.set_item_x_position (pressure_value_label, 320)
			enclosing_box.set_item_y_position (pressure_value_label, 180)
		end

feature -- Display update
	display_temperature
			-- Update the text of `temperature_value_label' with `a_temperature'.
		do
			if temperatura_precedente /= 0  then
				temperature_value_label.set_text (temperatura_precedente.out + "°")
			else
				temperature_value_label.set_text (Dash)
			end
--		ensure then
--			no_temperature_displayed: temperatura_precedente = 0 implies temperature_value_label.text.is_equal (Dash)
--			temperature_displayed: temperatura_precedente /= 0 implies temperature_value_label.text.is_equal (temperatura_precedente.out)
		end

	display_humidity
			-- Update the text of `humidity_value_label' with `a_humidity'.
		do
			if umidita_precedente /= 0 then
				humidity_value_label.set_text (umidita_precedente.out + "%%")
			else
				humidity_value_label.set_text (dash)
			end
--		ensure then
--			no_humidity_displayed: umidita_precedente = 0 implies humidity_value_label.text.is_equal (Dash)
--			humidity_displayed: umidita_precedente /= 0 implies humidity_value_label.text.is_equal (umidita_precedente.out)
		end

	display_pressure
			-- Update the text of `pressure_value_label' with `a_pressure'.	
		do
			if pressione_precedente /= 0 then
				pressure_value_label.set_text (pressione_precedente.out + " mb")
			else
				pressure_value_label.set_text (dash)
			end
--		ensure then
--			no_pressure_displayed: pressione = 0 implies pressure_value_label.text.is_equal (Dash)
--			pressure_displayed: pressione /= 0 implies pressure_value_label.text.is_equal (pressione.out)
		end
end
