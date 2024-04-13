note
	description: "Summary description for {FUNZ_STATISTICHE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FUNZ_STATISTICHE

inherit
	STORIA
feature -- Implementazione funzione per una statistica

	media (a_database: TWO_WAY_LIST[ REAL ] ): REAL
			-- fa la media degli ultimi 'mean_number' valori
		require
			not a_database.is_empty
		local
			n: INTEGER
			mean: REAL
			i: INTEGER
		do
			if a_database.count <= mean_number then
				n := a_database.count
			else
				n := mean_number
			end


		 	from
		 		mean := 0
		 		i := 1
		 	until
		 		i > n
		 	loop
		 		mean := mean + a_database[a_database.count - n + i]
		 		i := i+1
		 	end

			mean := mean/n

			Result := mean
	end


feature {NONE} -- Implementation Constants 	

	mean_number: INTEGER = 2

end
