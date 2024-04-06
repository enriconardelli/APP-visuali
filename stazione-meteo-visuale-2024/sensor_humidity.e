note
	description: "Summary description for {SENSOR_HUMIDITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENSOR_HUMIDITY

inherit

	SENSOR
		rename
			new_value as new_value_humidity
		end

create
	make

feature -- Element change

	new_value_humidity
			-- Change value and publish it
		local
			reale : REAL_64
		do
			reale := floor(15*(sine(0.25*seed + 2)) + 65)
			value := reale.truncated_to_real
			event.publish ([value])
			seed := seed + 1
		end
end --class SENSOR_HUMIDITY
