from flask import Flask, render_template, request
from rules import env

app = Flask(__name__)

@app.route('/')
def hello():
    return render_template('index.html')

@app.route('/performa', methods=['POST'])
def performa():
    if request.method == 'POST':
        env.reset()

        posisi = request.form['posisi']
        lembur = request.form['lembur']
        jam = request.form['jam']

        if (request.form['target'] == "y"):
            target_acquired_assert = """
                (is-target-acquired y)
            """
            env.assert_string(target_acquired_assert)

        if (request.form['target'] == "n"):
            target_acquired_assert = """
                (is-target-acquired n)
            """
            env.assert_string(target_acquired_assert)

        position_input_assert = """
            (position \"{}\")
        """.format(posisi)
        env.assert_string(position_input_assert)

        hari_lembur_assert = """
            (n_hari_lembur {})
        """.format(lembur)
        env.assert_string(hari_lembur_assert)

        jam_lembur_assert = """
            (n_jam_lembur {})
        """.format(jam)
        env.assert_string(jam_lembur_assert)

        env.run()

        facts = dict()
        for fact in env.facts():
            if "salary" in str(fact):
                facts['Salary'] = fact[0]
            
            if "gaji_lembur" in str(fact):
                facts['Gaji Lembur'] = fact[0]

            if "bonus" in str(fact):
                facts['Bonus'] = fact[0]

        if isinstance(facts['Bonus'], float) or isinstance(facts['Bonus'], int):
            facts["Gaji Diterima"] = facts['Salary'] + facts['Gaji Lembur'] + facts['Bonus']
        else:
            facts['Bonus'] = 'Position not eligible for bonus' 
            facts["Gaji Diterima"] = facts['Salary'] + facts['Gaji Lembur']

        print(facts)
        return render_template('hasil.html', facts = facts)