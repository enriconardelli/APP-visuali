note
	description: "Summary description for {VISUALIZZA_METEO_PREVISIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FINESTRA_PREVISIONE

inherit
	STORIA
		undefine
			copy,
			default_create
		end

	FUNZ_PREVISIONE
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
		local
			temp_prev: REAL_32
		do
			temperature_label.set_text ("Temperatura prevista:")
			temp_prev := previsione (Database_temperature)
			if temp_prev /= 0 then
				temperature_value_label.set_text (temp_prev.out + unit_of_measurement_temperature)
			else
				temperature_value_label.set_text (Dash)
			end
		end

	display_humidity
			-- Update the text of `humidity_value_label' with `a_humidity'.
		local
			hum_prev: REAL_32
		do
			humidity_label.set_text ("Umidita' prevista:")
			hum_prev := previsione (Database_humidity)
			if hum_prev /= 0 then
				humidity_value_label.set_text (hum_prev.out + unit_of_measurement_humidity)
			else
				humidity_value_label.set_text (dash)
			end
		end

	display_pressure
			-- Update the text of `pressure_value_label' with `a_pressure'.
		local
			press_prev: REAL_32
		do
			pressure_label.set_text ("Pressione prevista:")
			press_prev := previsione (Database_pressure)
			if press_prev /= 0 then
				pressure_value_label.set_text (press_prev.out + unit_of_measurement_pressure)
			else
				pressure_value_label.set_text (dash)
			end
		end
end
