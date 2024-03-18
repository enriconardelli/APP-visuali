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
			set_value as set_humidity
		redefine
			set_humidity
		end

create
	make

feature -- Element change

	set_humidity (a_humidity: REAL)
			-- Set `a_humidity' to `humidity'.
			-- Publish the value change of `humidity'.
		require else
			positive_humidity: a_humidity >= 0
		do
			value := a_humidity
			event.publish ([value])
		ensure then
			value_set: value = a_humidity
		end

end --class SENSOR_HUMIDITY
