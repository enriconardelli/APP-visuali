note
	description: "Summary description for {FINESTRA_CON_SELEZIONE_NUMERO_DATI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FINESTRA_CON_SELEZIONE_NUMERO_DATI
inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize
		end

feature {NONE} -- Initialization

	create_interface_objects
		do
			create main_box
			create combo_box
		end

	initialize
		do
			precursor {EV_TITLED_WINDOW}
			disable_user_resize

			max_items_shown := default_items_shown

			build_widgets

			reset

		end

	build_widgets
		local
			i:INTEGER
		do
			extend(main_box)
			main_box.extend_with_position_and_size (combo_box,0,height - 30,100,30)
			combo_box.disable_edit

			from
				i:= 5
			until
				i = 20
			loop
				combo_box.extend (create {EV_LIST_ITEM}.make_with_text (i.out))
				i := i+1
			end

			combo_box.select_actions.extend
				(agent
					do
						max_items_shown := combo_box.selected_item.text.to_integer
					end)
		end

	reset
		deferred
		end

feature {NONE}

	main_box: EV_FIXED

	combo_box: EV_COMBO_BOX

	max_items_shown: INTEGER

	default_items_shown: INTEGER

	Window_width: INTEGER

	Window_height: INTEGER

end
