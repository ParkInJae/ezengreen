<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="include/common.jsp" %> 
<%
String uid = request.getParameter("uid");
String upw = request.getParameter("upw");
String refer = request.getParameter("refer");
if(refer ==null)
{
	response.sendRedirect("login.jsp");
	return;
}
if( uid == null || upw == null )
{
	//로그인 정보가 올바르게 전송되지 않음.
	response.sendRedirect("login.jsp");
	return;
}
UserDTO dto = new UserDTO();
UserVO  vo  = dto.Login(uid,upw);
if(vo == null)
{	
%>
	<script>
	window.onload = function()
	{
		alert("아이디 또는 비밀번호가 일치하지 않습니다.");
		window.location.href = "login.jsp"
	}
	</script>
<%
}else
{	
	session.setAttribute("login", vo);
	if(refer.equals("http://localhost:8080/ezengreen_06/resetPWok.jsp"))
	{
		response.sendRedirect("index.jsp");
	}else
	{
		response.sendRedirect(refer);
	}
}
%>
	