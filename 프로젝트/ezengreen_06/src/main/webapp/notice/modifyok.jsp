<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp" %>
<%
request.setCharacterEncoding("utf-8");

BoardVO bvo  = new BoardVO();
FileDTO fdto = new FileDTO();
//업로드가 가능한 최대 파일 크기를 지정한다.
int size = 10 * 1024 * 1024;
MultipartRequest multi;
try
{
	multi = new MultipartRequest(request,uploadPath,size,
			"UTF-8",new DefaultFileRenamePolicy());
}catch(Exception e)
{
	response.sendRedirect("index.jsp");
	return;
}

String bno       = request.getParameter("no");
String nowpage   = multi.getParameter("page");
String btitle    = multi.getParameter("title");
String bkind     = multi.getParameter("bkind");
String bcontent  = multi.getParameter("content");
String[] fno     = multi.getParameterValues("fno");
btitle = btitle.replace("<", "&lt;").replace(">", "&gt;");

if(bkind == null) bkind = "N";

//게시물을 저장한다.
bvo.setBno(bno);
bvo.setBtitle(btitle);
bvo.setBkind(bkind);
bvo.setBcontent(bcontent);

BoardDTO bdto = new BoardDTO();
bdto.Update(bvo);

//업로드된 파일명을 얻는다.
Enumeration files = multi.getFileNames();

// 삭제 요청한 첨부파일을 지운다. 
if(fno != null)
{
	for(String f : fno)
	{
		fdto.FileDelete(f);
	}
}
while(files.hasMoreElements()) 
{
	String name     = (String) files.nextElement();
	String filename = (String) multi.getFilesystemName(name);
	//첨부파일을 등록한다.
	if(filename == null)
	{
		//업로드 된 파일명이 null
		continue;
	}
	
	String phyname    = UUID.randomUUID().toString();
	String srcName    = uploadPath + "/" + filename;
	String targetName = uploadPath + "/" + phyname;
	File srcFile      = new File(srcName);
	File targetFile   = new File(targetName);
	srcFile.renameTo(targetFile);

	// 첨부파일을 등록한다.		
	if(filename != null)
	{
		FileVO fvo = new FileVO();
		fvo.setBno(bvo.getBno());
		fvo.setPname(phyname); 		//bvo.getPname()이 아닌 이유는 새로운 파일에 대한 값을 넣기 때문에 위에서 설정한 phyname을 넣는다.
		fvo.setFname(filename);		//bvo.getFname()이 아닌 이유는 새로운 파일에 대한 값을 넣기 때문에 위에서 설정한 filename을 넣는다.
		fdto.FileUpload(fvo, bvo.getBno());
	}
}

%>         
<script>
window.onload = function()
{
	alert("수정되었습니다.");
	
	window.location.href = "view.jsp?no=<%= bno %>&page=<%= nowpage%>";
}
</script>
