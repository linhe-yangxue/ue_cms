% rebase('base.tpl', child=child, sidemenu='player_mgr')
<link href="static/datetimepicker/css/bootstrap-datetimepicker.css" rel="stylesheet">
<script src="static/datetimepicker/js/bootstrap-datetimepicker.js"></script>
<script src="static/datetimepicker/js/bootstrap-datetimepicker.zh-CN.js"></script>

<div class="panel panel-default">
  <div class="panel-heading">查询玩家角色</div>
  <div class="panel-body">
    <form class="form-horizontal" id="query_player">
      <div class="form-group">
        <label for="zone" class="col-sm-1 control-label">大区</label>
        <div class="col-sm-2">
          <select class="form-control required" id="zone">
          </select>
        </div>

        <label for="server" class="col-sm-1 control-label">服务器</label>
        <div class="col-sm-2">
          <select class="form-control required" id="server">
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="uid" class="col-sm-1 control-label">角色id</label>
        <div class="col-sm-2">
          <input type="text" class="form-control" id="uid" required="required" placeholder="优先使用角色id查询">
        </div>

        <label for="role_name" class="col-sm-1 control-label">角色名字</label>
        <div class="col-sm-2">
          <input type="text" class="form-control" id="" placeholder="选填">
        </div>
      </div>

      <div class="form-group">
        <div class="col-sm-offset-3">
          <button type="submit" class="btn btn-primary" style="padding-left: 30px; padding-right: 30px">查询</button>
        </div>
      </div>
    </form>
  </div>
</div>

<div class="panel panel-default">
  <div class="panel-heading">
    <p>查询结果</p>
  </div>

  <div class="panel-body">
    % if child == "player_forbid":
    <ul class="nav nav-pills">
      <button type="button" class="btn btn-warning navbar-btn" onclick="kick_role();">下线</button>
      <button type="button" class="btn btn-warning navbar-btn" onclick="forbad_role();">封停</button>
      <button type="button" class="btn btn-warning navbar-btn" onclick="remove_forbad_role();">解除封停</button>
      <button type="button" class="btn btn-warning navbar-btn" onclick="forbad_speak();">禁言</button>
      <button type="button" class="btn btn-warning navbar-btn" onclick="remove_forbad_speak();">解除禁言</button>
    </ul>
    % end


    <table class="table table-striped">
      <thead>
        <tr>
          <th style="width: 33%"></th>
          <th style="width: 33%"></th>
          <th style="width: 33%"></th>
        </tr>
      </thead>
      <tbody id="query_result">
        <tr>
          <td>账号：<lable id="account"></lable>
          </td>
          <td>ID：<label id="uuid"></label></td>
          <td>角色名：<label id="name"></label></td>
        </tr>
        <tr>
          <td>职业：<lable id="unit_id"></lable>
          </td>
          <td>等级：<lable id="level"></lable>
          </td>
          <td>战力：<lable id="score"></lable>
          </td>
        </tr>
        <tr>
          <td>王朝：<lable id="union"></lable>
          </td>
          <td></td>
          <td>总帮力：<lable id="gang_score"></lable>
          </td>
        </tr>
        <tr>
          <td>VIP：<label id="vip"></label></td>
          <td></td>
          <td>累积充值：<label id="vip_cost"></label></td>

        </tr>
        <tr>
          <td>经验：<lable id="exp"></lable>
          </td>
          <td>钻石：<lable id="ro_diamond"></lable>
          </td>
          <td>金币：<lable id="ro_coin"></lable>
          </td>
        </tr>
        <tr>
          <td>创建时间：<lable id="create_ts"></lable>
          </td>
          <td>上次登陆：<lable id="role_login_ts"></lable>
          </td>
          <td>是否在线：<label id="is_online"></label></td>
        </tr>
        <tr>
          <td>是否封停：<label id="is_forbad_role"></label></td>
          <td>封停原因：<lable id="forbad_role_reason"></lable>
          </td>
          <td>封停截止时间：<label id="forbad_role_until_ts"></label></td>
        </tr>
        <tr>
          <td>是否禁言：<label id="is_forbad_speak"></label></td>
          <td>禁言原因：<lable id="forbad_speak_reason"></lable>
          </td>
          <td>禁言截止时间：<label id="forbad_speak_until_ts"></label></td>
        </tr>
      </tbody>
    </table>
    </table>
  </div>
</div>


% if child == "player_forbid":
<div class="modal fade" id="dlg_kick" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      </div>
      <div class="modal-body">
        <h2 class="text-center" id="kick_tips"></h2>
        <button class="btn btn-primary btn-block" type="button" id="kick_btn"
          style="width:100px;margin:auto">确定</button>
      </div>
    </div>
  </div><!-- /.modal -->
</div>

<div class="modal fade" id="forbad_role" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3 id="forbad_role_header" class="modal-title">封禁用户</h3>
      </div>
      <div class="modal-body">
        <form id="form_forbad_role" class="form-horizontal">
          <div class="form-group">
            <input type="text" id="inner_forbad_role_reason" class="form-control" placeholder="封禁原因" required>
            <div class="input-group date form_date form-control" id="inner_forbad_role_time" data-date=""
              data-date-format="yyyy/m/d hh:00" data-link-field="dtp_input1" data-link-format="yyyy-mm-dd hh:00">
              <input class="form-control" type="text" value="" placeholder="封禁截止时间(精确到小时)" readonly>
              <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
              <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
            </div>
            <input type="hidden" id="dtp_input1" value="" /><br />
          </div>
          <button class="btn btn-lg btn-primary btn-block" type="submit" style="width:120px;margin:auto">封禁</button>
        </form>
      </div>
    </div>
  </div><!-- /.modal -->
</div>
</div>

<div class="modal fade" id="forbad_speak" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3 id="forbad_speak_header" class="modal-title">禁言用户</h3>
      </div>
      <div class="modal-body">
        <form id="form_forbad_speak" class="form-horizontal">
          <div class="form-group">
            <input type="text" id="inner_forbad_speak_reason" class="form-control" placeholder="封禁原因" required>
            <div class="input-group date form_date form-control" id="inner_forbad_speak_time" data-date=""
              data-date-format="yyyy/m/d hh:00" data-link-field="dtp_input1" data-link-format="yyyy-mm-dd hh:00">
              <input class="form-control" size="16" type="text" value="" placeholder="禁言截止时间(精确到小时)" readonly>
              <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
              <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
            </div>
            <input type="hidden" id="dtp_input1" value="" /><br />
          </div>
          <button class="btn btn-lg btn-primary btn-block" type="submit" style="width:120px;margin:auto">禁言</button>
        </form>
      </div>
    </div>
  </div><!-- /.modal -->
</div>
</div>

% end

<!-- 初始化设置 -->
<script type="text/javascript">
  $(document).ready(function () {
    $('.form_date').datetimepicker({
      language: 'zh-CN',
      weekStart: 1,
      todayBtn: 1,
      autoclose: 1,
      todayHighlight: 1,
      startView: 1,
      minView: 1,
      maxView: 2,
      forceParse: 0,
    });
  });
</script>


<!-- 查询角色 -->
<script type="text/javascript">
  var zone_list;

  /********************大区,服务器部分********************/
  function on_zone_change() {
    $("#server").find("option").remove()
    var name = $("#zone").val()
    // console.log(zone_list) //测试
    $.each(zone_list, function (key, values) {
      var zone = values;
      if (zone.name == name) {
        var option = '<option server_id="' + zone.id + '">' + zone.id + "</option>"
        // console.log(zone.id,zone.name) //测试
        $("#server").append(option);
      }
    })
  }

  //全局加载
  $(document).ready(function () {
    $.ajax({
      type: "POST",
      url: "/query_zone",
      dataType: 'json',
      success: function (msg) {
        zone_list = msg.zone_list;
        $.each(zone_list, function (key, values) {
          $("#zone").append("<option>" + values.name + "</option>");
        })
        on_zone_change();
      }
    });

    $("#zone").change(on_zone_change);

    /***************** 大区,服务器部分 END *****************/

    $("#query_player").submit(function () {
      event.preventDefault();

      var server_id = $("#server").find(":selected").attr("server_id");
      var name = $("#role_name").val();
      var uid = $("#uid").val();

      // console.log(server_id, name, uid); //测试

      $("#query_result").addClass("hidden")
      $.ajax({
        type: "POST",
        url: "/query_player",
        data: { name: name, server_id: server_id, uid: uid },
        dataType: 'json',
        success: function (msg) {
          toastr.options.positionClass = 'toast-top-center';
          if (msg.err) {
            toastr.error(msg.err);
            return;
          }

          // console.log(msg)

          $("#query_result").removeClass("hidden")
          $("#query_result").find("#account").html(msg.info.account);
          $("#query_result").find("#uuid").html(msg.info.uuid);
          $("#query_result").find("#gang_score").html(msg.info.score);
          $("#query_result").find("#union").html(msg.info.uuid);  // 空
          $("#query_result").find("#name").html(msg.info.name);
          $("#query_result").find("#unit_id").html(msg.info.unit_id);
          $("#query_result").find("#score").html(msg.info.fight_score);
          $("#query_result").find("#level").html(msg.info.level);
          $("#query_result").find("#vip").html(msg.info.vip);
          $("#query_result").find("#vip_cost").html(msg.info.vip_cost);
          $("#query_result").find("#exp").html(msg.info.exp);
          $("#query_result").find("#ro_diamond").html(msg.info.diamond);
          $("#query_result").find("#ro_coin").html(msg.info.coin);
          $("#query_result").find("#create_ts").html(new Date(msg.info.create_ts * 1000).format("yyyy-MM-dd EE HH:mm:ss"));
          $("#query_result").find("#role_login_ts").html(new Date(msg.info.role_login_ts * 1000).format("yyyy-MM-dd EE HH:mm:ss"));

          if (msg.info.login == 1) {
            $("#query_result").find("#is_online").html("在线")
          }
          else {
            $("#query_result").find("#is_online").html("离线")
          }
          // var now = Math.round(new Date().getTime() / 1000)

          // 封停;forbid_login
          if (msg.info.forbid_login == 'False') {
            $("#query_result").find("#is_forbad_role").html("被封停")
          } else {
            $("#query_result").find("#is_forbad_role").html("正常")
          }
          $("#query_result").find("#forbad_role_reason").html(msg.info.forbid_login_reason)
          if (msg.info.forbid_login_end_ts) {
            $("#query_result").find("#forbad_role_until_ts").html(new Date(msg.info.forbid_login_end_ts * 1000).format("yyyy-MM-dd EE HH:mm:ss"));
          } else {
            $("#query_result").find("#forbad_role_until_ts").html('');
          }
          // 备用
          // if (msg.info.hasOwnProperty('forbid_login_end_ts')) {
          //   $("#query_result").find("#forbad_role_until_ts").html(new Date(msg.info.forbid_speak_end_ts * 1000).format("yyyy-MM-dd EE HH:mm:ss"));
          // }
          // if (msg.info.hasOwnProperty('forbid_login_reason')) {
          //   $("#query_result").find("#forbad_role_reason").html(msg.info.forbid_speak_reason)
          // }


          // 禁言;forbid_speak
          if (msg.info.forbid_speak == 'False') {
            $("#query_result").find("#is_forbad_speak").html("被禁言")
          } else {
            $("#query_result").find("#is_forbad_speak").html("正常")
          }
          $("#query_result").find("#forbad_speak_reason").html(msg.info.forbid_speak_reason)
          if (msg.info.forbid_speak_end_ts) {
            $("#query_result").find("#forbad_speak_until_ts").html(new Date(msg.info.forbid_speak_end_ts * 1000).format("yyyy-MM-dd EE HH:mm:ss"));
          } else {
            $("#query_result").find("#forbad_speak_until_ts").html("");
          }
          // 备用
          // if (msg.info.hasOwnProperty('forbid_speak_reason')) {
          //   $("#query_result").find("#forbad_speak_reason").html(msg.info.forbid_login_reason)
          // }
          // if (msg.info.hasOwnProperty('forbid_speak_end_ts')) {
          //   $("#query_result").find("#forbad_speak_until_ts").html(new Date(msg.info.forbid_login_end_ts * 1000).format("yyyy-MM-dd EE HH:mm:ss"));
          // }
        }
      });
    })
  })
</script>

% if child == "player_forbid":
<script type="text/javascript">
  function kick_role() {
    var uuid = $("#query_result").find("#uuid").html();
    var server_id = $("#server").find(":selected").attr("server_id");
    console.log(uuid, server_id)

    if (uuid == "") {
      return;
    }
    // var tips = "是否要踢" + uuid + ", " + name + "下线？"
    var tips = "是否要踢" + server_id + "," + uuid + "下线？"

    if ($("#query_result").find("#is_online").html() == "离线") {
      toastr.error("玩家不在线");
      return;
    }
    $('#kick_tips').html(tips);
    $('#kick_btn').unbind('click');
    $('#kick_btn').click(function () {
      $('#dlg_kick').modal('hide')
      $.ajax({
        type: "POST",
        url: "/kick_role",
        data: { uuid: uuid, server_id: server_id },
        dataType: 'json',
        success: function (msg) {
          toastr.options.positionClass = 'toast-top-center';
          if (msg.err) {
            toastr.error(msg.err);
            return;
          }
          toastr.success("操作成功！")
          $("#query_result").find("#is_online").html("离线")
        }
      });
    })
    $('#dlg_kick').modal('show')
  }


  // 封禁
  function forbad_role() {
    var uuid = $("#query_result").find("#uuid").html();
    var server_id = $("#server").find(":selected").attr("server_id");
    console.log(uuid, server_id)

    if (uuid == "") {
      return;
    }
    $('#forbad_role').modal('show')
    $('#form_forbad_role').unbind('submit');
    $('#form_forbad_role').submit(function () {
      event.preventDefault()
      var forbad_reason = $("#inner_forbad_role_reason").val()
      var forbad_until_time_stamp = Date.parse($('#inner_forbad_role_time').data().date).toString();
      var forbad_until_time = forbad_until_time_stamp.substr(0, forbad_until_time_stamp.length - 3);
      if (forbad_until_time == null || forbad_until_time == "") {
        toastr.options.positionClass = 'toast-top-center';
        toastr.error("请选择封禁截止时间");
        return;
      }
      $.ajax({
        type: "POST",
        url: "/forbad_role",
        data: { server_id: server_id, uuid: uuid, forbad_reason: forbad_reason, forbad_until_time: forbad_until_time },
        dataType: 'json',
        success: function (msg) {
          toastr.options.positionClass = 'toast-top-center';
          if (msg.err) {
            toastr.error(msg.err);
            return;
          }
          toastr.success("操作成功")
          $("#query_result").find("#is_forbad_role").html("被封停")
          $("#query_result").find("#forbad_role_reason").html(forbad_reason)
          $("#query_result").find("#forbad_role_until_ts").html(new Date(forbad_until_time * 1000).format("yyyy-MM-dd EE HH:mm:ss"))
        }
      });
      $('#form_forbad_role')[0].reset() //cal Dom's reset
      $('#forbad_role').modal('hide')
    })
  }

  function remove_forbad_role() {
    var uuid = $("#query_result").find("#uuid").html();
    var server_id = $("#server").find(":selected").attr("server_id");
    console.log(uuid, server_id)

    if (uuid == "") {
      return;
    }
    var tips = "是否要对玩家" + server_id + ", " + uuid + "解封？"
    $('#kick_tips').html(tips);
    $('#kick_btn').unbind('click');
    $('#kick_btn').click(function () {
      $('#dlg_kick').modal('hide')
      $.ajax({
        type: "POST",
        url: "/remove_forbad_role",
        data: { uuid: uuid, server_id: server_id },
        dataType: 'json',
        success: function (msg) {
          toastr.options.positionClass = 'toast-top-center';
          if (msg.err) {
            toastr.error(msg.err);
            return;
          }
          toastr.success("操作成功！")
          $("#query_result").find("#is_forbad_role").html("正常")
          $("#query_result").find("#forbad_role_reason").html("")
          $("#query_result").find("#forbad_role_until_ts").html("")
        }
      });
    })
    $('#dlg_kick').modal('show')
  }

  function forbad_speak() {
    var uuid = $("#query_result").find("#uuid").html();
    var server_id = $("#server").find(":selected").attr("server_id");
    console.log(uuid, server_id)

    if (uuid == "") {
      return;
    }
    var tips = "是否对玩家" + server_id + ", " + uuid + "禁言？"
    $('#forbad_speak').modal('show')
    $('#form_forbad_speak').unbind('submit');
    $('#form_forbad_speak').submit(function () {
      event.preventDefault()
      var forbad_reason = $("#inner_forbad_speak_reason").val()
      var forbad_until_time_stamp = Date.parse($('#inner_forbad_speak_time').data().date).toString();
      var forbad_until_time = forbad_until_time_stamp.substr(0, forbad_until_time_stamp.length - 3);
      if (forbad_until_time == null || forbad_until_time == "") {
        toastr.options.positionClass = 'toast-top-center';
        toastr.error("请选择禁言截止时间");
        return;
      }
      $.ajax({
        type: "POST",
        url: "/forbad_speak",
        data: { uuid: uuid, server_id: server_id, forbad_reason: forbad_reason, forbad_until_time: forbad_until_time },
        dataType: 'json',
        success: function (msg) {
          toastr.options.positionClass = 'toast-top-center';
          if (msg.err) {
            toastr.error(msg.err);
            return;
          }
          toastr.success("操作成功")
          $("#query_result").find("#is_forbad_speak").html("被禁言")
          $("#query_result").find("#forbad_speak_reason").html(forbad_reason)
          $("#query_result").find("#forbad_speak_until_ts").html(new Date(forbad_until_time * 1000).format("yyyy-MM-dd EE HH:mm:ss"))
        }
      });
      $('#form_forbad_speak')[0].reset() // cal Dom's reset
      $('#forbad_speak').modal('hide')
    })
  }

  function remove_forbad_speak() {
    var uuid = $("#query_result").find("#uuid").html();
    var server_id = $("#server").find(":selected").attr("server_id");
    console.log(uuid, server_id)

    if (uuid == "") {
      return;
    }
    var tips = "是否要对玩家" + server_id + ", " + uuid + "解除禁言？"
    $('#kick_tips').html(tips);
    $('#kick_btn').unbind('click');
    $('#kick_btn').click(function () {
      $('#dlg_kick').modal('hide')
      $.ajax({
        type: "POST",
        url: "/remove_forbad_speak",
        data: { uuid: uuid, server_id: server_id },
        dataType: 'json',
        success: function (msg) {
          toastr.options.positionClass = 'toast-top-center';
          console.log(msg.err)

          if (msg.err) {
            toastr.error(msg.err);
            return;
          }
          toastr.success("操作成功！")
          $("#query_result").find("#is_forbad_speak").html("正常")
          $("#query_result").find("#forbad_speak_reason").html("")
          $("#query_result").find("#forbad_speak_until_ts").html("")
        }
      });
    })
    $('#dlg_kick').modal('show')
  }

</script>
% end