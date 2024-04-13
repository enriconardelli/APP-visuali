note
	description: "Summary description for {VISUALIZZA_METEO_STATISTICHE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FINESTRA_STATISTICHE

inherit
	FUNZ_STATISTICHE
		undefine
			copy,
			default_create
		end

	FINESTRA_SEMPLICE
		redefine
			create_interface_objects,
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

	create_interface_objects
		do
			precursor
			create Database_temperature.make
			create Database_pressure.make
			create Database_humidity.make
		end

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
			temp: REAL_32
		do
			temperature_label.set_text ("Temperatura media:")

			if not Database_temperature.is_empty then
				temp := media (Database_temperature)
				temperature_value_label.set_text (temp.out + unit_of_measurement_temperature)
			else
				temperature_value_label.set_text (Dash)
			end

			Database_temperature.finish
			Database_temperature.back
			if attached Database_temperature.item as temperatura_precedente	then
				old_temperature_value_label.set_text (temperatura_precedente.out + unit_of_measurement_temperature)
			else
			 	old_temperature_value_label.set_text (Dash)
			end
		end

	display_humidity
			-- Update the text of `humidity_value_label' with `a_humidity'.
		local
			hum: REAL_32
		do
			humidity_label.set_text ("Umidita' media:")

			if not Database_humidity.is_empty  then
				hum := media (Database_humidity)
				humidity_value_label.set_text (hum.out + unit_of_measurement_humidity)
			else
				humidity_value_label.set_text (Dash)
			end

			Database_humidity.finish
			Database_humidity.back
			if attached Database_humidity.item as umidita_precedente then
				old_humidity_value_label.set_text (umidita_precedente.out + unit_of_measurement_humidity)
			else
			 	old_humidity_value_label.set_text (Dash)
			end
		end

	display_pressure
			-- Update the text of `pressure_value_label' with `a_pressure'.
		local
			press: REAL_32
		do
			pressure_label.set_text ("Pressione media:")

			if not Database_pressure.is_empty  then
				press := media (Database_pressure)
				pressure_value_label.set_text (press.out + unit_of_measurement_pressure)
			else
				pressure_value_label.set_text (Dash)
			end

			Database_pressure.finish
			Database_pressure.back
			if attached Database_pressure.item as pressione_precedente then
				old_pressure_value_label.set_text (pressione_precedente.out + unit_of_measurement_pressure)
			else
			 	old_pressure_value_label.set_text (Dash)
			end
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
