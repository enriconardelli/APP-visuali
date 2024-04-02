note
	description: "Summary description for {VISUALIZZA_STORICO_DATI_CORRENTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_STORICO_DATI_CORRENTE

inherit
	EV_TITLED_WINDOW
		redefine
			initialize
		end

create
	default_create

feature {NONE}-- Initialization

	initialize
			-- Build the interface of this window.
		do
			Precursor {EV_TITLED_WINDOW}
			set_size (Window_width, Window_height)
			create Database_weather.make
			build_widgets
			next_y := 30

			make_top_row
			disable_user_resize

		ensure then
			window_size_set: width = Window_width and height = Window_height
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
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, 10)
			enclosing_box.set_item_y_position (label, 0)

			create temperature_label
			temperature_label.set_text ("Temperatura")
			temperature_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			temperature_label.set_font (internal_font)

			enclosing_box.extend (temperature_label)
			enclosing_box.set_item_x_position (temperature_label, 100)
			enclosing_box.set_item_y_position (temperature_label, 0)

			create humidity_label
			humidity_label.set_text ("Umidita'")
			humidity_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			humidity_label.set_font (internal_font)

			enclosing_box.extend (humidity_label)
			enclosing_box.set_item_x_position (humidity_label, 300)
			enclosing_box.set_item_y_position (humidity_label, 0)

			create pressure_label
			pressure_label.set_text ("Pressione")
			pressure_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
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
			label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			label.set_font (internal_font)

			enclosing_box.extend (label)
			enclosing_box.set_item_x_position (label, 10)
			enclosing_box.set_item_y_position (label, next_y)

			create temperature_label
			temperature_label.set_text (weather_report[2].out+ "°")
			temperature_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			temperature_label.set_font (internal_font)

			enclosing_box.extend (temperature_label)
			enclosing_box.set_item_x_position (temperature_label, 100)
			enclosing_box.set_item_y_position (temperature_label, next_y)

			create humidity_label
			humidity_label.set_text (weather_report[3].out+ "%%")
			humidity_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			humidity_label.set_font (internal_font)

			enclosing_box.extend (humidity_label)
			enclosing_box.set_item_x_position (humidity_label, 300)
			enclosing_box.set_item_y_position (humidity_label, next_y)

			create pressure_label
			pressure_label.set_text (weather_report[4].out+ " mb")
			pressure_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
			pressure_label.set_font (internal_font)

			enclosing_box.extend (pressure_label)
			enclosing_box.set_item_x_position (pressure_label, 450)
			enclosing_box.set_item_y_position (pressure_label, next_y)
			next_y := next_y + 30

		end

	add_weather_report (weather_report: TUPLE)
		require
			correct_number_of_elements: weather_report.count = 4
			correct_format: weather_report[1].conforms_to (1.1)
			correct_temperature_format: weather_report[2].conforms_to (1.1)
			correct_humidity_format: weather_report[2].conforms_to (1.1)
			correct_pressure_format: weather_report[2].conforms_to (1.1)
		do
			Database_weather.extend (weather_report)
		end

	fill_window
		local
			i: REAL
		do
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
		end

	reset_database
		do
			Database_weather.wipe_out
		end

	reset_window
		do
			enclosing_box.wipe_out
			make_top_row
			next_y := 30
		end


feature {NONE} -- Implementation GUI

	build_widgets
			-- Build GUI elements.
		do
			create enclosing_box
			extend (enclosing_box)

		end


feature {NONE} -- Implementation widgets

	enclosing_box: EV_FIXED


feature {NONE} -- Implementation Constants

	Database_weather: TWO_WAY_LIST[ TUPLE ]

	Window_width: INTEGER = 600

	Window_height: INTEGER = 700

	Font_size_height: INTEGER = 20

	next_y: INTEGER

	max_items_shown: INTEGER = 20

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
