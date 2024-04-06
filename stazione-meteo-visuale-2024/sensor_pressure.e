note
	description: "Summary description for {SENSOR_PRESSURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENSOR_PRESSURE

inherit

	SENSOR
		rename
			new_value as new_value_pressure
		end

create
	make

feature -- Element change

	new_value_pressure
			-- Change value and publish it
		local
			reale : REAL_64
		do
			reale := floor(50*(sine(0.15*seed + 1.5)) + 1000)
			value := reale.truncated_to_real
			event.publish ([value])
			seed := seed + 1
		end

end --class SENSOR_PRESSURE
