note
	description: "Summary description for {VISUALIZZA_METEO_CORRENTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_METEO_CORRENTE

inherit

	VIS_METEO

create
	default_create

feature -- Display update

	display_temperature
			-- Update the text of `temperature_value_label' with `a_temperature'.
		do
			temperature_label.set_text ("Temperatura corrente:")
			if temperatura /= 0 then
				temperature_value_label.set_text (temperatura.out + "°")
			else
				temperature_value_label.set_text (Dash)
			end
		ensure then
			no_temperature_displayed: temperatura = 0 implies temperature_value_label.text.is_equal (Dash)
			temperature_displayed: temperatura /= 0 implies temperature_value_label.text.is_equal (temperatura.out)
		end

	display_humidity
			-- Update the text of `humidity_value_label' with `a_humidity'.
		do
			humidity_label.set_text ("Umidita' corrente:")
			if umidita /= 0 then
				humidity_value_label.set_text (umidita.out + "%%")
			else
				humidity_value_label.set_text (dash)
			end
		ensure then
			no_humidity_displayed: umidita = 0 implies humidity_value_label.text.is_equal (Dash)
			humidity_displayed: umidita /= 0 implies humidity_value_label.text.is_equal (umidita.out)
		end

	display_pressure
			-- Update the text of `pressure_value_label' with `a_pressure'.
		do
			pressure_label.set_text ("Pressione corrente:")
			if pressione /= 0 then
				pressure_value_label.set_text (pressione.out + " mb")
			else
				pressure_value_label.set_text (dash)
			end
		ensure then
			no_pressure_displayed: pressione = 0 implies pressure_value_label.text.is_equal (Dash)
			pressure_displayed: pressione /= 0 implies pressure_value_label.text.is_equal (pressione.out)
		end

end
