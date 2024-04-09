note
	description: "Summary description for {VISUALIZZA_METEO_PREVISIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_METEO_PREVISIONE

inherit

	VIS_MEM_METEO
		redefine
			create_interface_objects
		end

create
	default_create

feature {NONE}

	create_interface_objects
		do
			Precursor
			create Database_temperature.make
			create Database_pressure.make
			create Database_humidity.make
		end

	previsione (a_database: TWO_WAY_LIST[ REAL ] ): REAL
			-- fa la previsione del valore futuro sulla base della media e due valori passati
		local
			mediax: REAL
			mediay: REAL
			x_times_y: REAL
			x_square: REAL
			beta: REAL
			alpha: REAL
			i: INTEGER
			n: INTEGER
		do
			if
				a_database.count > 1
			then

				if
					a_database.count <= Prevision_number
				then
					n := a_database.count
				else
					n := Prevision_number
				end



				mediax := (n.to_real +1)/2

			 	from
			 		mediay := 0
			 		i := 1
			 	until
			 		i > n
			 	loop
			 		mediay := mediay + a_database[a_database.count - n + i]
			 		i := i+1
			 	end
				mediay := mediay/n

				from
					x_times_y := 0
					x_square := 0
					i := 1
				until
					i > n
				loop
					x_times_y := x_times_y + (i - mediax)*(a_database[a_database.count - n + i] - mediay)
					x_square := x_square + (i - mediax)*(i-mediax)
			 		i := i+1
				end

				beta:= x_times_y/x_square
				alpha := mediay - (beta * mediax)

				Result := alpha + (beta*(n.to_real +1))
			else
				Result := a_database[1]
			end
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
			hum_prev := previsione (Database_humidity)
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
			press_prev := previsione (Database_pressure)
			if press_prev /= 0 then
				pressure_value_label.set_text (press_prev.out + " mb")
			else
				pressure_value_label.set_text (dash)
			end
		ensure then
			no_pressure_displayed: pressione = 0 implies pressure_value_label.text.is_equal (Dash)
			pressure_displayed: pressione /= 0 implies pressure_value_label.text.is_equal (pressione.out)
		end

	add_temperature (a_value: REAL)
		do
			Database_temperature.extend (a_value)
			display_temperature
		end

	add_pressure (a_value: REAL)
		do
			Database_pressure.extend (a_value)
			display_pressure
		end

	add_humidity (a_value: REAL)
		do
			Database_humidity.extend (a_value)
			display_humidity
		end

feature {NONE} -- Implementation Constants	

	Database_temperature: TWO_WAY_LIST[ REAL ]

	Database_pressure: TWO_WAY_LIST[ REAL ]

	Database_humidity: TWO_WAY_LIST[ REAL ]

	Prevision_number: INTEGER = 5


end
