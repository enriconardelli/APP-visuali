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
			set_value as set_pressure
		redefine
			set_pressure
		end

create
	make

feature -- Element change

	set_pressure (a_pressure: REAL)
			-- Set `a_pressure' to `pressure'.
			-- Publish the value change of `pressure'.
		require else
			positive_pressure: a_pressure >= 0
		do
			value := a_pressure
			event.publish ([value])
		ensure then
			value_set: value = a_pressure
		end

end --class SENSOR_PRESSURE
