note
	description: "Summary description for {SENSORE_TEMPERATURA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- Ceccarelli Claudia
class
	SENSORE_TEMPERATURA

inherit
	SENSORE
	rename
		set_valore as set_temperatura
	redefine
		set_temperatura
	end

	create make

	feature -- Element change

	set_temperatura (a_temperatura: REAL_32)
			-- Set `a_temperatura' to `valore'.
			-- Publish the value change of `valore'.
		require else
			valid_temperature: a_temperatura > -100 and a_temperatura < 1000
		do
			valore := a_temperatura
			evento.publish ([valore])
		ensure then
			valore_set: valore = a_temperatura
		end
	end
