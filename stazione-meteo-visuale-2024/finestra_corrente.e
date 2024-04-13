note
	description: "Summary description for {VISUALIZZA_METEO_CORRENTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FINESTRA_CORRENTE

inherit
	STORIA
		undefine
			copy,
			default_create
		end

	FINESTRA_SEMPLICE
		redefine
			create_interface_objects
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
		do
			precursor
			create Database_temperature.make
			create Database_pressure.make
			create Database_humidity.make
		end

feature -- Display update

	display_temperature
			-- Update the text of `temperature_value_label' with `a_temperature'.
		do
			temperature_label.set_text ("Temperatura corrente:")
			if attached Database_temperature.last as temperatura then
				temperature_value_label.set_text (temperatura.out + unit_of_measurement_temperature)
			else
				temperature_value_label.set_text (Dash)
			end
		end

	display_humidity
			-- Update the text of `humidity_value_label' with `a_humidity'.
		do
			humidity_label.set_text ("Umidita' corrente:")
			if attached Database_humidity.last as umidita then
				humidity_value_label.set_text (umidita.out + unit_of_measurement_humidity)
			else
				humidity_value_label.set_text (dash)
			end
		end

	display_pressure
			-- Update the text of `pressure_value_label' with `a_pressure'.
		do
			pressure_label.set_text ("Pressione corrente:")
			if attached Database_pressure.last as pressione then
				pressure_value_label.set_text (pressione.out + unit_of_measurement_pressure)
			else
				pressure_value_label.set_text (dash)
			end
		end

end
