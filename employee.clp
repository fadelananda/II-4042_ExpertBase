; Rule based system penilaian performansi pegawai dan bonus

; Fakta list pegawai yang akan menerima pertanyaan target bonus
(deffacts pegawai_yang_dapat_diberi_bonus
    (pegawai_bonus "Pemasaran" "Asisten Kepala Toko" "Head Store")
)

; -------------------- RULES GAJI --------------------
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
=>_
    (assert (salary 8420000))
)

(defrule head_store_salary
    (position ?x)
    (test(eq "Head Store" ?x))
=>
    (assert (salary 6000000))
)


; -------------------- LOGIC RULES --------------------
; Check apakah target memenuhi
(defrule check_target_y
    (target_bonus true)
    (is-target-acquired y)
    (salary ?y)
=>
    (assert (bonus (* ?y 0.02)))
)

; Check apakah target tidak memenuhi
(defrule check_target_n
    (target_bonus true)
    (is-target-acquired n)
    (salary ?y)
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

; -------------------- ASK USER --------------------
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

    ; (printout t 
    ; "Apakah sudah memenuhi target penjualan (y/n): "
    ; )
    ; (assert(is-target-acquired (read)))

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

; Rule untuk memberikan pertanyaan target bonus apabila posisi sudah sesuai
(defrule show_bonus_if_position_correct
    (position ?pos)
    (pegawai_bonus $?pegbon)
    (test(member$ ?pos ?pegbon))
=>
    (printout t 
    "Apakah sudah memenuhi target penjualan (y/n): "
    )
    (assert(is-target-acquired (read)))
    (assert(target_bonus true))
)

; Rule untuk memberikan fakta bahwa posisi tidak mungkin menampilkan pertanyaan target bonus
(defrule target_bonus_false
    (position ?pos)
    (pegawai_bonus $?pegbon)
    (test(not(member$ ?pos ?pegbon)))
=>
    (assert(target_bonus false))
)

; -------------------- SHOW OUTPUT --------------------
; Rule menampilkan salary tanpa bonus
(defrule output_salary_without_bonus
    (salary ?x)
    (gaji_lembur ?z)
    (target_bonus false)
=>
    (printout t 
    "Gaji Pokok: " ?x crlf
    "Gaji lembur :" ?z crlf
    "Gaji Diterima: " (+ ?x ?z) crlf
    )
)

; Rule menamplikan salary dengan bonus
(defrule output_salary_with_bonus
    (salary ?x)
    (bonus ?y)
    (gaji_lembur ?z)
    (target_bonus true)
=>
    (printout t
    "Gaji Pokok: " ?x crlf
    "Bonus: " ?y crlf
    "Gaji lembur: " ?z crlf
    "Gaji Diterima: " (+ ?x ?y ?z) crlf
    )
)