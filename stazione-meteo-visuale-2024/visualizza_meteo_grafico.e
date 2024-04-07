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

			create main_container
			create world

			create buffer.make_with_size (Window_width, Window_height)
			create grafico
			create projector.make_with_buffer (world, buffer, grafico)
			main_container.extend(grafico)
			projector.project
			extend(main_container)

			disable_user_resize

		ensure then
			window_size_set: width = Window_width and height = Window_height
		end


feature

	clear
		do
			world.wipe_out
			Database_weather.wipe_out
			projector.project
		end

	refresh
		local
			i: INTEGER
			place : INTEGER
			massimo: REAL
			minimo: REAL
			temp: REAL
		do
			lock_update

			place := 1
			world.wipe_out
			if Database_weather.count > Number_points then i := Database_weather.count - Number_points + 1
				else i := 1
			end

			massimo := massimo_sensore + 5
			minimo := minimo_sensore - 5
			temp := 1 / ( massimo - minimo )

			from
				Database_weather.go_i_th (i)
			until
				Database_weather.after
			loop
				aggiungi_punto(place  *30, 300 - ((Database_weather.item -  minimo)*300 * temp) , Database_weather.item.out )
				Database_weather.forth
				place := place + 1
			end

			projector.project

			unlock_update
		end


	add_weather_report (sensor_data: REAL)

		do

			Database_weather.extend (sensor_data)
			refresh
		end

	massimo_sensore : REAL
		local
			massimo: REAL
		do
			massimo := Database_weather.first

			from
				Database_weather.start
			until
				Database_weather.after
			loop
				if Database_weather.item > massimo  then
					massimo := Database_weather.item
				end
				Database_weather.forth
			end
			Result := massimo
		end

	minimo_sensore : REAL
		local
			minimo: REAL
		do
			minimo := Database_weather.first

			from
				Database_weather.start
			until
				Database_weather.after
			loop
				if Database_weather.item < minimo  then
					minimo := Database_weather.item
				end
				Database_weather.forth
			end
		Result := minimo
		end

feature {NONE}

	aggiungi_punto (numero_osservazione: REAL; dato_osservato: REAL; label_text: STRING)
		local
			punto: EV_MODEL_DOT
			testo: EV_MODEL_TEXT
		do
			create punto.make_with_position (numero_osservazione.ceiling , dato_osservato.ceiling )
			punto.set_line_width (5)
			world.extend (punto)
			create testo.make_with_position (numero_osservazione.ceiling , dato_osservato.ceiling - 15)
			testo.set_text ( label_text )
			world.extend (testo)
		end


feature {NONE} -- Implementation widgets

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	grafico: EV_DRAWING_AREA

	projector: EV_MODEL_DRAWING_AREA_PROJECTOR

	world: EV_MODEL_WORLD

	buffer: EV_PIXMAP

feature {NONE} -- Implementation Constants	

	Database_weather: LINKED_LIST[ REAL ]

	Window_width: INTEGER = 600

	Window_height: INTEGER = 300

	Font_size_height: INTEGER = 26

	Number_points : INTEGER = 20

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
