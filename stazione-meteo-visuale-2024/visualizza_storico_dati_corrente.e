note
	description: "Summary description for {VISUALIZZA_STORICO_DATI_CORRENTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_STORICO_DATI_CORRENTE

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
	default_create

feature {NONE}-- Initialization

	create_interface_objects
		do
			precursor {FINESTRA_CON_SELEZIONE_NUMERO_DATI}

			create enclosing_box

			create Database_temperature.make
			create Database_pressure.make
			create Database_humidity.make
			create Database_weather.make
		end

	initialize
			-- Build the interface of this window.
		do
			next_y := 30

			window_width := 600
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
			end

feature

	make_top_row
		local
			label: EV_LABEL
			temperature_label: EV_LABEL
			humidity_label: EV_LABEL
			pressure_label: EV_LABEL
		do
			create label
			label.set_text ("n°")
			label.set_foreground_color (Color_text)
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, 10)
			enclosing_box.set_item_y_position (label, 0)

			create temperature_label
			temperature_label.set_text ("Temperatura")
			temperature_label.set_foreground_color (Color_temperature)
			temperature_label.set_font (internal_font)

			enclosing_box.extend (temperature_label)
			enclosing_box.set_item_x_position (temperature_label, 100)
			enclosing_box.set_item_y_position (temperature_label, 0)

			create humidity_label
			humidity_label.set_text ("Umidita'")
			humidity_label.set_foreground_color (Color_humidity)
			humidity_label.set_font (internal_font)

			enclosing_box.extend (humidity_label)
			enclosing_box.set_item_x_position (humidity_label, 300)
			enclosing_box.set_item_y_position (humidity_label, 0)

			create pressure_label
			pressure_label.set_text ("Pressione")
			pressure_label.set_foreground_color (Color_pressure)
			pressure_label.set_font (internal_font)

			enclosing_box.extend (pressure_label)
			enclosing_box.set_item_x_position (pressure_label, 450)
			enclosing_box.set_item_y_position (pressure_label, 0)
			next_y := next_y + 30
		end


	make_row (weather_report: TUPLE)
		require
			correct_number_of_elements: weather_report.count = 4
			correct_format: weather_report[1].conforms_to (1.1)
			correct_temperature_format: weather_report[2].conforms_to (1.1)
			correct_humidity_format: weather_report[2].conforms_to (1.1)
			correct_pressure_format: weather_report[2].conforms_to (1.1)
		local
			label: EV_LABEL
			temperature_label: EV_LABEL
			humidity_label: EV_LABEL
			pressure_label: EV_LABEL

		do
			create label
			label.set_text (weather_report[1].out)
			label.set_foreground_color (Color_text)
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, 10)
			enclosing_box.set_item_y_position (label, next_y)

			create temperature_label
			temperature_label.set_text (weather_report[2].out + unit_of_measurement_temperature)
			temperature_label.set_foreground_color (Color_temperature)
			temperature_label.set_font (internal_font)

			enclosing_box.extend (temperature_label)
			enclosing_box.set_item_x_position (temperature_label, 100)
			enclosing_box.set_item_y_position (temperature_label, next_y)

			create humidity_label
			humidity_label.set_text (weather_report[3].out + unit_of_measurement_humidity)
			humidity_label.set_foreground_color (Color_humidity)
			humidity_label.set_font (internal_font)

			enclosing_box.extend (humidity_label)
			enclosing_box.set_item_x_position (humidity_label, 300)
			enclosing_box.set_item_y_position (humidity_label, next_y)

			create pressure_label
			pressure_label.set_text (weather_report[4].out + unit_of_measurement_pressure)
			pressure_label.set_foreground_color (Color_pressure)
			pressure_label.set_font (internal_font)

			enclosing_box.extend (pressure_label)
			enclosing_box.set_item_x_position (pressure_label, 450)
			enclosing_box.set_item_y_position (pressure_label, next_y)
			next_y := next_y + 30

		end

	add_temperature (a_value: REAL)
		do
			Database_temperature.extend (a_value)
		end

	add_pressure (a_value: REAL)
		do
			Database_pressure.extend (a_value)
		end

	add_humidity (a_value: REAL)
		do
			Database_humidity.extend (a_value)
		end

	make_database_weather
		local
			i: INTEGER
		do
			Database_weather.wipe_out
			i := 1

			from
				Database_temperature.start
				Database_pressure.start
				Database_humidity.start
			until
				Database_temperature.after or Database_pressure.after or Database_humidity.after
			loop
				Database_weather.extend ([i,Database_temperature.item, Database_humidity.item, Database_pressure.item])
				Database_temperature.forth
				Database_pressure.forth
				Database_humidity.forth
				i := i+1
			end

		end

	refresh
		local
			i: REAL
		do
			make_database_weather

			lock_update
			reset_window
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

	reset
		do
			reset_window
			Database_weather.wipe_out
			Database_temperature.wipe_out
			Database_pressure.wipe_out
			Database_humidity.wipe_out
		end

	reset_window
		do
			enclosing_box.wipe_out
			make_top_row
			next_y := 30
		end

feature {NONE} -- Implementation widgets

	enclosing_box: EV_FIXED


feature {NONE} -- Implementation Constants

	Database_temperature: TWO_WAY_LIST[ REAL ]

	Database_pressure: TWO_WAY_LIST[ REAL ]

	Database_humidity: TWO_WAY_LIST[ REAL ]

	Database_weather: TWO_WAY_LIST[ TUPLE ]

	next_y: INTEGER


end
