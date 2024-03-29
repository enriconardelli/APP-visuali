note
	description: "MAIN_WINDOW of the sample event application"
	date: "$Date: 2003/01/31"
	revision: "$Revision: 1.0"
	author: "Volkan Arslan"
	institute: "Chair of Software Engineering, ETH Zurich, Switzerland"

class
	MAIN_WINDOW

inherit

	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	INTERFACE_NAMES
		undefine
			default_create,
			copy
		end

create
	default_create

feature {NONE} -- Initialization

	initialize

			-- Build the interface of this window.
		do
			Precursor {EV_TITLED_WINDOW}

				-- Execute 'close_windows' when the user clicks on the cross in the title bar
			close_request_actions.extend (agent destroy_application)
			build_widgets
			set_title (Window_title)
			set_size (Window_width, Window_height)
			disable_user_resize
		ensure then
			window_title_set: title.is_equal (Window_title)
			window_size_set: width = Window_width and height = Window_height
		end

feature {NONE} -- Implementation

	build_widgets
			-- Create the GUI elements.
		require
			enclosing_box_not_yet_created: enclosing_box = void
			start_button_not_yet_created: start_button = void
			reset_button_not_yet_created: reset_button = void
		do
				-- Avoid flicker on some platforms
			lock_update

				-- Cover entire window area with a primitive container.
			create enclosing_box
			extend (enclosing_box)

				-- Add 'start' and 'exit' button primitive
			create start_button.make_with_text ("Esegui misurazioni")
			create reset_button.make_with_text ("Reset")
			start_button.select_actions.extend (agent start_actions)
			reset_button.select_actions.extend (agent reset_widgets)
			enclosing_box.extend (start_button)
			enclosing_box.set_item_x_position (start_button, 120)
			enclosing_box.set_item_y_position (start_button, 115)
			enclosing_box.extend (reset_button)
			enclosing_box.set_item_x_position (reset_button, 150)
			enclosing_box.set_item_y_position (reset_button, 200)
			create meteo_corrente
			create previsioni_meteo
			create statistiche
			set_x_position (140)
			set_y_position (40)
			meteo_corrente.set_x_position (x_position + window_width + 10)
			meteo_corrente.set_y_position (y_position)
			previsioni_meteo.set_x_position (x_position)
			previsioni_meteo.set_y_position (y_position + window_height + 25)
			statistiche.set_x_position (x_position + window_width + 10)
			statistiche.set_y_position (y_position + window_height + 25)
			meteo_corrente.set_title ("Meteo corrente")
			previsioni_meteo.set_title ("Previsioni meteo")
			statistiche.set_title ("Statistiche")
			meteo_corrente.show
			previsioni_meteo.show
			statistiche.show

				-- Allow screen refresh on some platforms
			unlock_update
		ensure
			enclosing_box_created: enclosing_box /= void
			start_button_created: start_button /= void
			reset_button_created: reset_button /= void
			meteo_corrente_not_void: meteo_corrente /= Void
			previsioni_meteo_not_void: previsioni_meteo /= Void
			statistiche_not_void: statistiche /= Void
		end

	start_actions
			-- Start the appropriate actions.
		local
			info_dialog: EV_INFORMATION_DIALOG
		do
			sensor_temperature.event.wipe_out
			sensor_humidity.event.wipe_out
			sensor_pressure.event.wipe_out
			restore_all_subscription
			create info_dialog.make_with_text ("Ora inizieranno le misurazioni. Premi 'Pause' per interrompere, 'Reset' per azzerare i contatori.")
			info_dialog.show_modal_to_window (Current)

				-- subscribe to temperature, humidity and pressure in meteo_corrente
			sensor_temperature.event.subscribe (agent meteo_corrente.set_temperature(?))
			sensor_humidity.event.subscribe (agent meteo_corrente.set_humidity(?))
			sensor_pressure.event.subscribe (agent meteo_corrente.set_pressure(?))

				-- subscribe to temperature, humidity and pressure in previsioni_meteo
			sensor_temperature.event.subscribe (agent previsioni_meteo.set_temperature(?))
			sensor_humidity.event.subscribe (agent previsioni_meteo.set_humidity(?))
			sensor_pressure.event.subscribe (agent previsioni_meteo.set_pressure(?))

				-- subscribe to temperature, humidity and pressure in statistiche
			sensor_temperature.event.subscribe (agent statistiche.set_temperature(?))
			sensor_humidity.event.subscribe (agent statistiche.set_humidity(?))
			sensor_pressure.event.subscribe (agent statistiche.set_pressure(?))
			change_values
		end

	pause_actions
			-- Stop the appropriate actions.
		do
			suspend_all_subscription
			start_button.set_text ("Continue")
			start_button.select_actions.go_i_th (1)
			start_button.select_actions.remove
			start_button.select_actions.extend (agent restore_all_subscription)
		end

	suspend_all_subscription
		do
			sensor_temperature.event.suspend_subscription
			sensor_humidity.event.suspend_subscription
			sensor_pressure.event.suspend_subscription
		end

	restore_all_subscription
		do
			sensor_temperature.event.restore_subscription
			sensor_humidity.event.restore_subscription
			sensor_pressure.event.restore_subscription
			start_button.set_text ("Pause")
			start_button.select_actions.go_i_th (1)
			start_button.select_actions.remove
			start_button.select_actions.extend (agent pause_actions)
		end

	change_values
			-- Change values of `Sensor' object.
		local
			i: INTEGER
			--	j: INTEGER
			--	k: INTEGER
		do
			from
				i := 0
					--	j := 0
					--	k := 0
			until
				i > 1000 or is_destroyed
			loop
				sensor_temperature.set_temperature (30 + i)
				sensor_humidity.set_humidity (60 + 2 * i)
				sensor_pressure.set_pressure (720 + 10 * i)
				if sensor_temperature.event.is_suspended = false then
					i := i + 1
						--	j := j + 1
						--	k := k + 1
				end
				Application.process_events
				wait
			end
		end

	wait
			-- Wait for `Iterations' before proceeding
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i = Iterations
			loop
				i := i + 1
			end
		end

	reset_widgets -- Reset contents of all widgets.
		do
			meteo_corrente.reset_widget
			previsioni_meteo.reset_widget
			statistiche.reset_widget
			suspend_all_subscription
			start_button.set_text ("Esegui misurazioni")
			start_button.select_actions.go_i_th (1)
			start_button.select_actions.remove
			start_button.select_actions.extend (agent start_actions)
		end

	destroy_application
			-- Destroy the application.
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)
			if question_dialog.selected_button ~ (create {EV_DIALOG_CONSTANTS}).ev_ok then
				destroy
--					-- unsubscribe to temperature, humidity and pressure in meteo_corrente
--				if sensor_temperature.event.has (agent meteo_corrente.set_temperature) then
--					sensor_temperature.event.unsubscribe (agent meteo_corrente.set_temperature)
--				end
--				if sensor_pressure.event.has (agent meteo_corrente.set_pressure) then
--					sensor_pressure.event.unsubscribe (agent meteo_corrente.set_pressure)
--				end

--					-- unsubscribe to temperature, humidity and pressure in previsioni_meteo
--				if sensor_temperature.event.has (agent previsioni_meteo.set_temperature) then
--					sensor_temperature.event.unsubscribe (agent previsioni_meteo.set_temperature)
--				end
--				if sensor_humidity.event.has (agent previsioni_meteo.set_humidity) then
--					sensor_humidity.event.unsubscribe (agent previsioni_meteo.set_humidity)
--				end
--				if sensor_pressure.event.has (agent previsioni_meteo.set_pressure) then
--					sensor_pressure.event.unsubscribe (agent previsioni_meteo.set_pressure)
--				end

--					-- unsubscribe to temperature, humidity and pressure in statistiche
--				if sensor_temperature.event.has (agent statistiche.set_temperature) then
--					sensor_temperature.event.unsubscribe (agent statistiche.set_temperature)
--				end
--				if sensor_humidity.event.has (agent statistiche.set_humidity) then
--					sensor_humidity.event.unsubscribe (agent statistiche.set_humidity)
--				end
--				if sensor_pressure.event.has (agent statistiche.set_pressure) then
--					sensor_pressure.event.unsubscribe (agent statistiche.set_pressure)
--				end
				meteo_corrente.destroy
				previsioni_meteo.destroy
				statistiche.destroy
				Application.destroy
			end
		end

feature {NONE} -- Contract checking

	is_in_default_state: BOOLEAN
		do
			Result := True
		ensure then
			ist_in_default_sate: Result = True
		end

feature {NONE} -- Implementation / widgets

	enclosing_box: EV_FIXED
			-- Invisible Primitives Container

	start_button: EV_BUTTON
			-- Start button

	reset_button: EV_BUTTON
			-- Reset button

	meteo_corrente: VISUALIZZA_METEO_CORRENTE
			-- application window 1

	previsioni_meteo: VISUALIZZA_METEO_PREVISIONE
			-- application window 2

	statistiche: VISUALIZZA_METEO_STATISTICHE
			-- application window 3

feature {NONE} -- Implementation / Constants

	Application: EV_APPLICATION
			-- Application
		once
			Result := (create {EV_ENVIRONMENT}).application
		ensure
			application_created: Result /= Void
		end

	sensor_temperature: SENSOR_TEMPERATURE
			-- Publisher
		once
			create Result.make
		ensure
			sensor_temperature_created: Result /= Void
		end

	sensor_humidity: SENSOR_HUMIDITY
			-- Publisher
		once
			create Result.make
		ensure
			sensor_humidity_created: Result /= Void
		end

	sensor_pressure: SENSOR_PRESSURE
			-- Publisher
		once
			create Result.make
		ensure
			sensor_pressure_created: Result /= Void
		end

	Iterations: INTEGER = 2000000
			-- Iterations

	Window_title: STRING = "Event application: main window"
			-- Title of the window

	Window_width: INTEGER = 400
			-- Width of the window

	Window_height: INTEGER = 300
			-- Height of the window

end -- class MAIN_WINDOW
