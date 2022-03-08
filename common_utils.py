#coding=utf-8

from ast import IsNot
import binascii
import json
import time

import urllib2
import urllib
import requests

import db
import config

import hashlib

##########################################################################
# 公共


# 只管抛出全部,不管类型;返回字典
def req_gm_router(path, data):
    print("req_gm_router is start")
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


# 施工
def call_gm(server_id, uuid, cmd, args):  # args 字典
    print("is ready to " + cmd)
    data = dict(gm_name=cmd,)
    if server_id:
        data["server_id"] = server_id
    if uuid:
        data["uuid"] = uuid
    args_type = type(args)
    if args_type is dict:
        for key, values in args.items():
            data[key] = values
    elif args_type is str:
        data['name'] = args

    return req_gm_router("do_gm", json.dumps(data))


##########################################################################
# 邮件功能


def role_mail(server_id, title, content, item_list, uid):
    data = dict(
        gm_name='role_mail',
        server_id=server_id,
        uuid_list=[uid],
        title={"chs": title},
        expire_ts=int(time.time()) + 10000000,
    )

    if item_list:
        data['item_list'] = item_list
    if content:
        data['content'] = {"chs": content}

    return req_gm_router("do_gm", json.dumps(data))


def global_mail(server_id, title, content, channel, is_all_channel, item_list, start_ts, end_ts):
    now = int(time.time())
    data = dict(
        gm_name='global_mail',
        server_id=server_id,
        title={"chs": title},
        channel=channel,
        is_all_channel=is_all_channel,
        start_ts=start_ts,
        end_ts=end_ts,

        expire_ts=now + 10000000,
        role_create_ts1=now - 1000000,
        role_create_ts2=now + 1000000,
    )

    if item_list:
        data['item_list'] = item_list
    if content:
        data['content'] = {"chs": content}

    result = req_gm_router("do_gm", json.dumps(data))
    return result

##########################################################################
# 查询功能


# 成功返回空字符， 失败返回错误说明
def check_uuid(uuid_list):
    r = call_gm(None, uuid_list, 'query_uuid', None)
    if(r['code'] != 0):
        return r['err_msg']
    else:
        return None


def call_dev_http():
    data = dict(
        gm_name="query_all_servers",
    )
    return req_gm_router('do_gm',  json.dumps(data))


def query_forbid_login(server_id, uuid):
    data = dict(
        gm_name="query_forbid_login",
        server_id=server_id,
        uuid=uuid,
    )
    return req_gm_router('do_gm',  json.dumps(data))


def query_forbid_speak(server_id, uuid):
    data = dict(
        gm_name="query_forbid_speak",
        server_id=server_id,
        uuid=uuid,
    )
    return req_gm_router('do_gm',  json.dumps(data))


def query_user_info(server_id, uuid):
    data = dict(
        gm_name="query_user_info",
        server_id=server_id,
        uuid=uuid,
    )
    return req_gm_router('do_gm',  json.dumps(data))

##########################################################################
# 日志功能


def push_log(user, page_name, op_name, data):
    import db
    doc = dict(
        uname=user.name,
        page_name=page_name,
        op_name=op_name,
        data=data,
        ts=int(time.time())
    )
    db.insert_one("OpLog", doc)


def query_log(query, **kwargs):
    return [x for x in db.find("OpLog", query, **kwargs)]
