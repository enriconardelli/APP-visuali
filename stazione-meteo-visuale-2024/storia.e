note
	description: "Summary description for {STORIA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STORIA

feature -- Gestione liste

	add_temperature (a_value: REAL)
		do
			Database_temperature.extend (a_value)
		end

	add_pressure (a_value: REAL)
		do
			Database_pressure.extend (a_value)
		end

	add_humidity (a_value: REAL)
		do
			Database_humidity.extend (a_value)
		end

feature {NONE} --

	Database_temperature: TWO_WAY_LIST[ REAL ]

	Database_pressure: TWO_WAY_LIST[ REAL ]

	Database_humidity: TWO_WAY_LIST[ REAL ]

end
