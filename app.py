#!/usr/bin/python3

""" ProxyWeb - A Proxysql Web user interface

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.
"""

__author__ = "Miklos Mukka Szel"
__contact__ = "miklos.szel@edmodo.com"
__license__ = "GPLv3"

from collections import defaultdict
from flask import Flask, render_template, request, session

import mdb

app = Flask(__name__)

config = "config/config.yml"


db = defaultdict(lambda: defaultdict(dict))

# read/apply the flask config from the config file
flask_custom_config = mdb.get_config(config)
for key in flask_custom_config['flask']:
    app.config[key] = flask_custom_config['flask'][key]


# mdb.logging.debug("###########section: {}".format(section))

@app.route('/')
def render_list_dbs():
    try:
        session.clear()
        server = mdb.get_config(config)['global']['default_server']
        session['server'] = server
        session['dblist'] = mdb.get_all_dbs_and_tables(db, server)
        session['servers'] = mdb.get_servers()
        session['read_only'] = mdb.get_read_only(server)

        return render_template("list_dbs.html", server=server)
    except Exception as e:
        raise ValueError(e)

@app.route('/<server>/')
@app.route('/<server>/<database>/<table>/')
def render_show_table_content(server, database="main", table="global_variables"):
    try:
        # refresh the tablelist if changing to a new server

        if server not in session['dblist']:
            session['dblist'].update(mdb.get_all_dbs_and_tables(db, server))

        session['servers'] = mdb.get_servers()
        session['server'] = server
        session['table'] = table
        session['database'] = database
        session['read_only'] = mdb.get_read_only(server)
        content = mdb.get_table_content(db, server, database, table)
        return render_template("show_table_info.html", content=content)
    except Exception as e:
        raise ValueError(e)

@app.route('/<server>/<database>/<table>/sql/', methods=['GET', 'POST'])
def render_change(server, database, table):
    try:
        error = ""
        message = ""
        session['sql'] = request.form["sql"]
        ret = mdb.execute_change(db, server, session['sql'])
        if "ERROR" in ret:
            error = ret
        else:
            message = "Success"

        content = mdb.get_table_content(db, server, database, table)
        return render_template("show_table_info.html", content=content, error=error, message=message)
    except Exception as e:
        raise ValueError(e)

@app.route('/<server>/adhoc/')
def adhoc_report(server):
    try:

        adhoc_results = mdb.execute_adhoc_report(db, server)
        return render_template("show_adhoc_report.html", adhoc_results=adhoc_results)
    except Exception as e:
        raise ValueError(e)


@app.route('/settings/<action>/', methods=['GET', 'POST'])
def render_settings(action):
    try:
        config_file_content = ""
        message = ""
        if action == 'edit':
            with open(config, "r") as f:
                config_file_content = f.read()
        if action == 'save':
            # back it up first
            with open(config, "r") as src, open(config + ".bak", "w") as dest:
                dest.write(src.read())

            with open(config, "w") as f:
                f.write(request.form["settings"])
            message = "success"
        return render_template("settings.html", config_file_content=config_file_content, message=message)
    except Exception as e:
        raise ValueError(e)


@app.errorhandler(Exception)
def handle_exception(e):
    print(e)
    return render_template("error.html", error=e), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', use_debugger=False)
