<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp" %>
<%
//업로드가 가능한 최대 파일 크기를 지정한다.
int size = 10 * 1024 * 1024;

MultipartRequest multi;
try
{
	multi = new MultipartRequest(request,uploadPath,size,"UTF-8",new DefaultFileRenamePolicy());
}catch(Exception e)
{
	 e.printStackTrace();
	 
	response.sendRedirect("write.jsp");
	return;
}

String btitle   = multi.getParameter("title");
String bkind    = multi.getParameter("bkind");
String bcontent = multi.getParameter("content").split("<img")[0];
String nowpage  = multi.getParameter("page");
btitle = btitle.replace("<", "&lt;").replace(">", "&gt;");
bcontent = bcontent.replace("<p>", "").replace("</p>", "");

//업로드된 파일명을 얻는다.
Enumeration files = multi.getFileNames();
List<FileVO> fileVOs = new ArrayList<>(); // 파일 정보를 저장할 리스트

while (files.hasMoreElements())
{
    String name = (String) files.nextElement();
    String filename = multi.getFilesystemName(name);
    
    if(filename != null)
    {
        String phyname = UUID.randomUUID().toString();
        String srcName = uploadPath + "/" + filename;
        String targetName = uploadPath + "/" + phyname;
        File srcFile = new File(srcName);
        File targetFile = new File(targetName);
        srcFile.renameTo(targetFile);
        
        FileVO fileVO = new FileVO();
        fileVO.setFname(filename);
        fileVO.setPname(phyname);
        
        fileVOs.add(fileVO);
    }
}

// 게시물을 저장한다
BoardVO bvo = new BoardVO();
bvo.setBtitle(btitle);
bvo.setBcontent(bcontent);
bvo.setBkind(bkind);
bvo.setUno(login.getUno());

BoardDTO bdto = new BoardDTO();
bdto.Insert(bvo);

// 파일 정보를 저장한다
FileDTO fdto = new FileDTO();
for(FileVO fileVO : fileVOs)
{
    fileVO.setBno(bvo.getBno());
    fdto.FileUpload(fileVO, bvo.getBno());
}
%>      
<script>
window.onload = function()
{
	alert("작성 되었습니다");
	
	window.location.href = "view.jsp?no=<%= bvo.getBno() %>&page=<%= nowpage %>";
}
</script>
