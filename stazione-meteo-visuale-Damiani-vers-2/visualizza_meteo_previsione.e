note
	description: "Summary description for {VISUALIZZA_METEO_PREVISIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_METEO_PREVISIONE

inherit

	VIS_MEM_METEO

create
	default_create

feature {NONE}

	previsione (precedente: REAL; attuale: REAL): REAL
			-- fa la previsione del valore futuro sulla base della media e due valori passati
		local
			delta: REAL
		do
			delta := attuale - precedente
			Result := media (precedente, attuale) + delta
		end

feature -- Display update

	display_temperature
			-- Update the text of `temperature_value_label' with `a_temperature'.
		local
			temp_prev: REAL_32
		do
			temperature_label.set_text ("Temperatura prevista:")
			temp_prev := previsione (temperatura_precedente, temperatura)
			if temp_prev /= 0 then
				temperature_value_label.set_text (temp_prev.out + "°")
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
			humidity_label.set_text ("Umidita' prevista:")
			hum_prev := previsione (umidita_precedente, umidita)
			if hum_prev /= 0 then
				humidity_value_label.set_text (hum_prev.out + "%%")
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
			pressure_label.set_text ("Pressione prevista:")
			press_prev := previsione (pressione_precedente, pressione)
			if press_prev /= 0 then
				pressure_value_label.set_text (press_prev.out + " mb")
			else
				pressure_value_label.set_text (dash)
			end
		ensure then
			no_pressure_displayed: pressione = 0 implies pressure_value_label.text.is_equal (Dash)
			pressure_displayed: pressione /= 0 implies pressure_value_label.text.is_equal (pressione.out)
		end

end
