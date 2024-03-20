note
	description: "Summary description for {VIS_METEO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VIS_METEO

inherit

	APPLICATION_WINDOW

feature {NONE}

	temperatura: REAL
			-- contiene il valore della temperatura ricevuto

	umidita: REAL
			-- contiene il valore dell'umidit‡ ricevuto

	pressione: REAL
			-- contiene il valore della pressione ricevuto

feature -- Display update

	display_temperature
		deferred
		end

	display_humidity
		deferred
		end

	display_pressure
		deferred
		end

	set_temperature (a_temperature: REAL_32)
			-- Update the text of `temperature_value_label' with `a_temperature'.
		do
			temperatura := a_temperature
			display_temperature
		ensure
			temperatura = a_temperature
		end

	set_humidity (a_humidity: REAL_32)
			-- Update the text of `humidity_value_label' with `a_humidity'.
		do
			umidita := a_humidity
			display_humidity
		ensure
			umidita = a_humidity
		end

	set_pressure (a_pressure: REAL_32)
			-- Update the text of `pressure_value_label' with `a_pressure'.
		do
			pressione := a_pressure
			display_pressure
		ensure
			pressione = a_pressure
		end

end
