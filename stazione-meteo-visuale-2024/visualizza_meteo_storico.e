note
	description: "Summary description for {NEW_1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VISUALIZZA_METEO_STORICO

inherit
	EV_TITLED_WINDOW
		redefine
			initialize
		end


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
		deferred
		end


	make_row (weather_report: TUPLE)
		require
			correct_number_of_elements: weather_report.count = 2
			correct_format: weather_report[1].conforms_to (1.1)
			correct_temperature_format: weather_report[2].conforms_to (1.1)
		deferred

		end

	add_weather_report (sensor_data: REAL)
		do
			Database_weather.extend ([Database_weather.count + 1, sensor_data])
		end

	reset
		do
			Database_weather.wipe_out
			enclosing_box.wipe_out
			make_top_row
			next_y := 30
		end

	refresh
		do
			lock_update

			enclosing_box.wipe_out
			next_y := 30

			make_top_row
			from
				Database_weather.finish
			until
				Database_weather.before
			loop
				make_row(Database_weather.item)
				Database_weather.back
			end

			unlock_update
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

	Window_width: INTEGER = 250

	Window_height: INTEGER = 600

	Font_size_height: INTEGER = 20

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
