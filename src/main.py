# !/usr/bin/python
import psycopg2
import json
from configparser import ConfigParser
from flask import Flask, request
from flask_httpauth import HTTPBasicAuth
from flask_restful import Api

app = Flask(__name__)
auth = HTTPBasicAuth()
api = Api(app)


@auth.verify_password
def verify_password(username, password):
    if username == 'apitimestorage' and password == '_@P1t1m3$t0r4g3##/':
        return True
    else:
        return False


@app.route('/')
def index():
    conn = connect()
    cur = conn.cursor()
    cur.execute('SELECT version()')
    db_version = cur.fetchone()
    close(conn)
    return '<h3>API TimeStorage Running!</h3><h4>PostgreSQL DB Version: ' + str(db_version) + '</h4>'


@app.route('/pessoa', methods=['GET'])
@auth.login_required
def pessoa():
    query = "SELECT * FROM v_pessoa"
    result = query_db(query, False)
    return json.dumps(result)


@app.route('/login', methods=['POST'])
def login():
    if not request.json:
        return 'Não há dados em JSON no corpo da request!', 400
    data = request.get_json()
    email = data['email']
    senha = data['senha']
    if email is None or senha is None:
        return 'Dados de e-mail ou senha não podem ser vazios!', 400
    query = "SELECT fn_login('" + email + "', '" + senha + "')"
    result = query_db(query, False)
    return json.dumps(result)


def query_db(query, one=False):
    conn = connect()
    cur = conn.cursor()
    cur.execute(query)
    r = [dict((cur.description[i][0], value) \
              for i, value in enumerate(row)) for row in cur.fetchall()]
    close(conn)
    return (r[0] if r else None) if one else r


def config(filename='util/database.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))

    return db


def connect():
    try:
        params = config()
        conn = psycopg2.connect(**params)
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)


def close(conn):
    if conn is not None:
        conn.close()


if __name__ == '__main__':
    app.run()
