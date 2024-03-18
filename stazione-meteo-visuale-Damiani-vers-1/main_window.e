note
	description: "MAIN_WINDOW of the sample event application"
	date: "$Date: 2003/01/31"
	revision: "$Revision: 1.0"
	author: "Volkan Arslan"
	institute: "Chair of Software Engineering, ETH Zurich, Switzerland"

-- Questa classe la abbiamo costruita insieme!
class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	default_create

feature {NONE}-- Initialization	

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
		do
			-- Avoid flicker on some platforms
			lock_update

			-- Cover entire window area with a primitive container.
			create enclosing_box
			extend (enclosing_box)

			-- Add 'start' button primitive
			create start_button.make_with_text ("Inizio misurazioni!")
			create exit_button.make_with_text ("ESCI")
			-- per chiudere tutte le windows o si clicca questo bottone oppure
			-- si chiude direttamente con la x della window principale (non sarà
			-- possibile chiudere singolarmente le altre finestre!!)
			start_button.select_actions.extend (agent start_actions)
			exit_button.select_actions.extend (agent destroy_application)

			enclosing_box.extend (start_button)
			enclosing_box.set_item_x_position (start_button, 120)
			enclosing_box.set_item_y_position (start_button, 100)

			enclosing_box.extend (exit_button)
			enclosing_box.set_item_x_position (exit_button, 155)
			enclosing_box.set_item_y_position (exit_button, 150)

			create visualizza_correnti
			create visualizza_previsioni
			create visualizza_statistici
			-- la window che riporta questi dati serve solamente per verificare la correttezza
			-- dei dati relativi della media utilizzata sia per calcolare i dati statistici
			-- che per i dati previsione
			create visualizza_precedenti

			set_x_position (0)
			set_y_position (0)

			visualizza_correnti.set_x_position (x_position + window_width + 10)
			visualizza_correnti.set_y_position (y_position)

			visualizza_previsioni.set_x_position (x_position)
			visualizza_previsioni.set_y_position (y_position + window_height + 10)

			visualizza_statistici.set_x_position (x_position + window_width + 10)
			visualizza_statistici.set_y_position (y_position + window_height + 10)

			visualizza_precedenti.set_x_position (x_position + 2*window_width + 20)
			visualizza_precedenti.set_y_position (y_position + window_height - 80)

			visualizza_correnti.set_title ("WINDOW_1: DATI CORRENTI")
			visualizza_previsioni.set_title ("WINDOW_2: DATI DI PREVISIONE")
			visualizza_statistici.set_title ("WINDOW_3: DATI STATISTICI")
			visualizza_precedenti.set_title ("WINDOW_4: DATI PRECEDENTI")

			visualizza_correnti.show
			visualizza_previsioni.show
			visualizza_statistici.show
			visualizza_precedenti.show

			-- Allow screen refresh on some platforms
			unlock_update
		ensure
			enclosing_box_created: enclosing_box /= void
			start_button_created: start_button /= void
			visualizza_correnti_not_void: visualizza_correnti /= Void
			visualizza_previsioni_not_void: visualizza_previsioni /= Void
			visualizza_statistici_not_void: visualizza_statistici /= Void
			visualizza_precedenti_not_void: visualizza_precedenti /= Void
		end

	start_actions
			-- Start the appropriate actions.
		local
			info_dialog: EV_INFORMATION_DIALOG
		do
			sensore_temp.evento.wipe_out
			sensore_press.evento.wipe_out
			sensore_hum.evento.wipe_out

			sensore_temp.evento.restore_subscription
			sensore_press.evento.restore_subscription
			sensore_hum.evento.restore_subscription

			create info_dialog.make_with_text ("Nella window 1 sono riportati i dati correnti%NNella window 2 sono riportati i dati di previsione%NNella window 3 sono riportati i dati statistici%NNella window 4 sono riportati i dati precedenti%NPremere il pulsante 'stop misurazioni' per sospendere le misurazioni")
			info_dialog.show_modal_to_window (Current)

			-- subscribe to temperature and humidity in 'visualizza_correnti'
			sensore_temp.evento.subscribe (agent visualizza_correnti.set_temperature (?))
			sensore_hum.evento.subscribe (agent visualizza_correnti.set_humidity (?))
			sensore_press.evento.subscribe (agent visualizza_correnti.set_pressure (?))

			-- subscribe to humidity and pressure in 'visualizza_previsioni'
			sensore_temp.evento.subscribe (agent visualizza_previsioni.set_temperature (?))
			sensore_hum.evento.subscribe (agent visualizza_previsioni.set_humidity (?))
			sensore_press.evento.subscribe (agent visualizza_previsioni.set_pressure (?))

			-- subscribe to temperature, humidity and pressure in 'visualizza_statistici'
			sensore_temp.evento.subscribe (agent visualizza_statistici.set_temperature (?))
			sensore_hum.evento.subscribe (agent visualizza_statistici.set_humidity (?))
			sensore_press.evento.subscribe (agent visualizza_statistici.set_pressure (?))

			-- subscribe to temperature and humidity in 'visualizza_precedenti'
			sensore_temp.evento.subscribe (agent visualizza_precedenti.set_temperature (?))
			sensore_hum.evento.subscribe (agent visualizza_precedenti.set_humidity (?))
			sensore_press.evento.subscribe (agent visualizza_precedenti.set_pressure (?))

			-- impostiamo ora nel bottone la scritta 'stop misurazioni',rimuovendo l'azione precedente (cioè 'start misurazioni')
			start_button.set_text ("Stop misurazioni")
			start_button.select_actions.go_i_th (1)
			start_button.select_actions.remove
			start_button.select_actions.extend (agent stop_actions)

			change_values

		end

	stop_actions
			-- Stop the appropriate actions.
		do
			sensore_temp.evento.suspend_subscription
			sensore_hum.evento.suspend_subscription
			sensore_press.evento.suspend_subscription
			start_button.set_text ("Riprendi misurazioni")
			start_button.select_actions.go_i_th (1)
			start_button.select_actions.remove
			start_button.select_actions.extend (agent restart_actions)
		end

	restart_actions
			-- restart the appropriate actions.
			-- nota: riprendendo le misurazioni quest ultime non ripartiranno nè dall inizio
			-- nè dal punto in cui si erano arrestate, ma dai valori del momento.
		do
			sensore_temp.evento.restore_subscription
			sensore_hum.evento.restore_subscription
			sensore_press.evento.restore_subscription
			start_button.set_text ("Stop misurazioni")
			start_button.select_actions.go_i_th (1)
			start_button.select_actions.remove
			start_button.select_actions.extend (agent stop_actions)
		end

	change_values
			-- Change values of `sensore' object.
		local
			i: INTEGER
			j: INTEGER
			k: INTEGER
		do
			from
				i := 27
				j := 55
				k := 1016
			-- Cicla fino a quando non vengono chiuse le finestre	
			until
				is_destroyed
			loop
				-- per evitare che i contratti vengano violati per i valori della temperatura (i)
				-- e dell umidità (j):
				if i > 100 then
					i := 27
					k := 1016
				end
				if j>99 then
					j:=55
				end
				if i \\ 2 = 0 then
					sensore_temp.set_temperatura (i)
				end
				if j \\ 2 = 1 then
					sensore_hum.set_umidita (j)
				end
				if k \\ 3 = 0 then
					sensore_press.set_pressione (k)
				end
				i := i + 1
				j := j + 1
				k := k + 1
				if attached (create {EV_ENVIRONMENT}).application as a then
					a.process_events
				end
				wait
			end
		end

	wait
			-- Wait for `Iterations' before proceeding
			-- Questo ci fornisce l intervallo di tempo tra un ciclo di eventi e un altro
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

	destroy_application
			-- Destroy the application.
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button ~ (create {EV_DIALOG_CONSTANTS}).ev_ok then
					-- Destroy the window.
				destroy

					-- End the application.
					--| TODO: Remove next instruction if you don't want the application
					--|       to end when the first window is closed..
				if attached (create {EV_ENVIRONMENT}).application as a then
					a.destroy
				end
--			if sensore_temp.evento.has (agent visualizza_correnti.set_temperature) then
--				sensore_temp.evento.unsubscribe (agent visualizza_correnti.set_temperature)
--			end
--			if sensore_press.evento.has (agent visualizza_correnti.set_pressure) then
--				sensore_press.evento.unsubscribe (agent visualizza_correnti.set_pressure )
--			end
--			if sensore_hum.evento.has (agent visualizza_correnti.set_humidity) then
--				sensore_hum.evento.unsubscribe (agent visualizza_correnti.set_humidity )
--			end

--			if sensore_temp.evento.has (agent visualizza_previsioni.set_temperature) then
--				sensore_temp.evento.unsubscribe (agent visualizza_previsioni.set_temperature)
--			end
--			if sensore_press.evento.has (agent visualizza_previsioni.set_pressure) then
--				sensore_press.evento.unsubscribe (agent visualizza_previsioni.set_pressure )
--			end
--			if sensore_hum.evento.has (agent visualizza_previsioni.set_humidity) then
--				sensore_hum.evento.unsubscribe (agent visualizza_previsioni.set_humidity )
--			end

--			if sensore_temp.evento.has (agent visualizza_statistici.set_temperature) then
--				sensore_temp.evento.unsubscribe (agent visualizza_statistici.set_temperature)
--			end
--			if sensore_press.evento.has (agent visualizza_statistici.set_pressure) then
--				sensore_press.evento.unsubscribe (agent visualizza_statistici.set_pressure )
--			end
--			if sensore_hum.evento.has (agent visualizza_statistici.set_humidity) then
--				sensore_hum.evento.unsubscribe (agent visualizza_statistici.set_humidity )
--			end

--			if sensore_temp.evento.has (agent visualizza_precedenti.set_temperature) then
--				sensore_temp.evento.unsubscribe (agent visualizza_precedenti.set_temperature)
--			end
--			if sensore_press.evento.has (agent visualizza_precedenti.set_pressure) then
--				sensore_press.evento.unsubscribe (agent visualizza_precedenti.set_pressure )
--			end
--			if sensore_hum.evento.has (agent visualizza_precedenti.set_humidity) then
--				sensore_hum.evento.unsubscribe (agent visualizza_precedenti.set_humidity )
--			end
			visualizza_correnti.destroy
			visualizza_previsioni.destroy
			visualizza_statistici.destroy
			visualizza_precedenti.destroy
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

	exit_button: EV_BUTTON
			-- Exit Button

	visualizza_correnti: VISUALIZZA_DATI_CORRENTI
			-- application window 1

	visualizza_previsioni: VISUALIZZA_DATI_PREVISIONE
			-- application window 2	

	visualizza_statistici: VISUALIZZA_DATI_STATISTICI
			-- application window 3

	visualizza_precedenti: VISUALIZZA_DATI_PRECEDENTI
			-- application window 4

feature {NONE} -- Implementation / Constants

	Application: EV_APPLICATION
			-- Application
		once
			Result :=(create {EV_ENVIRONMENT}).application
		ensure
			application_created: Result /= Void
		end

	sensore_temp: SENSORE_TEMPERATURA
			-- Publisher
		once
 			create Result.make
 		ensure
 			sensore_temp_created: Result /= Void
		end

	sensore_press: SENSORE_PRESSIONE
			-- Publisher
		once
 			create Result.make
 		ensure
 			sensore_press_created: Result /= Void
		end

	sensore_hum: SENSORE_UMIDITA
				-- Publisher
			once
	 			create Result.make
	 		ensure
	 			sensore_hum_created: Result /= Void
			end

	Iterations: INTEGER = 500000
			-- Iterations

	Window_title: STRING = "Event application: main window"
			-- Title of the window

	Window_width: INTEGER = 450
			-- Width of the window

	Window_height: INTEGER = 300
			-- Height of the window

end -- class MAIN_WINDOW
