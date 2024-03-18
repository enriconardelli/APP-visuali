note
	description: "Summary description for {SENSORE_UMIDITA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--Ceccarelli Claudia
class
	SENSORE_UMIDITA

inherit
	SENSORE
	rename
		set_valore as set_umidita
	redefine
		set_umidita
	end

	create make

	feature -- Element change

	set_umidita (a_umidita: REAL_32)
			-- Set `a_umidita' to `valore'.
			-- Publish the value change of `valore'.
		require else
			positive_humidity: a_umidita >= 0
		do
			valore := a_umidita
			evento.publish ([valore])
		ensure then
			valore_set: valore = a_umidita
		end
	end

