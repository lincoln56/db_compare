package com.service;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bean.Worker;
import com.core.IDbCompartor;
import com.core.VersionProcessor;
import com.domain.ColumnInfo;
import com.util.DbUtil;
import com.util.SpringUtil;

/**
 * 比较服务
 * @author MX
 *
 */
@Service
public class CompareService {
	
	@Autowired
	private VersionProcessor processor;
	
	private static transient Log log = LogFactory.getLog(CompareService.class);
	
	/**
	 * 创建版本
	 * @author MX
	 * @date 2016年3月19日 下午6:55:13
	 * @param dbid
	 * @param descr
	 * @throws Exception
	 */
	@Transactional
	public void createVersion(String dbid,String descr)throws Exception {
		Map<String, Object> db = DbUtil.queryRow("SELECT * FROM DB WHERE ID = ?", dbid);
		if(db == null){
			return;
		}
		String type = (String)db.get("TYPE");
		String driver = (String)db.get("DRIVER");
		String url = (String)db.get("URL");
		String username = (String)db.get("USERNAME");
		String password = (String)db.get("PASSWORD");
		Connection conn = null;
		try{
			IDbCompartor idc = (IDbCompartor)SpringUtil.getBean("comparator." + type);
			if(idc == null){
				throw new Exception("暂未支持的数据库类型:" + type);
			}
			Map<String, Object> data = new HashMap<>();
			data.put("DB_ID", dbid);
			data.put("DESCR", descr);
			String createDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
			data.put("CREATE_DATE", createDate);
			DbUtil.saveOrUpdate("VERSION", data);
			String versionId = String.valueOf(DbUtil.queryOne("SELECT ID FROM VERSION WHERE DB_ID = ? AND CREATE_DATE = ?", dbid,createDate));
			conn = DbUtil.getConn(driver,url,username,password);
			conn.setAutoCommit(false);
			processor.process(versionId,conn, idc);
			conn.commit();
		}catch(Exception e){
			log.error(this,e);
			if(conn != null){
				conn.rollback();
			}
		}finally{
			DbUtil.closeJdbc(new Connection[]{conn}, null, null);
		}
	}
	
	@Transactional
	public void deleteVersion(String id)throws Exception {
		DbUtil.execute("DELETE FROM VERSION WHERE ID = ?",id);
		DbUtil.execute("DELETE FROM DB_DETAIL WHERE VERSION_ID = ?", id);
	}
	
	/**
	 * 获取表结构不同的表名
	 * @author cxxyjsj
	 * @date 2016年5月1日 下午2:05:15
	 * @param tableNames
	 * @return
	 * @throws Exception
	 */
	public List<String> getDiffTables(String srcId,String tarId,List<Object> tableNames)throws Exception {
		int size = tableNames.size();
		int count = size % 50 == 0 ? size / 50 : size / 50 + 1;
		List<Worker> workerList = new ArrayList<>(count);
		for(int i=0;i<count;i++){
			List<Object> list = null;
			if(i == count - 1){
				list = tableNames.subList(50 * i, size);
			}else{
				list = tableNames.subList(50 * i, (i + 1) * 50);
			}
			Worker worker = new Worker(srcId, tarId, list);
			workerList.add(worker);
		}
		for(Worker worker : workerList){
			worker.start();
		}
		for(Worker worker : workerList){
			worker.join();
		}
		List<String> results = new ArrayList<>();
		for(Worker worker : workerList){
			results.addAll(worker.getDiffTables());
		}
		return results;
	}
	
	/**
	 * 获取变更的SQL脚本
	 * @author cxxyjsj
	 * @date 2016年5月1日 下午8:26:37
	 * @param srcList
	 * @param tarList
	 * @return
	 */
	public String getChangeSql(String type, String tableName, List<ColumnInfo> srcList, List<ColumnInfo> tarList)throws Exception {
		IDbCompartor idc = (IDbCompartor)SpringUtil.getBean("comparator." + type);
		if(idc == null){
			throw new Exception("暂未支持的数据库类型:" + type);
		}
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		pw.println("/* ---------- " + tableName + " ---------- */");
		
		// 1. 新增的字段
		List<ColumnInfo> srcList2 = new ArrayList<>(Arrays.asList(new ColumnInfo[srcList.size()]));
		Collections.copy(srcList2, srcList);
		Map<String, ColumnInfo> src2Map = convertMap(srcList2);
		for(ColumnInfo col : tarList){
			src2Map.remove(col.getName());
		}
		for(Iterator<String> iter = src2Map.keySet().iterator();iter.hasNext();){
			String key = iter.next();
			ColumnInfo col = src2Map.get(key);
			pw.println(idc.getAddSql(col));
		}
		pw.println();
		
		// 2. 更新的字段
		Map<String, ColumnInfo> srcMap = convertMap(srcList);
		for(ColumnInfo col : tarList){
			ColumnInfo srcCol = srcMap.get(col.getName());
			if(srcCol == null){
				continue;
			}
			if(srcCol.equals(col)){
				continue;
			}
			pw.println(idc.getModifySql(srcCol));
		}
		pw.println();
		String result = sw.toString();
		pw.close();
		return result;
	}
	
	/**
	 * 转换列信息
	 * @author cxxyjsj
	 * @date 2016年5月1日 下午8:44:37
	 * @param cols
	 * @return
	 */
	private Map<String, ColumnInfo> convertMap(List<ColumnInfo> cols) {
		Map<String, ColumnInfo> map = new HashMap<>();
		for(ColumnInfo col : cols){
			map.put(col.getName(), col);
		}
		return map;
	}
}
