package ezengreen.dto;

import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import ezengreen.dao.*;
import ezengreen.vo.UserVO;

public class UserDTO extends DBManager
{
	//아이디 중복 검사
	//리턴값 : 트루 == 중복 , 펄스 == 노중복
	public boolean CheckID(String uid)
	{
		this.DBOpen();
		String sql = "";
		sql = "select uid from user where uid = '" + uid + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == true)
		{
			//아이디가 있음 중복
			this.DBClose();
			return true;
		}
		this.DBClose();
		return false;
	}
	
	//회원가입 처리
	public boolean Join(UserVO vo)
	{
		if( CheckID(vo.getUid()) == true )
		{
			return false;
		}
		
		this.DBOpen();
		
		String sql = "";
		sql  = "insert into user (uid,upw,uname,uemail) ";
		sql += "values ( ";
		sql += "'" + vo.getUid()     + "', ";
		sql += "md5('" + vo.getUpw() + "'), ";
		sql += "'" + vo.getUname()   + "', ";
		sql += "'" + vo.getUemail()   + "' ";
		sql += ") ";
		this.RunSQL(sql);
		
		// 가입된 회원 번호를 얻는다
		sql = "select last_insert_id() as uno ";
		this.OpenQuery(sql);
		this.GetNext();
		vo.setUno(this.GetValue("uno"));
		
		this.DBClose();	
		return true;
	}
	
	//회원 로그인 처리
	public UserVO Login(String uid, String upw)
	{
		this.DBOpen();
		
		String sql = "";
		sql  = "select uno,uname,uemail,admin from user ";
		sql += "where uid = '" + uid + "' ";
		sql += "and upw = md5('" + upw + "') ";
		this.OpenQuery(sql);
		
		if(this.GetNext() == false)
		{
			//회원정보다 없다는 뜻
			this.DBClose();
			return null;
		}
		
		UserVO vo = new UserVO();
		vo.setUid(uid);
		vo.setUpw(upw);
		vo.setUno(this.GetValue("uno"));
		vo.setUname(this.GetValue("uname"));								
		vo.setAdmin(this.GetValue("admin"));								
		vo.setUemail(this.GetValue("uemail"));
		this.DBClose();
		return vo;
	}
	
	//비밀번호 찾기
	public boolean findPWEmail(String uname, String uemail)
	{
		this.DBOpen();
		
		String sql ="";
		sql = "select * from user ";
		sql += "where uname = '" + uname + "' ";
		sql += "and ";
		sql += "uemail = '" + uemail + "' ";
		this.OpenQuery(sql);
		
		if(this.GetNext() == false)
		{
			//회원정보다 없다는 뜻
			this.DBClose();
			return false;
		}
		this.DBClose();
		return true;
		
	}
	
	//아이디 찾기
	public UserVO findIDok(String uname, String uemail)
	{
		
		this.DBOpen();
		String sql ="select uid from user ";
		sql += "where uname = '" + uname +"'";
		sql += "and uemail = '" + uemail + "' ";
		this.OpenQuery(sql);		
		
		if(this.GetNext() == false)
		{
			//회원정보다 없다는 뜻
			this.DBClose();
			return null;
		}else
		{	//sql문 돌렸을때 값이 있다면 uid를 가져온다
			UserVO vo = new UserVO();
			String uid = this.GetValue("uid");
			vo.setUid(uid);
		    this.CloseQuery(); // SQL 실행을 닫습니다.
	        this.DBClose();
	        return vo;
		}
	}
	
	//비번 찾기
	public boolean findPWok(String uid, String uemail)
	{
		
		this.DBOpen();
		String sql ="select * from user ";
		sql += "where uid = '" + uid +"'";
		sql += "and uemail = '" + uemail + "' ";
		this.OpenQuery(sql);		
		
		if(this.GetNext() == false)
		{
			//회원정보다 없다는 뜻
			this.DBClose();
			return false;
		}
		this.DBClose();
	    return true;
		
	}
	
	//비밀번호 변경(로그인시)
		public UserVO resetPW(String uno, String reupw)
		{
			this.DBOpen();
			String sql = "";
			//해당 게시물 번호에 대한 정보를 수정한다.
			sql  = "update user ";
			sql += "set ";
			sql += "upw = md5('" + reupw + "') ";
			sql += "where uno = '" + uno + "' ";

			this.RunSQL(sql);
			UserVO vo = new UserVO();
			String upw = this.GetValue("reupw");
			vo.setUpw(upw);
			this.DBClose();	
			return vo;
		}
	//비밀번호 변경(비로그인시)
		public UserVO resetPW2(String uid, String reupw)
		{
			this.DBOpen();
			String sql = "";
			//해당 게시물 번호에 대한 정보를 수정한다.
			sql  = "update user ";
			sql += "set ";
			sql += "upw = md5('" + reupw + "') ";
			sql += "where uid = '" + uid + "' ";

			this.RunSQL(sql);
			UserVO vo = new UserVO();
			String upw = this.GetValue("reupw");
			vo.setUpw(upw);
			this.DBClose();	
			return vo;
		}
		
		public boolean checknowpw(String uno,String person)
		{
			this.DBOpen();
			String sql ="select * from user ";
			sql += "where uno ='" + uno + "' ";
			sql += "and upw =md5('" + person + "')";
			System.out.println(sql);
			this.OpenQuery(sql);
			
			if(this.GetNext() == false)
			{
				this.DBClose();	
				return false;

			}
			this.DBClose();	
			return true;
			
		}
		
}
