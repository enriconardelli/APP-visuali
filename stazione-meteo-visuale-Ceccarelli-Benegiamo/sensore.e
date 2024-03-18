note
	description: "Summary description for {SENSORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- Benegiamo andrea
deferred class
	SENSORE

feature {NONE} -- Initialization

	make
			-- Create all necessary event objects.
		do
			create evento
		end

feature -- Access

	valore: REAL_32
			-- Container temperature	

feature -- Element change

	set_valore (a_valore: REAL_32)
			-- Set `a_valore' to `valore'.
			-- Publish the value change of `valore'.
		do
			valore := a_valore
			evento.publish ([valore])
		ensure
			valore_set: valore = a_valore
		end

feature -- Events

	evento: EVENT_TYPE [TUPLE [REAL_32]]
			-- Event associated with `valore'.

invariant

	evento_not_void: evento /= Void

end
