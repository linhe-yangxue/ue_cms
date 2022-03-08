#!/usr/bin/env python
# -*- coding: utf-8 -*-

from crypt import methods
import json
import time

from bottle import route, template, redirect
from bottle import request, response

import user_manager
from user_manager import check_user

import view_utils
import common_utils


################################player query###############################
PNAME_1 = "玩家查询"


@route('/view_player_query')
@check_user("player_query")
def view_player_query(user):
    all_group = user_manager.get_all_group()
    all_group.sort(key=lambda v: v.num)
    return template("player_query", curr_user=user, child="player_query", **(view_utils.all_funcs))


@route('/query_zone', method="POST")
# @check_user("player_query/player_forbid")
def query_zone():
    print("is query zone info")
    result = common_utils.call_dev_http()['data']
    msg = dict(
        zone_list=result,
    )
    return json.dumps(msg)


@route('/query_player', method="POST")
# @check_user("player_query/player_forbid")
def query_player():
    # get values
    name = request.params.get("name")
    uid = request.params.get("uid")
    server_id = request.params.get("server_id")
    server_id = int(server_id)

    if not uid and not name:
        return {"err": "查询条件为空"}
    else:
        cmdList = dict(
            query_role_level='query_role_level'
        )
        info = dict(
            name=name,
            uuid=uid,
        )

        ######################################################
        # 请以后及时更改

        for cmd in cmdList.values():
            result = common_utils.call_gm(server_id, uid, cmd, name)
            if result['code'] is 0:
                for key, values in result['data'].items():
                    if key == 'name':
                        continue
                    else:
                        info[key] = str(values)
            else:
                return {"err": result["err_msg"]}

        ######################################################
        # 要改
        rlogin = common_utils.query_forbid_login(server_id, uid)
        if rlogin['code'] is 0:
            for key, values in rlogin['data'].items():
                info['forbid_login_' + key] = values
        else:
            return {"err": rlogin["err_msg"]}

        rspeak = common_utils.query_forbid_speak(server_id, uid)
        if rspeak['code'] is 0:
            for key, values in rlogin['data'].items():
                info['forbid_speak_' + key] = values
        else:
            return {"err": rspeak["err_msg"]}

        rinfo = common_utils.query_user_info(server_id, uid)
        if rinfo['code'] is 0:
            for key, values in rinfo['data'].items():
                info[key] = values
        else:
            return {"err": rinfo["err_msg"]}

        print(info)
        return json.dumps({'info': info})


################################player forbid###############################
PNAME_2 = "封禁解封"


@route('/view_player_forbid')
@check_user("player_forbid")
def view_player_forbid(user):
    all_group = user_manager.get_all_group()
    all_group.sort(key=lambda v: v.num)
    return template("player_query", curr_user=user, child="player_forbid", **(view_utils.all_funcs))


@route('/kick_role', method='post')
@check_user("player_forbid")
def kick_role(user):
    uuid = request.params.get("uuid")
    server_id = request.params.get("server_id")

    if not uuid:
        return {"err": "uuid为空"}
    result = common_utils.call_gm(server_id, uuid, "kick_role", None)
    if result["code"] == 0:
        common_utils.push_log(user, PNAME_2, "踢下线:", str(uuid)+str(server_id))
        return {"info": 'True'}
    else:
        return {"err": result["err_msg"]}


@route('/forbad_role', method='post')
@check_user("player_forbid")
def forbad_role(user):
    uuid = request.params.get("uuid")
    server_id = request.params.get("server_id")
    forbad_until_time = request.params.get("forbad_until_time")

    if not uuid:
        return {"err": "uuid为空"}

    args = dict(
        # forbad_reason=forbad_reason,
        duration=forbad_until_time,
    )
    result = common_utils.call_gm(server_id, uuid, "forbid_login", args)
    if result["code"] == 0:
        common_utils.push_log(user, PNAME_2, "封禁:", str(server_id)+str(uuid)+"; 截止时间:" +
                              time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(int(forbad_until_time))))
        return {"info": result["data"]}
    else:
        return {"err": result["err_msg"]}


@route('/remove_forbad_role', method='post')
@check_user("player_forbid")
def remove_forbad_role(user):
    uuid = request.params.get("uuid")
    server_id = request.params.get("server_id")

    if not uuid:
        return {"err": "uuid为空"}
    result = common_utils.call_gm(server_id, uuid, "undo_forbid_login", None)
    if result["code"] == 0:
        common_utils.push_log(user, PNAME_2, "解封登陆",
                              "%s %s" % (uuid, server_id))
        return {"info": result["data"]}
    else:
        return {"err": result["err_msg"]}


@route('/forbad_speak', method='post')
@check_user("player_forbid")
def forbad_speak(user):
    uuid = request.params.get("uuid")
    server_id = request.params.get("server_id")
    forbad_until_time = request.params.get("forbad_until_time")

    args = dict(
        # forbad_reason=forbad_reason,
        duration=forbad_until_time,
    )
    result = common_utils.call_gm(server_id, uuid, "forbid_speak", args)
    if result["code"] == 0:
        common_utils.push_log(user, PNAME_2, "禁言:", str(server_id)+str(uuid)+"; 截止时间:" +
                              time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(int(forbad_until_time))))
        return {"info": result["data"]}
    else:
        return {"err": result["err_msg"]}


@route('/remove_forbad_speak', method='post')
@check_user("player_forbid")
def remove_forbad_speak(user):
    uuid = request.params.get("uuid")
    server_id = request.params.get("server_id")

    if not uuid:
        return {"err": "uuid为空"}
    result = common_utils.call_gm(server_id, uuid, "undo_forbid_speak", None)
    if result["code"] == 0:
        common_utils.push_log(user, PNAME_2, "解封禁言",
                              "%s %s" % (uuid, server_id))
        return {"info": result["data"]}
    else:
        return {"err": result["err_msg"]}


############################### player level ###############################
PNAME_3 = "经验查询"


@route('/view_player_level')
@check_user("level_query")
def view_player_query(user):
    # all_group = user_manager.get_all_group()
    # all_group.sort(key=lambda v: v.num)
    return template("level_query", curr_user=user, **(view_utils.all_funcs))


@route('/add_role_exp', method="POST")
@check_user("level_query")
def add_role_exp(user):
    # get values
    server_id = request.params.get("server_id")
    uuid = request.params.get("uuid")
    exp = request.params.get("exp")
    print(server_id, uuid, exp)

    args = dict(count=exp,)
    res = common_utils.call_gm(server_id, uuid, "add_role_exp", args)
    if res['code'] == 0:
        return {'info': res["data"]}
    else:
        return {'err': res["err_msg"]}


@route('/delete_role_exp', method="POST")
@check_user("level_query")
def delete_role_exp(user):
    # get values
    server_id = request.params.get("server_id")
    uuid = request.params.get("uuid")
    exp = request.params.get("exp")
    print(server_id, uuid, exp)

    args = dict(count=exp,)
    res = common_utils.call_gm(server_id, uuid, "delete_role_exp", args)
    if res['code'] == 0:
        return {'info': res["data"]}
    else:
        return {'err': res["err_msg"]}


@route('/set_role_level', method="POST")
@check_user("level_query")
def set_role_level(user):
    # get values
    server_id = request.params.get("server_id")
    uuid = request.params.get("uuid")
    level = request.params.get("level")
    print(server_id, uuid, level)

    args = dict(level=level,)
    res = common_utils.call_gm(server_id, uuid, "set_role_level", args)
    if res['code'] == 0:
        return {'info': res["data"]}
    else:
        return {'err': res["err_msg"]}
