<div id="version_container">
<div class="btn-tools">
	<a href="javascript:;" class="btn btn-primary" op="version_add">新增</a>
</div>
<table class="table table-bordered" id="dbTable">
  <thead>
    <tr>
      <th>数据库编码</th>
      <th>数据库名称</th>
      <th>版本说明</th>
      <th>备份时间</th>
      <th>备份表总数</th>
      <th>操作</th>
    </tr>
  </thead>
  <tbody>
  	<#if versions?size gt 0>
  	<#list versions as v>
  	<tr mid="${v.ID}">
      <td>${v.DB_CODE}</th>
      <td>${v.DB_NAME}</td>
      <td>${v.DESCR}</td>
      <td>${v.CREATE_DATE}</td>
      <td>${v.COUNT}</td>
      <td>
      	<a href="javascript:;" class="btn btn-sm btn-primary" op="version_view">查看</a>
      	<a href="javascript:;" class="btn btn-sm btn-danger" op="version_del">删除</a>
      </td>
    </tr>
  	</#list>
  	<#else>
  	<tr>
  		<td colspan="6" style="text-align:center;">暂无数据...</td>
  	</tr>
  	</#if>
  </tbody>
</table>
</div>
<div class="template" id="version_template">
	<form>
		<div class="form-group">
	        <label>选择数据库</label>
	        <select class="form-control validate[required]" name="DB_ID">
	        	<#if dbs?size gt 0>
	        	<#list dbs as db>
	        	<option value="${db.ID}">${db.CODE}(${db.NAME})</option>
	        	</#list>
	        	</#if>
	        </select>
	    </div>
	    <div class="form-group">
	        <label>版本说明</label>
	        <textarea class="form-control validate[required]" name="DESCR"></textarea>
	    </div>
    </form>
</div>
<script>
	version.init();
</script>