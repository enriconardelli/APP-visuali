note
	description: "Summary description for {NEW_1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_METEO_STORICO

inherit
	EV_TITLED_WINDOW
		redefine
			initialize
		end
create
	make_with_temperature,
	make_with_pressure,
	make_with_humidity

feature	-- Creation procedures

		make_with_temperature
			do
				create color.make_with_8_bit_rgb (255, 0, 0)
				title_string := "Temperatura"
				unit_of_measurement_string := "°"
				default_create
			end

		make_with_pressure
			do
				create color.make_with_8_bit_rgb (0, 255, 0)
				title_string := "Pressione"
				unit_of_measurement_string := "mb"
				default_create
			end

		make_with_humidity
			do
				create color.make_with_8_bit_rgb (0, 0, 255)
				title_string := "Umidita'"
				unit_of_measurement_string := "%%"
				default_create
			end


feature {NONE}-- Initialization

	initialize
			-- Build the interface of this window.
		do
			Precursor {EV_TITLED_WINDOW}

			create Database_weather.make
			create Database_current_weather.make
			build_widgets

			next_y := 60
			avanzato:= FALSE
			max_items_shown := 20
			window_width := 220

			set_size (Window_width, Window_height)

			make_title_row
			make_title
			disable_user_resize


		ensure then
			window_size_set: width = Window_width and height = Window_height
		end

		build_widgets
				-- Build GUI elements.
			local
				i: INTEGER
			do
				create vertical_box
				create enclosing_box
				create horizontal_box
				create check_button.make_with_text("avanzate")
				create combo_box
				create elemento_lista.make_with_text ("2")

				extend (vertical_box)
				vertical_box.extend (enclosing_box)
				vertical_box.extend (horizontal_box)
				vertical_box.set_split_position (window_height - 30)
				horizontal_box.extend (combo_box)
				horizontal_box.extend(check_button)
				horizontal_box.set_split_position (130)
				check_button.select_actions.extend (agent toggle_avanzate)

				combo_box.disable_edit

				from
					i:= 5
				until
					i = 20
				loop
					combo_box.extend (create {EV_LIST_ITEM}.make_with_text (i.out))
					i := i+1
				end

				combo_box.select_actions.extend (agent refresh)
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
			label.set_text ("n°")
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, firt_column_x_position)
			enclosing_box.set_item_y_position (label, 30)

			create label2
			label2.set_text ("Corrente")
			label2.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			label2.set_font (internal_font)

			enclosing_box.extend (label2)
			enclosing_box.set_item_x_position (label2, second_column_x_position)
			enclosing_box.set_item_y_position (label2, 30)

			if avanzato then
				create label3
				label3.set_text ("Prevista")
				label3.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
				label3.set_font (internal_font)

				enclosing_box.extend (label3)
				enclosing_box.set_item_x_position (label3, third_column_x_position)
				enclosing_box.set_item_y_position (label3, 30)

				create label4
				label4.set_text ("Media")
				label4.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
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
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
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
				forecast_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
				forecast_label.set_font (internal_font)

				enclosing_box.extend (forecast_label)
				enclosing_box.set_item_x_position (forecast_label, third_column_x_position)
				enclosing_box.set_item_y_position (forecast_label, next_y)

				create mean_label
				mean_label.set_text (weather_report[4].out + unit_of_measurement_string)
				mean_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
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
			previsione: REAL
		do
			if not Database_current_weather.is_empty   then
				media := (Database_current_weather.last + sensor_data)/2
				delta := sensor_data - Database_current_weather.last
				previsione := media + delta
			end

			Database_current_weather.extend (sensor_data)
			Database_weather.extend ([Database_weather.count + 1, sensor_data,  previsione, media])
		end

	reset
		do
			Database_weather.wipe_out
			enclosing_box.wipe_out
			make_title
			next_y := 30
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

				max_items_shown := combo_box.selected_text.to_integer

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


feature {NONE} -- Implementation GUI


	toggle_avanzate
		do
			if check_button.is_selected then
				avanzato:= TRUE
				refresh
				Window_width := 450
			else
				avanzato:= FALSE
				refresh
				Window_width := 220
			end

			set_size (Window_width, Window_height)
		end


feature {NONE} -- Implementation widgets

	vertical_box: EV_VERTICAL_SPLIT_AREA

	enclosing_box: EV_FIXED

	horizontal_box: EV_HORIZONTAL_SPLIT_AREA

	check_button: EV_CHECK_BUTTON

	combo_box: EV_COMBO_BOX

	elemento_lista: EV_LIST_ITEM

feature {NONE} -- Implementation Constants

	avanzato: BOOLEAN

	color: EV_COLOR

	title_string: STRING

	unit_of_measurement_string: STRING

	Database_weather: TWO_WAY_LIST[ TUPLE ]

	Database_current_weather: TWO_WAY_LIST[ REAL ]

	Window_width: INTEGER

	Window_height: INTEGER = 730

	Font_size_height: INTEGER = 20

	max_items_shown: INTEGER

	firt_column_x_position: INTEGER = 10

	second_column_x_position: INTEGER = 80

	third_column_x_position: INTEGER = 200

	fourth_column_x_position: INTEGER = 320

	next_y: INTEGER


	internal_font: EV_FONT
			-- Internal font used by various widgets
		once
			create Result.make_with_values ({EV_FONT_CONSTANTS}.Family_sans, {EV_FONT_CONSTANTS}.Weight_regular, {EV_FONT_CONSTANTS}.Shape_regular, Font_size_height)
		ensure
			internal_font_created: Result /= Void
			font_family_set_to_family_sans: Result.family = {EV_FONT_CONSTANTS}.Family_sans
			font_weight_set_to_weight_regular: Result.weight = {EV_FONT_CONSTANTS}.Weight_regular
			font_shape_set_to_shape_regular: Result.shape = {EV_FONT_CONSTANTS}.Shape_regular
			font_height_set_to_font_size_height: Result.height = Font_size_height
		end
end
