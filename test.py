#!/usr/bin/python
# -*- coding:utf-8 -*-

# from bottle import request, response
# from bottle import run, route, template, redirect, static_file
# import common_utils
# import config
# import user_manager
import time
# import datetime
# import os.path
# import json
# import urllib2
# import urllib
# import binascii
# import hashlib
# import requests

# import gevent
# import gevent.monkey
# gevent.monkey.patch_all()


#######################################################################################


def req_gm_router(path, data):
    ip = config.gm_router_ip
    port = config.gm_router_port
    url = "http://%s:%d/%s" % (ip, port, path)
    ts = int(time.time())
    key = '8dFACTRDdNiAiYv6pV046UfJ147RzE37'
    md5 = hashlib.md5()
    md5.update('ts=%s&key=%s&data=%s' % (ts, key, data))
    sign = md5.hexdigest()
    r = requests.post(url, json={"data": data, "ts": ts, "sign": sign})
    result = json.loads(r.text)
    return result


def call_gm(cmd):
    print("gm_name = "+cmd)
    now = int(time.time())
    data = dict(
        server_id=55,
        content="test msg 22点55分",
        start_ts=now+2,
        end_ts=now+1000000,
        interval=1,

        gm_name=cmd,
        # server_id=55,
        # uuid=55000018,
        # count=200,          # 经验
        # level=30,    # 等级
    )

    return req_gm_router("do_gm", json.dumps(data))


# res = call_gm('set_role_level')
# res = call_gm('add_role_exp')
# res = call_gm('delete_role_exp')

# res = call_gm('add_roll_notice')

# print(res)

now = int(time.time())
print(now)
