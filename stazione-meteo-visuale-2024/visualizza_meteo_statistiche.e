note
	description: "Summary description for {VISUALIZZA_METEO_STATISTICHE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_METEO_STATISTICHE

inherit

	VIS_MEM_METEO
		redefine
			reset_widget,
			build_temperature_widgets,
			build_humidity_widgets,
			build_pressure_widgets
		end

create
	default_create

feature  -- Display update

	reset_widget
		do
			precursor
			old_temperature_value_label.set_text ("-")
			old_humidity_value_label.set_text ("-")
			old_pressure_value_label.set_text ("-")
		end

feature {NONE} -- Implementation GUI

	build_temperature_widgets
		do
			precursor
			create old_temperature_label
			old_temperature_label.set_text ("Temp. precedente:")
			old_temperature_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			old_temperature_label.set_font (internal_font)

			enclosing_box.extend (old_temperature_label)
			enclosing_box.set_item_x_position (old_temperature_label, 10)
			enclosing_box.set_item_y_position (old_temperature_label, 60)

			create old_temperature_value_label
			old_temperature_value_label.set_text ("-")
			old_temperature_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			old_temperature_value_label.set_font (internal_font)

			enclosing_box.extend (old_temperature_value_label)
			enclosing_box.set_item_x_position (old_temperature_value_label, 280)
			enclosing_box.set_item_y_position (old_temperature_value_label, 60)
		end


	build_humidity_widgets
		do
			precursor
			create old_humidity_label
			old_humidity_label.set_text ("Umidita' precedente:")
			old_humidity_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			old_humidity_label.set_font (internal_font)

			enclosing_box.extend (old_humidity_label)
			enclosing_box.set_item_x_position (old_humidity_label, 10)
			enclosing_box.set_item_y_position (old_humidity_label, 140)

			create old_humidity_value_label
			old_humidity_value_label.set_text ("-")
			old_humidity_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			old_humidity_value_label.set_font (internal_font)

			enclosing_box.extend (old_humidity_value_label)
			enclosing_box.set_item_x_position (old_humidity_value_label, 280)
			enclosing_box.set_item_y_position (old_humidity_value_label, 140)
		end

	build_pressure_widgets
	do
		precursor
		create old_pressure_label
		old_pressure_label.set_text ("Pressione precedente:")
		old_pressure_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
		old_pressure_label.set_font (internal_font)

		enclosing_box.extend (old_pressure_label)
		enclosing_box.set_item_x_position (old_pressure_label, 10)
		enclosing_box.set_item_y_position (old_pressure_label, 220)

		create old_pressure_value_label
		old_pressure_value_label.set_text ("-")
		old_pressure_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
		old_pressure_value_label.set_font (internal_font)

		enclosing_box.extend (old_pressure_value_label)
		enclosing_box.set_item_x_position (old_pressure_value_label, 280)
		enclosing_box.set_item_y_position (old_pressure_value_label, 220)

	end

feature -- Display update

	display_temperature
			-- Update the text of `temperature_value_label' with `a_temperature'.
		local
			temp_prev: REAL_32
		do
			temperature_label.set_text ("Temperatura media:")
			temp_prev := media (temperatura_precedente, temperatura)
			if temp_prev /= 0 then
				temperature_value_label.set_text (temp_prev.out + "°")
				old_temperature_value_label.set_text (temperatura_precedente.out + "°")
			else
				temperature_value_label.set_text (Dash)
			end
		ensure then
			no_temperature_displayed: temperatura_precedente = 0 implies temperature_value_label.text.is_equal (Dash)
			temperature_displayed: temperatura_precedente /= 0 implies temperature_value_label.text.is_equal (temperatura_precedente.out)
		end

	display_humidity
			-- Update the text of `humidity_value_label' with `a_humidity'.
		local
			hum_prev: REAL_32
		do
			humidity_label.set_text ("Umidita' media:")
			hum_prev := media (umidita_precedente, umidita)
			if hum_prev /= 0 then
				humidity_value_label.set_text (hum_prev.out + "%%")
				old_humidity_value_label.set_text (umidita_precedente.out + "%%")
			else
				humidity_value_label.set_text (dash)
			end
		ensure then
			no_humidity_displayed: umidita_precedente = 0 implies humidity_value_label.text.is_equal (Dash)
			humidity_displayed: umidita_precedente /= 0 implies humidity_value_label.text.is_equal (umidita_precedente.out)
		end

	display_pressure
			-- Update the text of `pressure_value_label' with `a_pressure'.
		local
			press_prev: REAL_32
		do
			pressure_label.set_text ("Pressione media:")
			press_prev := media (pressione_precedente, pressione)
			if press_prev /= 0 then
				pressure_value_label.set_text (press_prev.out + " mb")
				old_pressure_value_label.set_text (pressione_precedente.out + " mb")
			else
				pressure_value_label.set_text (dash)
			end
		ensure then
			no_pressure_displayed: pressione = 0 implies pressure_value_label.text.is_equal (Dash)
			pressure_displayed: pressione /= 0 implies pressure_value_label.text.is_equal (pressione.out)
		end

feature {NONE} -- Implementation widgets

	old_temperature_label: EV_LABEL
			-- Temperature label old

	old_humidity_label: EV_LABEL
			-- Humidity label old

	old_pressure_label: EV_LABEL
			-- Pressure label old

	old_temperature_value_label: EV_LABEL
			-- Temperature value label old

	old_humidity_value_label: EV_LABEL
			-- Humidity value label old

	old_pressure_value_label: EV_LABEL
			-- Pressure value label	 old

end
