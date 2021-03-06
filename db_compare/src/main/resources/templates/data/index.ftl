<style>
	.wrap {
		    word-break: break-all;
	}
	.nowrap {
		white-space: nowrap;
	}
</style>
<div id="data_container">
	<div class="btn-tools">
		<a href="javascript:;" class="btn btn-primary" op="data_add">新增</a>
		<a href="javascript:;" class="btn btn-warning" op="data_batch_export">批量导出</a>
		<a href="javascript:;" class="btn btn-info" op="data_db">切换数据库</a>
		<span style="color:red;">
			<#if db??>
			当前数据库: ${db.NAME}(${db.CODE})
			<input type="hidden" id="db" value="${db.ID}">
			<#else>
			请先选择数据库
			</#if>
		</span>
	</div>
	<table class="table table-bordered" id="dataTable">
	  <thead>
	    <tr>
	      <th width="60px">
	      	<input type="checkbox" name="chkAll">
	      </th>
	      <th>表名</th>
	      <th>SQL片段</th>
	      <th>操作</th>
	    </tr>
	  </thead>
	  <tbody>
	  	<#if tables?size gt 0>
	  	<#list tables as table>
	  	<tr mid="${table.ID}" type="${table.TYPE}">
	  	  <td>
	  	  	<input type="checkbox" name="chk">
	  	  </td>
	      <td>${table.TABLE_NAME}</th>
	      <td class="wrap">${table.SQL}</td>
	      <td class="nowrap">
	      	<a href="javascript:;" class="btn btn-sm btn-primary" op="export">脚本</a>
	      	<a href="javascript:;" class="btn btn-sm btn-info" op="edit">修改</a>
	      	<a href="javascript:;" class="btn btn-sm btn-danger" op="del">删除</a>
	      </td>
	    </tr>
	  	</#list>
	  	<#else>
	  	<tr>
	  		<td colspan="4" style="text-align:center;">暂无数据...</td>
	  	</tr>
	  	</#if>
	  </tbody>
	</table>
</div>
<div class="template" id="db_template">
	<div class="form-group">
        <label>请选择数据库</label>
        <select class="form-control" name="ID">
        <#list dbs as d>
        <option value="${d.ID}" <#if (db??) && (db.ID == d.ID)>selected="selected"</#if> >${d.NAME}(${d.CODE})</option>
        </#list>
        </select>
    </div>
</div>
<div class="template" id="data_template">
<form>
    <div class="form-group">
        <label>表名</label>
        <input type="hidden" name="ID">
        <input class="form-control validate[required]" name="TABLE_NAME">
    </div>
    <div class="form-group">
        <label>类型</label>
        <select class="form-control validate[required]" name="TYPE">
        	<option value="table">表</table>
        	<option value="view">视图</table>
        </select>
    </div>
    <div class="form-group">
        <label>SQL脚本</label>
        <textarea class="form-control" name="SQL" rows="10"></textarea>
    </div>
</form>
</div>
<script>
	data.init();
</script>