note
	description: "Summary description for {VIS_MEM_DATI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- Ceccarelli Claudia
deferred class
	VIS_MEM_DATI

inherit
	VIS_DATI
	redefine
		set_pressure, set_humidity, set_temperature
	end
feature {NONE}
	temperatura_precedente: REAL
          -- contiene il valore della temperatura precedente ricevuto
	 umidita_precedente : REAL
          -- contiene il valore dell'umidità precedente ricevuto
	pressione_precedente : REAL
          -- contiene il valore della pressione precedente ricevuto
	media (precedente : REAL; attuale : REAL) : REAL
          -- ritorna la media dei due valori passati
		do
			if precedente /= 0 then
				Result := (precedente + attuale) / 2
			else
				Result := attuale
			end
		end
feature

	set_temperature (a_temperature: REAL_32)
			-- Update the text of `temperature_value_label' with `a_temperature'.
		do
			Precursor( a_temperature )
			display_temperature
			temperatura_precedente := a_temperature
		ensure then
			temperatura_precedente = a_temperature
		end

	set_humidity (a_humidity: REAL_32)
			-- Update the text of `humidity_value_label' with `a_humidity'.
		do
			Precursor( a_humidity )
			display_humidity
			umidita_precedente := a_humidity
		ensure then
			umidita_precedente = a_humidity
		end

	set_pressure (a_pressure: REAL_32)
			-- Update the text of `pressure_value_label' with `a_pressure'.	
		do
			Precursor( a_pressure )
			display_pressure
			pressione_precedente := a_pressure
		ensure then
			pressione_precedente = a_pressure
		end
end
