note
	description: "Summary description for {SENSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SENSOR

feature {NONE} -- Initialization

	make
			-- Create a generic event object.
		do
			create event
		end

feature -- Access

	value: REAL
			-- Container event

feature -- Element change

	set_value (a_value: REAL)
			-- Set `a_value' to `value'.
			-- Publish the value change of `event'.
		do
			value := a_value
			event.publish ([value])
		ensure
			value_set: value = a_value
		end

feature -- Events

	event: EVENT_TYPE [TUPLE [REAL]]
			-- Event associated with `event'.

invariant
	event_not_void: event /= Void

end --class SENSOR
