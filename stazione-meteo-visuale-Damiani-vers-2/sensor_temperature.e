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
			set_value as set_temperature
		redefine
			set_temperature
		end

create
	make

feature -- Element change

	set_temperature (a_temperature: REAL)
			-- Set `a_temperature' to `temperature'.
			-- Publish the value change of `temperature'.
			-- Publish the value change of `temperature'.
		require else
			valid_temperature: a_temperature > -100 and a_temperature < 1000
		do
			value := a_temperature
			event.publish ([value])
		ensure then
			value_set: value = a_temperature
		end

end --class SENSOR_TEMPERATURE
