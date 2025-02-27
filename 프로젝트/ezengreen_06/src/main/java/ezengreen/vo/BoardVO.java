package ezengreen.vo;

public class BoardVO
{
	private String bno; 	  // 게시물번호
	private String uno; 	  // 회원번호
	private String btitle;	  // 제목	
	private String bcontent;  // 내용
	private String bkind; 	  // 게시판구분
	private String bwdate; 	  // 작성일
	private String bhit; 	  // 조회수
	private String fname; 	  // 논리파일명(원래이름)
	private String pname; 	  // 물리파일명(저장되는이름)
	private String uname; 	  // 작성자이름
	private String rno; 	  // 댓글번호
	private String[] fno; 	  // 첨부파일번호
	
	public BoardVO() {}
	
	public BoardVO(String bno, String btitle, String bcontent,String bkind) {
		this.bno = bno;
		this.btitle = btitle;
		this.bcontent = bcontent;
		this.bkind = bkind;
	}

	public String getBno()      { return bno; 	   }
	public String getUno()      { return uno;	   }
	public String getBtitle()   { return btitle;   }
	public String getBcontent() { return bcontent; }
	public String getBkind()    { return bkind;	   }
	public String getBwdate()   { return bwdate;   }
	public String getBhit() 	{ return bhit;	   }
	public String getFname()    { return fname;	   }
	public String getPname()    { return pname;    }
	public String[] getFno() 	{ return fno;	   }
	public String getUname()    { return uname;	   }
	public String getRno() 		{ return rno;	   }
	
	
	public void setBno(String bno)			 {	this.bno 	  = bno;	  }
	public void setUno(String uno)			 {	this.uno 	  = uno;	  }
	public void setBtitle(String btitle)	 {	this.btitle   = btitle;	  }
	public void setBcontent(String bcontent) {	this.bcontent = bcontent; }
	public void setBkind(String bkind) 		 {	this.bkind    = bkind;	  }
	public void setBwdate(String bwdate)	 {	this.bwdate   = bwdate;	  }
	public void setBhit(String bhit) 		 {	this.bhit     = bhit;	  }
	public void setFname(String fname) 		 {	this.fname    = fname;	  }
	public void setPname(String pname)		 {	this.pname    = pname;	  }
	public void setFno(String[] fno) 		 {	this.fno      = (String[]) fno;	}
	public void setUname(String uname)		 {	this.uname    = uname;	  }
	public void setRno(String rno) 			 {	this.rno 	  = rno;	  }
}
