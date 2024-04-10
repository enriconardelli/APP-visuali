note
	description: "Summary description for {NEW_1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_METEO_STORICO

inherit
	FINESTRA_CON_SELEZIONE_NUMERO_DATI
		redefine
			create_interface_objects,
			initialize,
			build_widgets
		end

	STILE_FINESTRE
		undefine
			default_create,
			copy
		end

create
	make_with_temperature,
	make_with_pressure,
	make_with_humidity

feature	-- Creation procedures

		make_with_temperature
			do
				color := Color_temperature
				title_string := "Temperatura"
				unit_of_measurement_string := unit_of_measurement_temperature
				default_create
			end

		make_with_pressure
			do
				color := Color_pressure
				title_string := "Pressione"
				unit_of_measurement_string := unit_of_measurement_pressure
				default_create
			end

		make_with_humidity
			do
				color := Color_humidity
				title_string := "Umidita'"
				unit_of_measurement_string := unit_of_measurement_humidity
				default_create
			end


feature {NONE}-- Initialization

	create_interface_objects
		do
			precursor {FINESTRA_CON_SELEZIONE_NUMERO_DATI}

			create enclosing_box
			create check_button
			create combo_box

			create Database_weather.make
			create Database_current_weather.make
		end

	initialize
			-- Build the interface of this window.
		do
			next_y := 60
			avanzato:= FALSE

			window_width := 220
			window_height := 730
			default_items_shown := 5

			set_size (Window_width, Window_height)

			Precursor {FINESTRA_CON_SELEZIONE_NUMERO_DATI}

		ensure then
			window_size_set: width = Window_width and height = Window_height
		end

		build_widgets
				-- Build GUI elements.
			do
				precursor {FINESTRA_CON_SELEZIONE_NUMERO_DATI}

				main_box.extend (enclosing_box)
				main_box.extend(check_button)
				main_box.set_item_position (check_button, 110, height - 50)
				main_box.set_item_width (check_button, 100)

				check_button.select_actions.extend (agent toggle_avanzate)
				check_button.set_text ("avanzate")
			end

feature

	make_title
		local
			label: EV_LABEL
		do
			create label
			label.set_text (title_string)
			label.set_foreground_color (color)
			label.set_font (internal_font)

			enclosing_box.extend (label)
			if avanzato then
				enclosing_box.set_item_x_position (label, 150)
			else
				enclosing_box.set_item_x_position (label, 40)
			end

			enclosing_box.set_item_y_position (label, 0)
		end

	make_title_row
		local
			label: EV_LABEL
			label2: EV_LABEL
			label3: EV_LABEL
			label4: EV_LABEL
		do
			create label
			label.set_text ("n�")
			label.set_foreground_color (Color_text)
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, firt_column_x_position)
			enclosing_box.set_item_y_position (label, 30)

			create label2
			label2.set_text ("Corrente")
			label2.set_foreground_color (Color_text)
			label2.set_font (internal_font)

			enclosing_box.extend (label2)
			enclosing_box.set_item_x_position (label2, second_column_x_position)
			enclosing_box.set_item_y_position (label2, 30)

			if avanzato then
				create label3
				label3.set_text ("Prevista")
				label3.set_foreground_color (Color_text)
				label3.set_font (internal_font)

				enclosing_box.extend (label3)
				enclosing_box.set_item_x_position (label3, third_column_x_position)
				enclosing_box.set_item_y_position (label3, 30)

				create label4
				label4.set_text ("Media")
				label4.set_foreground_color (Color_text)
				label4.set_font (internal_font)

				enclosing_box.extend (label4)
				enclosing_box.set_item_x_position (label4, fourth_column_x_position)
				enclosing_box.set_item_y_position (label4, 30)
			end

		end

	make_row (weather_report: TUPLE)
		require
			correct_number_of_elements: weather_report.count = 4
			correct_format: weather_report[1].conforms_to (1.1)
			correct_current_format: weather_report[2].conforms_to (1.1)
			correct_forecast_format: weather_report[3].conforms_to (1.1)
			correct_mean_format: weather_report[4].conforms_to (1.1)

		local
			label: EV_LABEL
			sensor_label: EV_LABEL
			forecast_label: EV_LABEL
			mean_label: EV_LABEL
		do
			create label
			label.set_text (weather_report[1].out)
			label.set_foreground_color (Color_text)
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, firt_column_x_position)
			enclosing_box.set_item_y_position (label, next_y)

			create sensor_label
			sensor_label.set_text (weather_report[2].out+ unit_of_measurement_string)
			sensor_label.set_foreground_color (color)
			sensor_label.set_font (internal_font)

			enclosing_box.extend (sensor_label)
			enclosing_box.set_item_x_position (sensor_label, second_column_x_position)
			enclosing_box.set_item_y_position (sensor_label, next_y)

			if avanzato then
				create forecast_label
				forecast_label.set_text (weather_report[3].out + unit_of_measurement_string)
				forecast_label.set_foreground_color (Color_text)
				forecast_label.set_font (internal_font)

				enclosing_box.extend (forecast_label)
				enclosing_box.set_item_x_position (forecast_label, third_column_x_position)
				enclosing_box.set_item_y_position (forecast_label, next_y)

				create mean_label
				mean_label.set_text (weather_report[4].out + unit_of_measurement_string)
				mean_label.set_foreground_color (Color_text)
				mean_label.set_font (internal_font)

				enclosing_box.extend (mean_label)
				enclosing_box.set_item_x_position (mean_label, fourth_column_x_position)
				enclosing_box.set_item_y_position (mean_label, next_y)
			end

			next_y := next_y + 30

		end
	add_weather_report (sensor_data: REAL)

		local
			delta: REAL
			media: REAL
			prev: REAL
		do

			if not Database_current_weather.is_empty   then
				media := (Database_current_weather.last + sensor_data)/2
				delta := sensor_data - Database_current_weather.last

			end

			Database_current_weather.extend (sensor_data)
			prev := previsione(Database_current_weather)
			Database_weather.extend ([Database_weather.count + 1, sensor_data,  prev, media])
		end

	reset
		do
			Database_weather.wipe_out
			enclosing_box.wipe_out
			make_title
			make_title_row
		end

	refresh
		local
			i: REAL
		do
			if not combo_box.is_list_shown then
				lock_update

				enclosing_box.wipe_out
				next_y := 60

				make_title_row
				make_title

				from
					Database_weather.finish
					i := 1
				until
					Database_weather.before or i > max_items_shown
				loop
					make_row(Database_weather.item)
					Database_weather.back
					i := i+1
				end

				unlock_update
			end
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


feature {NONE} -- Implementation GUI


	toggle_avanzate
		do
			if check_button.is_selected then
				avanzato:= TRUE
				Window_width := 450
			else
				avanzato:= FALSE
				Window_width := 220
			end
			refresh

			set_maximum_width (Window_width)
			set_minimum_width (220)
			set_size (Window_width, Window_height)
		end


feature {NONE} -- Implementation widgets

	enclosing_box: EV_FIXED

	horizontal_box: EV_HORIZONTAL_SPLIT_AREA

	check_button: EV_CHECK_BUTTON

feature {NONE} -- Implementation Constants

	avanzato: BOOLEAN

	color: EV_COLOR

	title_string: STRING

	unit_of_measurement_string: STRING

	Database_weather: TWO_WAY_LIST[ TUPLE ]

	Database_current_weather: TWO_WAY_LIST[ REAL ]

	firt_column_x_position: INTEGER = 10

	second_column_x_position: INTEGER = 80

	third_column_x_position: INTEGER = 200

	fourth_column_x_position: INTEGER = 320

	Prevision_number: INTEGER = 5

	next_y: INTEGER

end
