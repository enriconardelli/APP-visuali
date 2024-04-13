note
	description: "Summary description for {FUNZ_PREVISIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FUNZ_PREVISIONE

inherit
	STORIA

feature -- Implementazione funzione per una previsione

	previsione (a_database: TWO_WAY_LIST[ REAL ] ): REAL
			-- fa la previsione del valore futuro sulla base della retta ai minimi quadrati degli ultimi 'Prevision_number' valori
		local
			mediax: REAL
			mediay: REAL
			x_times_y: REAL
			x_square: REAL
			beta: REAL
			alpha: REAL
			i: INTEGER
			n: INTEGER
		do
			if
				a_database.count > 1
			then

				if
					a_database.count <= Prevision_number
				then
					n := a_database.count
				else
					n := Prevision_number
				end



				mediax := (n.to_real +1)/2

			 	from
			 		mediay := 0
			 		i := 1
			 	until
			 		i > n
			 	loop
			 		mediay := mediay + a_database[a_database.count - n + i]
			 		i := i+1
			 	end
				mediay := mediay/n

				from
					x_times_y := 0
					x_square := 0
					i := 1
				until
					i > n
				loop
					x_times_y := x_times_y + (i - mediax)*(a_database[a_database.count - n + i] - mediay)
					x_square := x_square + (i - mediax)*(i-mediax)
			 		i := i+1
				end

				beta:= x_times_y/x_square
				alpha := mediay - (beta * mediax)

				Result := alpha + (beta*(n.to_real +1))
			else
				Result := a_database[1]
			end
		end

feature {NONE} -- Implementation Constants 	

	Prevision_number: INTEGER = 5

end
