note
	description: "Summary description for {SENSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SENSOR

inherit
	DOUBLE_MATH

feature {NONE} -- Initialization

	make
			-- Create a generic event object.
		do
			create event
		end

feature -- Access

	value: REAL
			-- Sensor value

	seed: INTEGER

feature -- Element change

	new_value
		deferred
		end

feature -- Events

	event: EVENT_TYPE [TUPLE]
			-- Event associated with `event'.

invariant
	event_not_void: event /= Void

end --class SENSOR
