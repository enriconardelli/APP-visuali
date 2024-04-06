note
	description: "Summary description for {SENSOR_TEMPERATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENSOR_TEMPERATURE

inherit

	SENSOR
		rename
			new_value as new_value_temperature
		end

create
	make

feature -- Element change

	new_value_temperature
			-- Change value and publish it
		local
			reale : REAL_64
		do
			reale := floor((15*sine(0.2*seed) + 15)*10)/10
			value := reale.truncated_to_real
			event.publish ([value])
			seed := seed + 1
		end

end --class SENSOR_TEMPERATURE
