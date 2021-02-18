#!/usr/bin/python3

""" Simple Goss based Status page

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

import os
import json
from flask import Flask, render_template, request, session

app = Flask(__name__)


@app.route('/')
def status():
    try:
        content_json = os.popen('goss  --vars /goss/vars.yaml  -g /goss/goss.yaml validate -f json   -o pretty')
        content = json.load(content_json)
        content_ordered = sorted(content["results"], key=lambda k: k['resource-id'])
        return render_template("status.html", content=content_ordered)
    except Exception as e:
        raise ValueError(e)




@app.errorhandler(Exception)
def handle_exception(e):
    print(e)
    return render_template("error.html", error=e), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', use_debugger=True)
