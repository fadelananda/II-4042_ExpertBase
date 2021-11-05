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

        position_input_assert = """
            (position \"{}\")
        """.format(request.form['posisi'])
        env.assert_string(position_input_assert)

        hari_lembur_assert = """
            (n_hari_lembur {})
        """.format(request.form['lembur'])
        env.assert_string(hari_lembur_assert)

        jam_lembur_assert = """
            (n_jam_lembur {})
        """.format(request.form['jam'])
        env.assert_string(jam_lembur_assert)

        env.run()

        return render_template('test.html', facts = env.facts())