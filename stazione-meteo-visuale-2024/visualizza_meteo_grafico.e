note
	description: "Summary description for {VISUALIZZA_METEO_GRAFICO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VISUALIZZA_METEO_GRAFICO

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
--			build_widgets


			disable_user_resize

		ensure then
			window_size_set: width = Window_width and height = Window_height
		end

	build_widgets
			-- Build GUI elements.
		do
			create main_container
			create world
			create punto.make_with_position (20, 20)
			punto.set_line_width (20)
			world.extend (punto)

			create buffer.make_with_size (100, 100)
			create grafico
			create projector.make_with_buffer (world, buffer, grafico)
			main_container.extend(grafico)
			projector.project

			extend(main_container)

		end

feature


	refresh
		local
			i: INTEGER
		do
			lock_update

			create main_container
			create world



			from
				Database_weather.start
				i := 1
			until
				Database_weather.after or i > 20
			loop
				aggiungi_punto(Database_weather.item.i_th(1) *10, Database_weather.item.i_th (2)*5)
				Database_weather.forth
				i := i+1
			end

			create buffer.make_with_size (Window_width, Window_height)
			create grafico
			create projector.make_with_buffer (world, buffer, grafico)
			main_container.extend(grafico)
			projector.project

			extend(main_container)

			unlock_update
		end


	add_weather_report (sensor_data: REAL)
		local
			a_list: LINKED_LIST [REAL]
		do
			create a_list.make
			a_list.extend (Database_weather.count)
			a_list.extend (sensor_data)
			Database_weather.extend (a_list)
			refresh
		end

feature {NONE}

	aggiungi_punto (numero_osservazione: REAL; dato_osservato: REAL)
		local
			punto1: EV_MODEL_DOT
		do
			create punto1.make_with_position (numero_osservazione.ceiling , dato_osservato.ceiling )
			punto1.set_line_width (5)
			world.extend (punto1)
		end


feature {NONE} -- Implementation widgets

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	grafico: EV_DRAWING_AREA

	projector: EV_MODEL_DRAWING_AREA_PROJECTOR

	world: EV_MODEL_WORLD

	punto: EV_MODEL_DOT

	buffer: EV_PIXMAP

feature {NONE} -- Implementation Constants	

	Database_weather: LINKED_LIST[	LINKED_LIST[REAL] ]

	Window_width: INTEGER = 400

	Window_height: INTEGER = 300

	Font_size_height: INTEGER = 26

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
