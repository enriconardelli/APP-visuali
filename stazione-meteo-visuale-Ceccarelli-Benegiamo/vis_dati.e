note
	description: "Summary description for {VIS_DATI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- Benegiamo Andrea
deferred class
	VIS_DATI
inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

feature {NONE}
	temperatura: REAL
          -- contiene il valore della temperatura ricevuto
	umidita : REAL
          -- contiene il valore dell'umidità ricevuto
	pressione : REAL
          -- contiene il valore della pressione ricevuto

feature {NONE}-- Initialization

	initialize
			-- Build the interface of this window.
		do
			Precursor {EV_TITLED_WINDOW}
			set_size (Window_width, Window_height)
			build_widgets
--			disable_user_resize
		ensure then
--			window_size_set: width = Window_width and height = Window_height
		end

	build_widgets
		deferred
		end
	display_temperature
		deferred
		end
	display_humidity
		deferred
		end
	display_pressure
		deferred
		end
feature {NONE} -- Contract checking

	is_in_default_state: BOOLEAN
		do
			Result := True
		end

feature -- Display update

	set_temperature (a_temperature: REAL_32)
			-- Update the text of `temperature_value_label' with `a_temperature'.
		do
			temperatura := a_temperature
			display_temperature
		ensure
			temperatura = a_temperature
		end

	set_humidity (a_humidity: REAL_32)
			-- Update the text of `humidity_value_label' with `a_humidity'.
		do
			umidita := a_humidity
			display_humidity
		ensure
			umidita = a_humidity
		end

	set_pressure (a_pressure: REAL_32)
			-- Update the text of `pressure_value_label' with `a_pressure'.	
		do
			pressione := a_pressure
			display_pressure
		ensure
			pressione = a_pressure
		end

feature {NONE} -- Implementation widgets

	enclosing_box: EV_FIXED
			-- Invisible Primitives Container

	temperature_label: EV_LABEL
			-- Temperature label

	humidity_label: EV_LABEL
			-- Humidity label

	pressure_label: EV_LABEL
			-- Pressure label

	temperature_value_label: EV_LABEL
			-- Temperature value label

	humidity_value_label: EV_LABEL
			-- Humidity value label

	pressure_value_label: EV_LABEL
			-- Pressure value label	

feature {NONE} -- Implementation Constants	

	Window_width: INTEGER = 450

	Window_height: INTEGER = 300

	Font_size_height: INTEGER = 26

	Dash: STRING = "-"

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
