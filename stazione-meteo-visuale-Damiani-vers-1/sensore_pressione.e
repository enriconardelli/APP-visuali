note
	description: "Summary description for {SENSORE_PRESSIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- Benegiamo Andrea
class
	SENSORE_PRESSIONE

inherit
	SENSORE
	rename
		set_valore as set_pressione
	redefine
		set_pressione
	end

	create make

feature -- Element change

	set_pressione (a_pressione: REAL_32)
			-- Set `a_pressione' to `valore'.
			-- Publish the value change of `valore'.
		require else
			positive_pressure: a_pressione >= 0
		do
			valore := a_pressione
			evento.publish ([valore])
		ensure then
			valore_set: valore = a_pressione
		end
	end
