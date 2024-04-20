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
			create_interface_objects,
			initialize,
			is_in_default_state
		end

	INTERFACE_NAMES
		undefine
			default_create,
			copy
		end

	STILE_FINESTRE
		undefine
			default_create,
			copy
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
		do
				-- creo container
			create vertical_box
			create enclosing_box
			create check_button_list

				-- creo oggetti finestre
			create finestra_previsioni
			create finestra_statistiche
			create finestra_meteo_corrente
			create finestra_dati_temperatura.make_with_temperature
			create finestra_dati_pressione.make_with_pressure
			create finestra_dati_umidita.make_with_humidity
			create finestra_dati_meteo
			create finestra_grafico_temperatura
			create finestra_grafico_pressione
			create finestra_grafico_umidita

				-- creo check_button
			create check_button1
			create check_button2
			create check_button3
			create check_button4
			create check_button5
			create check_button6
			create check_button7

				-- creo il timer
			create timer.make_with_interval (2000)
		end

	initialize

			-- Build the interface of this window.
		do
			Precursor {EV_TITLED_WINDOW}

				-- Execute 'close_windows' when the user clicks on the cross in the title bar
			close_request_actions.extend (agent destroy_application)

			set_title (Window_title)
			set_size (Window_width, Window_height)
			set_position (50,30)

			build_windows
			build_widgets

			disable_user_resize
		ensure then
			window_title_set: title.is_equal (Window_title)
			window_size_set: width = Window_width and height = Window_height
		end

feature {NONE} -- Implementation

	build_widgets
			-- Create the GUI elements of this window.
		require
			enclosing_box_not_yet_created: enclosing_box = void
			start_button_not_yet_created: start_button = void
			reset_button_not_yet_created: reset_button = void
		do
				-- Avoid flicker on some platforms
			lock_update

				-- Struttura dei container
			vertical_box.extend (enclosing_box)
			extend (vertical_box)
			vertical_box.extend (check_button_list)

				-- Set checkbox
			check_button1.set_text ("Finestra storico dati corrente")
			check_button2.set_text ("Finestra storico temperatura")
			check_button3.set_text ("Finestra storico umidita'")
			check_button4.set_text ("Finestra storico pressione")
			check_button5.set_text ("Finestra grafico temperatura corrente")
			check_button6.set_text ("Finestra grafico umidita' corrente")
			check_button7.set_text ("Finestra grafico pressione corrente")

			check_button_list.extend(check_button1)
			check_button_list.extend(check_button2)
			check_button_list.extend(check_button3)
			check_button_list.extend(check_button4)
			check_button_list.extend(check_button5)
			check_button_list.extend(check_button6)
			check_button_list.extend(check_button7)

			check_button1.select_actions.extend (agent mostra_finestra(finestra_dati_meteo,check_button1))
			check_button2.select_actions.extend (agent mostra_finestra(finestra_dati_temperatura,check_button2))
			check_button3.select_actions.extend (agent mostra_finestra(finestra_dati_umidita,check_button3))
			check_button4.select_actions.extend (agent mostra_finestra(finestra_dati_pressione,check_button4))
			check_button5.select_actions.extend (agent mostra_finestra(finestra_grafico_temperatura,check_button5))
			check_button6.select_actions.extend (agent mostra_finestra(finestra_grafico_umidita,check_button6))
			check_button7.select_actions.extend (agent mostra_finestra(finestra_grafico_pressione,check_button7))

				-- Add 'start' button primitive
			create start_button.make_with_text ("Esegui misurazioni")
			start_button.select_actions.extend (agent start_actions)
			enclosing_box.extend (start_button)
			enclosing_box.set_item_x_position (start_button, 120)
			enclosing_box.set_item_y_position (start_button, 30)

				-- Add 'reset' button primitive
			create reset_button.make_with_text ("Reset")
			reset_button.select_actions.extend (agent reset_actions)
			reset_button.select_actions.extend (agent reset_finestre)
			enclosing_box.extend (reset_button)
			enclosing_box.set_item_x_position (reset_button, 150)
			enclosing_box.set_item_y_position (reset_button, 90)

				-- Add 'step' button primitive
			create step_button.make_with_text  ("Step")
			step_button.select_actions.extend (agent change_value_once)
			enclosing_box.extend (step_button)
			enclosing_box.set_item_x_position (step_button, 153)
			enclosing_box.set_item_y_position (step_button, 60)
			step_button.hide

				-- Allow screen refresh on some platforms
			unlock_update
		ensure
			enclosing_box_created: enclosing_box /= void
			start_button_created: start_button /= void
			reset_button_created: reset_button /= void
			meteo_corrente_not_void: finestra_meteo_corrente /= Void
			previsioni_meteo_not_void: finestra_previsioni /= Void
			statistiche_not_void: finestra_statistiche /= Void
		end

	start_actions
			-- Start the appropriate actions.
		local
			info_dialog: EV_INFORMATION_DIALOG
		do
				-- Restore initial conditions
			sensor_temperature.event.wipe_out
			sensor_humidity.event.wipe_out
			sensor_pressure.event.wipe_out

			create info_dialog.make_with_text ("Ora inizieranno le misurazioni. Premi 'Pause' per interrompere, 'Reset' per azzerare i contatori, 'Step' per far avanzare le misurazioni di un passo.")
			info_dialog.show_modal_to_window (Current)

				-- Show step button
			step_button.show
			step_button.disable_sensitive

				-- Subscribe to temperature, humidity and pressure in finestra_meteo_corrente
			sensor_temperature.event.subscribe (agent finestra_meteo_corrente.add_temperature(?))
			sensor_humidity.event.subscribe (agent finestra_meteo_corrente.add_humidity(?))
			sensor_pressure.event.subscribe (agent finestra_meteo_corrente.add_pressure(?))

				-- Subscribe to temperature, humidity and pressure in finestra_previsioni
			sensor_temperature.event.subscribe (agent finestra_previsioni.add_temperature(?))
			sensor_humidity.event.subscribe (agent finestra_previsioni.add_humidity(?))
			sensor_pressure.event.subscribe (agent finestra_previsioni.add_pressure(?))

				-- Subscribe to temperature, humidity and pressure in finestra_statistiche
			sensor_temperature.event.subscribe (agent finestra_statistiche.add_temperature(?))
			sensor_humidity.event.subscribe (agent finestra_statistiche.add_humidity(?))
			sensor_pressure.event.subscribe (agent finestra_statistiche.add_pressure(?))

				-- Subscribe to temperature, humidity and pressure in finestra_dati_meteo
			sensor_temperature.event.subscribe (agent finestra_dati_meteo.add_temperature(?))
			sensor_humidity.event.subscribe (agent finestra_dati_meteo.add_humidity(?))
			sensor_pressure.event.subscribe (agent finestra_dati_meteo.add_pressure(?))

				-- Subscribe to temperature, humidity and pressure melle finestre del meteo
			sensor_temperature.event.subscribe (agent finestra_dati_temperatura.add_weather_report(?))
			sensor_humidity.event.subscribe (agent finestra_dati_umidita.add_weather_report(?))
			sensor_pressure.event.subscribe (agent finestra_dati_pressione.add_weather_report(?))

				-- Subscribe to temperature, humidity and pressure nelle finestre dei grafici
			sensor_temperature.event.subscribe (agent finestra_grafico_temperatura.add_weather_report(?))
			sensor_pressure.event.subscribe (agent finestra_grafico_pressione.add_weather_report(?))
			sensor_humidity.event.subscribe (agent finestra_grafico_umidita.add_weather_report(?))

			continue_actions
		end

	pause_actions
			-- Stop the appropriate actions.
		do
				-- Remove actions from timer
			timer.actions.wipe_out

				-- Change button to 'Continue' button
			start_button.select_actions.wipe_out
			start_button.select_actions.extend (agent continue_actions)
			start_button.set_text ("Continue")

			step_button.enable_sensitive
		end

	continue_actions
		do
				-- Add action to the timer
			timer.actions.extend (agent change_value_once)

				-- Change button to 'Pause' button
			start_button.select_actions.wipe_out
			start_button.select_actions.extend (agent pause_actions)
			start_button.set_text ("Pause")

			step_button.disable_sensitive
		end

	reset_actions
			-- Reset contents of all widgets.
		do
			timer.actions.wipe_out

				-- Restore 'start' button to initial conditions
			start_button.select_actions.wipe_out
			start_button.select_actions.extend (agent start_actions)
			start_button.set_text ("Esegui misurazioni")

			step_button.hide
		end


	change_value_once
			-- Change values of `Sensor' object once.
		do
				-- Genero il valore successivo nei sensori
			sensor_temperature.new_value_temperature
			sensor_humidity.new_value_humidity
			sensor_pressure.new_value_pressure

				-- Aggiorno le finestre
			finestra_previsioni.refresh
			finestra_meteo_corrente.refresh
			finestra_statistiche.refresh
			finestra_dati_meteo.refresh
			finestra_dati_temperatura.refresh
			finestra_dati_umidita.refresh
			finestra_dati_pressione.refresh
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
				finestra_meteo_corrente.destroy
				finestra_previsioni.destroy
				finestra_statistiche.destroy
				Application.destroy
			end
		end

feature {NONE} -- Windows management

	build_windows
			-- Create the other windows to be desplayed
		do
				-- Set 'finestra_meteo_corrente' window and show it
			finestra_meteo_corrente.set_position (x_position + window_width + 10, y_position)
			finestra_meteo_corrente.set_title ("Meteo corrente")
			finestra_meteo_corrente.show

				-- Set 'finestra_previsioni' window and show it
			finestra_previsioni.set_position (x_position, y_position + window_height + 25)
			finestra_previsioni.set_title ("Previsioni meteo")
			finestra_previsioni.show

				-- Set 'finestra_statistiche' window and show it
			finestra_statistiche.set_position (x_position + window_width + 10, y_position + window_height + 25)
			finestra_statistiche.set_title ("Statistiche")
			finestra_statistiche.show

				-- Set 'finestra_dati_meteo' window
			finestra_dati_meteo.set_position (x_position + window_width + 450, y_position + window_height)
			finestra_dati_meteo.set_title ("Storico dati corrente")

				-- Set 'finestra_dati_temperatura' window
			finestra_dati_temperatura.set_position (x_position + window_width + 450, y_position + window_height - 350)
			finestra_dati_temperatura.set_title ("Storico temperatura")

				-- Set 'finestra_dati_umidita' window
			finestra_dati_umidita.set_position (x_position + window_width + 700, y_position + window_height - 350)
			finestra_dati_umidita.set_title ("Storico umidita'")

				-- Set 'finestra_dati_pressione' window
			finestra_dati_pressione.set_position (x_position + window_width + 950, y_position + window_height - 350)
			finestra_dati_pressione.set_title ("Storico pressione")

				-- Set 'finestra_grafico_temperatura' window
			finestra_grafico_temperatura.set_position (x_position + window_width + 450, y_position + window_height - 300)
			finestra_grafico_temperatura.set_title ("Grafico temperatura corrente")

				-- Set 'finestra_grafico_pressione' window
			finestra_grafico_pressione.set_position (x_position + window_width + 550, y_position + window_height - 300)
			finestra_grafico_pressione.set_title ("Grafico pressione corrente")

				-- Set 'finestra_grafico_umidita' window
			finestra_grafico_umidita.set_position (x_position + window_width + 650, y_position + window_height - 300)
			finestra_grafico_umidita.set_title ("Grafico umidita' corrente")
		end

	mostra_finestra (finestra : EV_TITLED_WINDOW; tasto : EV_CHECK_BUTTON)
			-- Mostra la 'finestra' se 'tasto' è selezionato
		do
			if tasto.is_selected  then
				finestra.show
			 else
			 	finestra.hide
			end
		end

	reset_finestre
			-- Reset all window to initial conditions
		do
			finestra_meteo_corrente.reset_widget
			finestra_previsioni.reset_widget
			finestra_statistiche.reset_widget

			finestra_meteo_corrente.reset
			finestra_previsioni.reset
			finestra_statistiche.reset
			finestra_dati_temperatura.reset
			finestra_dati_umidita.reset
			finestra_dati_pressione.reset
			finestra_dati_meteo.reset
			finestra_grafico_temperatura.clear
			finestra_grafico_umidita.clear
			finestra_grafico_pressione.clear
		end

feature {NONE} -- Contract checking

	is_in_default_state: BOOLEAN
		do
			Result := True
		ensure then
			ist_in_default_sate: Result = True
		end

feature {NONE} -- Implementation / widgets

	check_button1, check_button2, check_button3, check_button4, check_button5, check_button6, check_button7: EV_CHECK_BUTTON

	vertical_box: EV_VERTICAL_SPLIT_AREA

	check_button_list: EV_VERTICAL_BOX

	enclosing_box: EV_FIXED
			-- Invisible Primitives Container

	start_button: EV_BUTTON
			-- Start button

	reset_button: EV_BUTTON
			-- Reset button

	step_button: EV_BUTTON
			-- Step button	

feature {NONE} -- Finestre

	finestra_meteo_corrente: FINESTRA_CORRENTE
			-- Application window 1

	finestra_previsioni: FINESTRA_PREVISIONE
			-- Application window 2

	finestra_statistiche: FINESTRA_STATISTICHE
			-- Application window 3

	finestra_dati_temperatura: FINESTRA_STORICO_SINGOLO
			-- Application window 4

	finestra_dati_umidita: FINESTRA_STORICO_SINGOLO
			-- Application window 5

	finestra_dati_pressione: FINESTRA_STORICO_SINGOLO
			-- Application window 6

	finestra_dati_meteo: FINESTRA_STORICO_CORRENTE_COMPLETO
			-- Application window 7

	finestra_grafico_temperatura: FINESTRA_GRAFICO
			-- Application window 8

	finestra_grafico_pressione: FINESTRA_GRAFICO
			-- Application window 9

	finestra_grafico_umidita: FINESTRA_GRAFICO
			-- Application window 10

feature {NONE} -- Implementation / Constants

	timer: EV_TIMEOUT
			-- Timer per la pubblicazione di dati

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

	Window_title: STRING = "Event application: main window"
			-- Title of the window

	Window_width: INTEGER = 400
			-- Width of the window

	Window_height: INTEGER = 350
			-- Height of the window

end -- class MAIN_WINDOW
