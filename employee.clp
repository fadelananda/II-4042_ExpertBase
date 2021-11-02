; Rule based system penilaian performansi pegawai dan bonus

; Rule untuk salary pegawai Indomaret
(defrule asisten_kepala_toko_salary
    (position ?x)
    (test(eq "Asisten Kepala Toko" ?x))
=>
    (assert (salary 2500000))
)

(defrule junior_supervisor_salary
    (position ?x)
    (test(eq "Junior Supervisor" ?x))
=>
    (assert (salary 4000000))
)

(defrule kasir
    (position ?x)
    (test(eq "Kasir" ?x))
=>
    (assert (salary 8000000))
)

; Rule menampilkan salary
(defrule output_salary
    (salary ?x)
    (bonus ?y)
=>
    (printout t 
    "Gaji Pokok: " ?x crlf
    "Bonus: " ?y crlf
    "Gaji Diterima: " (+ ?x ?y) crlf
    )
)

; Check apakah target memenuhi
(defrule check_target_y
    (is-target-acquired ?x)
    (salary ?y)
    (test(eq y ?x))
=>
    (assert (bonus (* ?y 0.02)))
)

; Check apakah target tidak memenuhi
(defrule check_target_n
    (is-target-acquired ?x)
    (salary ?y)
    (test(eq n ?x))
=>
    (assert (bonus 0))
)

; Rule menampilkan pilihan
(defrule read_input
=>
    (printout t
    "Posisi:" crlf
    "1. Asisten Kepala Toko" crlf
    "2. Junior Supervisor" crlf
    "3. Kasir" crlf
    "Masukkan nama posisi (ex:\"Kasir\"): ")
    (assert(position (read)))

    (printout t 
    "Apakah sudah memenuhi target penjualan (y/n): "
    )
    (assert(is-target-acquired (read)))

    (printout t
    ""
    )
)