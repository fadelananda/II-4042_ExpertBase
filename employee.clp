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

(defrule kasir_salary
    (position ?x)
    (test(eq "Kasir" ?x))
=>
    (assert (salary 4000000))
)

(defrule pramuniaga_salary
    (position ?x)
    (test(eq "Pramuniaga" ?x))
=>
    (assert (salary 2300000))
)

(defrule pemasaran_salary
    (position ?x)
    (test(eq "Pemasaran" ?x))
=>
    (assert (salary 8420000))
)

(defrule head_store_salary
    (position ?x)
    (test(eq "Head Store" ?x))
=>
    (assert (salary 6000000))
)
; Rule menampilkan salary
(defrule output_salary
    (salary ?x)
    (bonus ?y)
    (gaji_lembur ?z)
=>
    (printout t 
    "Gaji Pokok: " ?x crlf
    "Bonus: " ?y crlf
    "Gaji lembur :" ?z crlf
    "Gaji Diterima: " (+ ?x ?y ?z) crlf
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

; Check tidak lembur
(defrule gaji_tidak_lembur
    (n_hari_lembur ?x)
    (n_jam_lembur ?y)
    (test(eq 0 ?x))
=>
    (assert (gaji_lembur 0))
)

; Check lembur sehari
(defrule gaji_lembur_sehari
    (n_hari_lembur ?x)
    (n_jam_lembur ?y)
    (salary ?z)
    (test(and (eq 1 ?x) (not(eq 0 ?y))))
=>
    (assert (gaji_lembur (* ?y 1.5 0.0058 ?z)))
)

; Check lembur beberapa hari
(defrule gaji_lembur_beberapa_hari
    (n_hari_lembur ?x)
    (n_jam_lembur ?y)
    (salary ?z)
    (test(and (> ?x 1) (> ?y 0)))
=> 
    (assert (gaji_lembur (+ (* ?y 1.5 0.0058 ?z) (* (- ?x 1) ?y 2 0.0058 ?z))))
)

; Rule menampilkan pilihan
(defrule read_input
=>
    (printout t
    "Posisi:" crlf
    "1. Asisten Kepala Toko" crlf
    "2. Junior Supervisor" crlf
    "3. Kasir" crlf
    "4. Pramuniaga" crlf
    "5. Pemasaran" crlf
    "6. Head Store" crlf
    "Masukkan nama posisi (ex:\"Kasir\"): ")
    (assert(position (read)))

    (printout t 
    "Apakah sudah memenuhi target penjualan (y/n): "
    )
    (assert(is-target-acquired (read)))

    (printout t
    "Masukkan banyak hari lembur: "
    )
    (assert(n_hari_lembur (read)))

    (printout t
    "Masukkan banyak jam lembur perhari: "
    )
    (assert(n_jam_lembur (read)))

    (printout t
    ""
    )
)