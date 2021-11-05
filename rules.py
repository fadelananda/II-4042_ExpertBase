import clips

env = clips.Environment()

env.build(
    """
(deffacts pegawai_yang_dapat_diberi_bonus
    (pegawai_bonus "Pemasaran" "Asisten Kepala Toko" "Head Store")
)
    """
)

env.build(
    """
(defrule asisten_kepala_toko_salary
    (position ?x)
    (test(eq "Asisten Kepala Toko" ?x))
=>
    (assert (salary 2500000))
)
    """
)

env.build(
    """
(defrule asisten_kepala_toko_salary
    (position ?x)
    (test(eq "Asisten Kepala Toko" ?x))
=>
    (assert (salary 2500000))
)
    """
)

env.build(
    """
(defrule junior_supervisor_salary
    (position ?x)
    (test(eq "Junior Supervisor" ?x))
=>
    (assert (salary 4000000))
)
    """
)

env.build(
    """
(defrule kasir_salary
    (position ?x)
    (test(eq "Kasir" ?x))
=>
    (assert (salary 4000000))
)
    """
)

env.build(
    """
(defrule pramuniaga_salary
    (position ?x)
    (test(eq "Pramuniaga" ?x))
=>
    (assert (salary 2300000))
)
    """
)

env.build(
    """
(defrule pemasaran_salary
    (position ?x)
    (test(eq "Pemasaran" ?x))
=>
    (assert (salary 8420000))
)
    """
)

env.build(
    """
(defrule head_store_salary
    (position ?x)
    (test(eq "Head Store" ?x))
=>
    (assert (salary 6000000))
)
    """
)

env.build(
    """
(defrule check_target_y
    (target_bonus true)
    (is-target-acquired y)
    (salary ?y)
=>
    (assert (bonus (* ?y 0.02)))
)
    """
)

env.build(
    """
(defrule check_target_n
    (target_bonus true)
    (is-target-acquired n)
    (salary ?y)
=>
    (assert (bonus 0))
)
    """
)

env.build(
    """
(defrule gaji_tidak_lembur
    (n_hari_lembur ?x)
    (n_jam_lembur ?y)
    (test(eq 0 ?x))
=>
    (assert (gaji_lembur 0))
)
    """
)

env.build(
    """
(defrule gaji_lembur_sehari
    (n_hari_lembur ?x)
    (n_jam_lembur ?y)
    (salary ?z)
    (test(and (eq 1 ?x) (not(eq 0 ?y))))
=>
    (assert (gaji_lembur (* ?y 1.5 0.0058 ?z)))
)
    """
)

env.build(
    """
    (defrule gaji_lembur_beberapa_hari
    (n_hari_lembur ?x)
    (n_jam_lembur ?y)
    (salary ?z)
    (test(and (> ?x 1) (> ?y 0)))
=> 
    (assert (gaji_lembur (+ (* ?y 1.5 0.0058 ?z) (* (- ?x 1) ?y 2 0.0058 ?z))))
)
    """
)

env.build(
    """
(defrule show_bonus_if_position_correct
    (position ?pos)
    (pegawai_bonus $?pegbon)
    (test(member$ ?pos ?pegbon))
=>
    (assert(target_bonus true))
)
    """
)

env.build(
    """
(defrule target_bonus_false
    (position ?pos)
    (pegawai_bonus $?pegbon)
    (test(not(member$ ?pos ?pegbon)))
=>
    (assert(target_bonus false))
)
    """
)

if __name__ == "__main__":
    ret = env.reset()

    position_input = input("Masukkan nama posisi: ")
    position_input_assert = """
        (position \"{}\")
    """.format(position_input)
    env.assert_string(position_input_assert)

    hari_lembur_input = input("Masukkan banyak hari lembur: ")
    hari_lembur_assert = """
        (n_hari_lembur {})
    """.format(hari_lembur_input)
    env.assert_string(hari_lembur_assert)

    jam_lembur_input = input("Masukkan banyak jam lembur perhari: ")
    jam_lembur_assert = """
        (n_jam_lembur {})
    """.format(jam_lembur_input)
    env.assert_string(jam_lembur_assert)

    env.run()

    for fact in env.facts():
        print(fact)
