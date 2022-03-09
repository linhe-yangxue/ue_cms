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
