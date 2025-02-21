<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include file="include/head.jsp" %>
<%

String year = request.getParameter("year");
String month = request.getParameter("month");
String day = request.getParameter("day");
String bno     = request.getParameter("no");
String kind    = request.getParameter("kind");

if(login == null || !login.getUid().equals("admin"))
{
	response.sendRedirect("index.jsp");
	return;
}

if(bno == null)
{
	response.sendRedirect("index.jsp");
	return;
}
if(kind == null)	{ kind = "S"; }

BoardDTO bdto = new BoardDTO();
BoardVO bvo = bdto.Read(bno, false);
FileDTO fdto = new FileDTO();


%>
<style>

.maintable > *
{
	font-size : 10pt;
	background-color : white;
}

</style>
<script>
//스마트 에디터
let oEditors = []
	
smartEitor = function()
{
 	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "content",
		sSkinURI: "../SmartEditor2/SmartEditor2Skin.html",
		fCreator: "createSEditor2",
		htParams : 
		{
			// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseToolbar : true,
			// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : false,
			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true, 
 	      }
	});
};
	
$(document).ready(function(){
	smartEitor();
});

function submitPost()
{
	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD",[]);
	let content = document.getElementById("content").value ;
	let title = $("#title").val();
		
	if(title == "")
	{
		alert("제목을 입력해주세요.");
		return false;
	} 
	if(content == "<p>&nbsp;</p>")
	{ 
		alert("내용을 입력해주세요.");
		oEditors.getById["content"].exec("FOCUS");
		return false;
	}
	
	let confirmSubmit = confirm("글을 수정하시겠습니까?");
	return confirmSubmit;

}
function cancel()
{
	let confirmSubmit = confirm("수정을 취소하시겠습니까?");
	
	if(confirmSubmit) 
	{
		history.back();
	}
	return confirmSubmit
	
}
window.onload = function()
{
	//첨부파일 추가 버튼 이벤트 리스너
	$("#btnAdd").click(function(){
		AddAttach();
	});
	
	AddAttach();
}

//첨부파일 추가
function AddAttach()
{
	$.ajax({
		url : "attach_mo.jsp",
		type : "get",
		dataType : "html",
		success : function(response){
			response = response.trim();
			$("#tblUpload").append(response);
		}
	});				
}

//첨부파일 삭제 
function RemoveAttach(obj)
{
	var tr = $(obj).parent().parent();
	tr.remove();
}
</script>
<form id="select_form" name="select_form" action="modifyok.jsp?no=<%=bno %>" enctype="multipart/form-data" method="post" onsubmit="return submitPost();">
	<input type="hidden" name="bkind" value="S">
	<input type="hidden" name="year" value="<%=year%>">
	<input type="hidden" name="month" value="<%=month%>">
	<input type="hidden" name="day" value="<%=day%>">
	<table border="0" width="100%" height="430px" style="text-align:center; height:430px" class="maintable">
		<tr>
			<td colspan="5" align="left" style="font-size: 14pt; font-weight: 900;"><b>경기일정 - 수정하기</b></td>
		</tr>
		<tr>
			<td colspan="5" height="1px">								
				<hr size="1" style="width: 99%; height: 1px; background-color: dimgrey">
			</td>
		</tr>
				<tr>
			<td width="75px">제목 :</td>
			<td colspan="4" align="left"><input type="text" id="title" name="title" style="width: 98%" value="<%= bvo.getBtitle() %>"></td>
		</tr>
		<tr>
			<td width="75px">내용 :</td>
			<td colspan="4" height="200px" align="left">
				<textarea name="content" id="content" rows="15" cols="77"><%= bvo.getBcontent() %></textarea>
			</td>	                			
		</tr>
		<tr>
			<td style="font-size:10pt" width="75px"><input type="button" id="btnAdd" name="btnAdd" value="파일추가"></td> 
			<td id="tblUpload" style="text-align: left;"></td>   				
		</tr>
		<tr>
			<td style="font-size: 9pt;">기존 파일</td>
			<td colspan="4" align="left">
				<table border="0" style="width:100%;background-color:#cccccc" cellpadding="3" cellspacing="1">
					<tr style="background-color:#f4f4f4;">
						<th style="width:50px;">삭제</th>
						<th>파일명</th>
					</tr>
					<%
					ArrayList<FileVO> list = fdto.FileRead(bno);

					for(FileVO item : list)
					{	
						%>
						<tr style="background-color:white;">
							<td align="center"><input type="checkbox" id="fno" name="fno" value="<%= item.getFno() %>"></td>						
							<td align="left"><a href="down.jsp?fno=<%= item.getFno() %>"><%= item.getFname()%></a></td>
						</tr>
						<%
					}
					%>
				</table>
			</td>
		</tr>			
		<tr>
			<td colspan="10" height="50px" style="background-color:white;" align="center">
	 			<input type="submit" value="수정하기" id="writeAction_btn" style="width:80px;height:30px;">
				<input type="button" value="취소" onClick="cancel()" style="width:80px;height:30px;">
			</td>
		</tr>
	</table>
</form>
<%@ include file="include/tail.jsp" %>
